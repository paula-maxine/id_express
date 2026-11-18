# ID Express

ID Express is a Flutter + Firebase application that moves a national identity
card application process online. It is modelled on the workflow of Uganda's
National Identification and Registration Authority (NIRA): a citizen registers,
fills in a four-step application, uploads supporting documents and books a
service-centre appointment; staff review the application, approve or reject it
with a reason, mark biometrics as captured and manage the appointment queue; an
administrator assigns staff roles. Every role uses the same app, and the
signed-in user's `role` field decides which home screen and routes they reach.

This repository is a single, self-contained unit: one Flutter client with its
Firebase security rules, index definitions and release scripts. There is no
separate backend service in this package. All reads and writes go directly from
the client to Cloud Firestore and Cloud Storage, and authorization is enforced
by `firestore.rules` and `storage.rules`.

---

## Reviewer Quick Start

Recommended reading order:

1. This README
2. [docs/SYSTEM_DEEP_DIVE.md](docs/SYSTEM_DEEP_DIVE.md) — how the system works
3. [docs/CODEBASE_MAP.md](docs/CODEBASE_MAP.md) — where everything lives
4. [docs/FEATURE_CATALOG.md](docs/FEATURE_CATALOG.md) — what it does
5. [docs/TECHNICAL_HIGHLIGHTS.md](docs/TECHNICAL_HIGHLIGHTS.md) — the interesting engineering
6. [docs/ENGINEERING_DECISIONS.md](docs/ENGINEERING_DECISIONS.md) — why it is built this way
7. [docs/SENSITIVE_MATERIAL_REMOVED.md](docs/SENSITIVE_MATERIAL_REMOVED.md) — what was excluded and how to restore it
8. [run_instruction.md](run_instruction.md) — full setup, build, run and troubleshooting

The fastest code path to read is: `lib/main.dart` → `lib/routes/router.dart`
→ `lib/features/auth/view_model/auth_providers.dart` →
`lib/features/application_form/` → `lib/features/officer/` → `firestore.rules`.

---

## Technology Stack

Versions are the constraints declared in `pubspec.yaml`; resolved versions are
in `pubspec.lock`.

| Concern | Technology (constraint) |
| --- | --- |
| Language / SDK | Dart `^3.10.4` (Flutter SDK, version not pinned in the repo) |
| State management | `flutter_riverpod ^3.2.1`, `riverpod_annotation ^4.0.2`, `riverpod_generator ^4.0.3` (code generation) |
| Navigation | `go_router ^17.1.0`, router exposed as a generated Riverpod provider |
| Authentication | `firebase_auth ^6.1.4` (email and password) |
| Database | `cloud_firestore ^6.1.2` with offline persistence enabled |
| File storage | `firebase_storage ^13.0.6` |
| Push | `firebase_messaging ^16.1.1` (permission request and token storage only) |
| Core | `firebase_core ^4.4.0` |
| Media | `image_picker ^1.2.1` |
| UI | Material 3, `google_fonts ^8.0.2`, `intl ^0.20.2` |
| IDs | `uuid ^4.5.3` |
| Serialization | `json_annotation ^4.11.0`, `json_serializable ^6.13.0` (legacy data layer only) |
| Lints | `flutter_lints ^6.0.0`, `riverpod_lint ^3.1.3` |
| Tests | `flutter_test` |
| Android build | Android Gradle Plugin 9.0.1, Kotlin 2.3.20, Gradle 9.1.0, Java 17 |
| iOS / macOS | iOS deployment target 15.0, macOS 10.15 |

Several declared packages are not imported by the live app (see
[docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md)).

---

## Architecture

The app follows a feature-first layout with an MVVM split inside each feature.
Feature services talk to Firebase directly; there is no repository layer in the
live code path.

```text
                 ┌──────────────────────────────────────────────┐
  Widgets        │ lib/features/<feature>/view/*.dart            │  ConsumerWidget / ConsumerStatefulWidget
                 └───────────────┬──────────────────────────────┘
                                 │ ref.watch / ref.read
                 ┌───────────────▼──────────────────────────────┐
  View models    │ lib/features/<feature>/view_model/*.dart      │  @riverpod StreamProviders over Firestore
                 │                                              │  + small Notifier classes for form state
                 └───────────────┬──────────────────────────────┘
                 ┌───────────────▼──────────────────────────────┐
  Services       │ lib/features/<feature>/service/*.dart         │  ApplicationService, OfficerReviewService,
                 │                                              │  AppointmentService, DocumentService,
                 │                                              │  AdminService, AuthService, NotificationService
                 └───────────────┬──────────────────────────────┘
                 ┌───────────────▼──────────────────────────────┐
  Models         │ lib/features/models/*.dart                    │  hand-written fromMap / toMap, snake_case keys
                 └───────────────┬──────────────────────────────┘
                                 │ Firebase SDKs
                 ┌───────────────▼──────────────────────────────┐
  Firebase       │ Auth · Firestore (+ rules, indexes) · Storage │  firestore.rules, storage.rules,
                 │ (+ rules) · Cloud Messaging                   │  firestore.indexes.json
                 └──────────────────────────────────────────────┘
```

Routing is a single `GoRouter` built inside a `keepAlive` Riverpod provider. Its
`redirect` callback watches the Firebase Auth stream and the signed-in user's
Firestore profile, so a role change made by an administrator re-evaluates the
guards without a restart. See [docs/SYSTEM_DEEP_DIVE.md](docs/SYSTEM_DEEP_DIVE.md).

---

## Repository Structure

```text
id_express/
├── lib/
│   ├── main.dart              entry point: error zones, Firebase init, Firestore persistence
│   ├── app/                   root MaterialApp.router
│   ├── app_exporter.dart      barrel export used by every feature file
│   ├── core/                  theme, design tokens, extensions, validators, Printer logger, shared widgets
│   ├── features/              the live application (10 feature folders + shared models/)
│   ├── routes/                go_router config, role guards, path constants
│   ├── data/                  earlier data layer; only the audit writer is used by the live app
│   ├── global/ services/ utils/   earlier code, not imported by the live app
│   └── firebase_options.dart  FlutterFire-generated client configuration
├── test/                      2 test files
├── scripts/                   version bump and test-build distribution (AppSend)
├── firestore.rules            role-based Firestore authorization
├── firestore.indexes.json     9 composite indexes backing the app's queries
├── storage.rules              per-user document storage rules, 20 MB cap
├── firebase.json              Firestore, Hosting and FlutterFire platform config
├── android/ ios/ macos/ web/ windows/ linux/   platform runners
└── docs/                      reviewer documentation suite
```

Details per directory: [docs/CODEBASE_MAP.md](docs/CODEBASE_MAP.md).

---

## Setup

Full instructions with versions and troubleshooting are in
[run_instruction.md](run_instruction.md). In short:

```bash
flutter pub get
flutterfire configure          # point the app at your own Firebase project
firebase deploy --only firestore:rules,firestore:indexes
flutter run
```

`storage.rules` is not referenced from `firebase.json`; deploy it from the
Firebase console or add a `storage` entry first (see run_instruction.md).

Generated `*.g.dart` files are committed, so `build_runner` is only needed after
changing an annotated provider or model:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Environment

The app has no `.env` file and reads no `String.fromEnvironment` values. All
environment-specific configuration is Firebase client configuration:

| File | Generated by | Purpose |
| --- | --- | --- |
| `lib/firebase_options.dart` | `flutterfire configure` | Per-platform `FirebaseOptions` |
| `android/app/google-services.json` | `flutterfire configure` or Firebase console | Android Firebase config |
| `ios/Runner/GoogleService-Info.plist` | `flutterfire configure` or Firebase console | iOS Firebase config |
| `firebase.json` (`flutter` block), `.firebaserc` | `flutterfire configure` / `firebase use` | Project and app IDs used by the CLIs |

These files currently point at the original owner's Firebase project. The
`AIza...` values in them are Firebase client identifiers (public by design and
shipped in every client build), not secrets; access is controlled by the
security rules. A new owner regenerates all of them for their own project. See
[docs/SENSITIVE_MATERIAL_REMOVED.md](docs/SENSITIVE_MATERIAL_REMOVED.md).

## Running

```bash
flutter run                    # default device
flutter run -d chrome          # web
flutter run -d <device-id>     # Android / iOS device or emulator
```

## Testing

```bash
flutter analyze
flutter test
```

Current state (verified 2026-11-18 with Flutter 3.47.8 / Dart 3.13.7):
`flutter analyze` reports no issues; `flutter build web`,
`flutter build apk --debug` and `flutter build ios --debug --no-codesign`
succeed; `flutter test` runs 2 tests, 1 passes
(`App smoke test`) and 1 fails (`ApplicationModel JSON serialization roundtrip`,
a pre-existing failure in the unused legacy model, documented in
[docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md)).

## Building

```bash
flutter build apk --release --split-per-abi   # Android (as used by scripts/deploy_testing.dart)
flutter build ipa --release                   # iOS (needs your own signing team)
flutter build web                             # Web
```

Test builds are distributed with `dart scripts/deploy_testing.dart --build`
(bumps the version, builds, uploads to AppSend). See `scripts/README.md`.

---

## Feature Walkthrough

1. **Registration and sign-in.** Email/password via Firebase Auth. Registration
   writes `/users/{uid}` with `role: applicant`; if the profile write fails the
   new Auth account is deleted so no orphan account is left. Sign-in reads the
   profile and only creates one if none exists.
2. **Role routing.** The router sends applicants to `/applicant-home` and
   officers, supervisors and admins to `/officer-home`, and blocks each group
   from the other's routes.
3. **Application.** Four steps (personal, family, address, review) for one of
   four service types (new registration, renewal, replacement, change of
   particulars). Previous NIN is required for every type except new
   registration.
   Submission writes an `applications` document with status `submitted`.
4. **Tracking.** The applicant sees live status through a Firestore stream and a
   six-stage timeline, the rejection reason if rejected, and a contextual
   action: upload documents (draft or rejected) or book an appointment
   (approved).
5. **Documents.** Images are picked from the gallery, uploaded to
   `documents/{uid}/{applicationId}/...` in Cloud Storage with live progress, and
   recorded in the `documents` collection.
6. **Review.** Staff see submitted and under-review applications oldest first,
   open an application with its documents, approve with notes, reject with a
   mandatory reason, or mark biometrics captured on an approved application.
   Each action writes an `audit_logs` entry.
7. **Appointments.** An approved applicant picks one of six centres, a weekday
   1 to 90 days ahead and one of seven time slots; a queue number is generated.
   Staff see all appointments and mark them done; past confirmed appointments
   are shown as overdue immediately and persisted as overdue in a batch write.
8. **Administration.** Admins list all users and change roles; each change is
   audited.
9. **Notifications and profile.** Users can opt in to push (the FCM token is
   saved to their profile), read an in-app notification list with unread
   counts, and sign out.

Each feature is described in detail in [docs/FEATURE_CATALOG.md](docs/FEATURE_CATALOG.md);
a bullet list is in [FEATURES.md](FEATURES.md).

## Integrations

| Service | Used for | Where |
| --- | --- | --- |
| Firebase Authentication | Email/password accounts | `lib/features/auth/service/auth_service.dart` |
| Cloud Firestore | All application data, real-time streams | every `view_model/` and `service/` file |
| Cloud Storage for Firebase | Document images | `lib/features/documents/service/document_service.dart` |
| Firebase Cloud Messaging | Permission request and token storage | `lib/features/notifications/service/notification_service.dart` |
| Firebase Hosting | Web hosting config with cache headers | `firebase.json` |
| AppSend | Test-build distribution (no API key) | `scripts/deploy_testing.dart` |
| Google Fonts | Typography (fetched at runtime) | `lib/core/theme/text_styles.dart` |

## Security

- Authorization lives in `firestore.rules`. Role is read from the caller's
  `/users/{uid}` document. Users cannot create their own profile with any role
  other than `applicant`, and only admins may change a `role` field.
- Applicants can read and write only documents whose `applicant_id` is their
  uid; document metadata inherits ownership from its parent application.
- `audit_logs` is append-only: staff create, admins read, nobody updates or
  deletes.
- `notifications` can only be created by staff, and read or marked read only by
  their owner.
- `storage.rules` scopes uploads to `documents/{uid}/...`, lets staff read all
  documents, and caps uploads at 20 MB.
- Everything not matched is denied in both rule files.

Known gaps (for example, an applicant can update any field of their own
application, including `status`) are listed in
[docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md).

## Database

Cloud Firestore, top-level collections only, `snake_case` field names,
timestamps stored as ISO-8601 strings:

| Collection | Key fields | Written by |
| --- | --- | --- |
| `users` | `user_id`, `role`, `email`, `phone_number`, `display_name`, `fcm_token` | AuthService, AdminService, NotificationService |
| `applications` | `application_id`, `applicant_id`, `application_type`, `status`, personal/family/address fields, `reviewed_by`, `officer_notes`, `rejection_reason` | ApplicationService |
| `documents` | `document_id`, `application_id`, `applicant_id`, `document_type`, `file_url` | DocumentService |
| `appointments` | `appointment_id`, `application_id`, `applicant_id`, `center_id`, `appointment_date`, `time_slot`, `queue_number`, `status` | AppointmentService |
| `notifications` | `user_id`, `type`, `title`, `message`, `is_read`, `created_at` | not written by this app (read only) |
| `audit_logs` | `user_id`, `user_role`, `action`, `target_collection`, `target_doc_id`, `details`, `timestamp` | OfficerReviewService, AdminService |

Composite indexes for every multi-field query are declared in
`firestore.indexes.json`.

---

## What Is Not Included

- No backend or Cloud Functions. Nothing in this repository creates
  `notifications` documents or sends push messages; a server-side sender would
  have to be added.
- No sample data or seed scripts. A fresh project starts empty.
- No real user data. Earlier AI-tool prompts, thesis reference files, a
  plaintext credentials file and stale generated status documents were removed;
  see [docs/SENSITIVE_MATERIAL_REMOVED.md](docs/SENSITIVE_MATERIAL_REMOVED.md).
- No release signing configuration (Android release uses the debug key, as in
  the Flutter template).

## What the Buyer Must Configure

- **Development:** Flutter SDK supporting Dart `^3.10.4`; Xcode for Apple
  targets; Android SDK and Java 17 for Android.
- **Database:** a Firebase project with Cloud Firestore; deploy
  `firestore.rules` and `firestore.indexes.json`.
- **Authentication:** enable the Email/Password provider; create the first admin
  by editing that user's `role` to `admin` in the Firestore console (the rules
  prevent self-promotion).
- **Cloud infrastructure:** run `flutterfire configure` to regenerate
  `lib/firebase_options.dart`, `android/app/google-services.json`,
  `ios/Runner/GoogleService-Info.plist` and the `firebase.json` `flutter` block;
  update `.firebaserc`.
- **Storage:** enable Cloud Storage and deploy `storage.rules` (from the
  console, or after adding a `storage` entry to `firebase.json`, which does not
  reference it today).
- **Notifications:** for iOS push, add an APNs key in the Firebase console and the
  Push Notifications capability in Xcode; add a server-side sender if
  notifications are wanted.
- **Production deployment:** replace the `com.example` application IDs, the Apple
  development team and the debug release signing; for web, `firebase deploy
  --only hosting`.

## Known Limitations

Summarised from [docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md): an inactive legacy
data layer sits beside the live feature code; one of two tests fails; no
in-app path creates notifications; document upload uses `dart:io` and so does
not work on web; centres and time slots are hard-coded with no capacity check;
"Change Password", OTP verification and the officer "View" document button are
placeholders; macOS and Linux Firebase options are unconfigured.

## Documentation Index

| Document | Contents |
| --- | --- |
| [FEATURES.md](FEATURES.md) | Bullet list of implemented features and source-file count |
| [run_instruction.md](run_instruction.md) | Prerequisites, configuration, commands, deployment, troubleshooting |
| [CHANGELOG.md](CHANGELOG.md) | Change history |
| [scripts/README.md](scripts/README.md) | Version bump and test-build distribution scripts |
| [docs/SYSTEM_DEEP_DIVE.md](docs/SYSTEM_DEEP_DIVE.md) | Architecture, data flow, workflows, failure handling, security |
| [docs/CODEBASE_MAP.md](docs/CODEBASE_MAP.md) | Directory-by-directory map |
| [docs/FEATURE_CATALOG.md](docs/FEATURE_CATALOG.md) | Every feature with implementation and business rules |
| [docs/TECHNICAL_HIGHLIGHTS.md](docs/TECHNICAL_HIGHLIGHTS.md) | The strongest engineering in the codebase |
| [docs/ENGINEERING_DECISIONS.md](docs/ENGINEERING_DECISIONS.md) | Observed decisions, evidence and trade-offs |
| [docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md) | Bugs, technical debt, limitations |
| [docs/SENSITIVE_MATERIAL_REMOVED.md](docs/SENSITIVE_MATERIAL_REMOVED.md) | Register of removed and sanitized material |
| [docs/SUBMISSION_MANIFEST.md](docs/SUBMISSION_MANIFEST.md) | Inventory of this submission |
