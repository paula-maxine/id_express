# System Deep Dive

[Back to README](../README.md)

## Architecture

ID Express is a client-only Firebase application. The Flutter client is the
only executable component in this package: it authenticates with Firebase
Auth, reads and writes Cloud Firestore and Cloud Storage directly, and relies on
`firestore.rules` and `storage.rules` as the server-side authorization layer.
There is no API server, Cloud Function or scheduled job in the repository.

Inside the client, the live code path is:

```text
lib/main.dart
  └─ ProviderScope
       └─ IdExpress (lib/app/id_express.dart)         MaterialApp.router
            ├─ appThemeProvider (lib/core/theme)
            └─ goRouterProvider (lib/routes/router.dart)
                 └─ feature screens (lib/features/*/view)
                      ├─ view_model providers   Firestore snapshot streams, form state
                      └─ services               Firestore / Storage / Messaging writes
```

Everything the live app imports is reached through `lib/app_exporter.dart`,
which re-exports Flutter, Riverpod, go_router, the Firebase SDKs, `core/`,
`features/` and `routes/`. The `lib/data/`, `lib/global/`, `lib/services/`
and `lib/utils/` folders are an earlier implementation. Only two files from
`lib/data/` are imported by the live app: `data/cloud/audit_cloud_service.dart`
and `data/model/audit_log_model.dart`, used for audit writes (see
[KNOWN_ISSUES.md](KNOWN_ISSUES.md)).

## Component Responsibilities

| Component | Responsibility |
| --- | --- |
| `lib/main.dart` | Installs three error sinks (`FlutterError.onError`, `PlatformDispatcher.onError`, `runZonedGuarded`), filters a known Flutter-web hot-restart assertion, initializes Firebase, enables Firestore persistence with unlimited cache |
| `lib/routes/router.dart` | Single `GoRouter` in a `keepAlive` provider; role-based `redirect`; 18 routes |
| `lib/features/auth` | Sign-in, registration with rollback, auth and profile streams, login/register form state |
| `lib/features/application_form` | Four-step wizard; one Notifier provider per field; `ApplicationService` writes and status updates |
| `lib/features/applications` | Applicant list with status filter, live detail stream, status timeline, contextual next action |
| `lib/features/documents` | Picks images, uploads to Storage with progress, writes metadata |
| `lib/features/appointments` | Booking (centre, date, slot, queue number), cancellation, staff "mark done", overdue sweep |
| `lib/features/officer` | Staff dashboard queues, review screen, approve / reject / biometrics, audit writes |
| `lib/features/admin` | User list and role assignment with audit |
| `lib/features/notifications` | FCM permission and token storage; in-app list and unread count |
| `lib/features/profile` | Profile view, notification opt-in, sign-out |
| `lib/features/models` | Hand-written domain models and enums used by every feature |
| `lib/core` | Theme, design tokens, extensions, validators, `Printer` logger, shared widgets |
| `firestore.rules` / `storage.rules` | Role-based authorization; the only server-side enforcement |
| `firestore.indexes.json` | Composite indexes matching the app's compound queries |
| `scripts/` | Version bump and AppSend test-build upload |

## Data Flow

Reads are real-time Firestore streams exposed as Riverpod `StreamProvider`s;
widgets render them with `AsyncValue.when`. Writes go through a feature service
that calls the Firebase SDK directly.

```text
User action → Widget → ref.read(<feature>ServiceProvider).method(...)
  → Service reads the uid from userIdProvider
  → Builds a model (lib/features/models) → toMap() (snake_case, ISO-8601 strings)
  → FirebaseFirestore.instance.collection(...).doc(id).set/update(...)
  → firestore.rules evaluates role and ownership
  → Snapshot listeners (view_model providers) emit the new state
  → Widgets rebuild
```

Because offline persistence is enabled in `main.dart`, snapshot streams emit
cached data first and reconcile with the server afterwards.

## Important Workflows

### 1. Authentication and role resolution

1. `firebaseAuthUserProvider` streams `FirebaseAuth.authStateChanges()`.
2. `currentUserProvider` switches on that stream and, for a signed-in user,
   streams `/users/{uid}` mapped to `UserModel`.
3. `goRouterProvider`'s `redirect` watches both providers. With no Auth user
   it allows only `/welcome`, `/login`, `/register`, `/otp-verify`. With a
   user but no profile yet it allows the navigation. With a profile it sends
   staff (`officer`, `supervisor`, `admin`) away from `/applicant-home`,
   applicants away from staff routes, and both away from public routes to their
   home.
4. `AuthService.registerWithEmailAndPassword` creates the Auth account, then
   writes the profile; if the profile write throws, it deletes the Auth user
   (best effort) and rethrows.
5. `AuthService.signInWithEmailAndPassword` signs in and reads the profile. It
   only creates a profile (role `applicant`) when none exists, so a sign-in never
   overwrites an existing role.

### 2. Application submission

1. Each field is a `keepAlive` Notifier in
   `application_form_providers.dart`, so values survive moving between steps.
2. Each step validates its own `Form` before calling `formStep.next()`.
   Previous NIN is required for every type except new registration.
3. `ApplicationService.createApplication` creates a UUID v4 id, fills
   defaults for unset values, sets status `submitted`, and writes
   `applications/{id}`.
4. On success the screen clears all form providers and navigates to
   `/application/{id}`.

### 3. Staff review

1. `pendingApplicationsProvider` queries `status in [submitted, underReview]`
   ordered by `created_at` ascending (index: `status` + `created_at`).
2. The review screen streams the application and its `documents`.
3. `OfficerReviewService.approve / reject / markBiometricsCaptured` call
   `ApplicationService.updateStatus`, which writes `status`, optional
   `officer_notes` / `rejection_reason` (null-aware map entries), `updated_at`
   and `reviewed_by`.
4. Each action then writes an `audit_logs` entry. Audit failure is logged and
   swallowed so it does not undo or block the review.

### 4. Document upload

1. `DocumentsScreen` lists six document types (two marked required) and uses
   `ImagePicker.pickImage` from the gallery.
2. `DocumentService.uploadDocument` puts the file at
   `documents/{uid}/{applicationId}/{docId}-{fileName}`, listens to
   `snapshotEvents` to publish progress through `uploadProgressProvider`,
   fetches the download URL and writes `documents/{docId}`.
3. The progress subscription is cancelled and progress cleared in `finally`,
   whether the upload succeeded or failed.

### 5. Appointment lifecycle

1. Booking is only offered for an `approved` application.
2. The date picker allows weekdays from tomorrow to 90 days ahead.
3. `AppointmentService.bookAppointment` builds a queue number from the first
   three letters of the centre id, the date as `yyyyMMdd` and four characters
   of a UUID, then writes the appointment as `confirmed`.
4. `AppointmentModel.effectiveStatus` shows a confirmed appointment as
   `overdue` once the end of its day has passed, without waiting for a write.
5. When the applicant's or the staff appointments screen loads,
   `sweepOverdue` persists `overdue` for every such appointment in one
   Firestore `WriteBatch`.
6. Status writes also set legacy `is_cancelled` / `is_completed` flags, and
   `fromMap` falls back to those flags for documents without `status`.

### 6. Role administration

`AdminService.assignRole` updates `users/{uid}.role` and writes an audit entry.
The rules allow this only for admins; the button is shown only to admins
(`officer_home_screen.dart`).

## Business Logic

Business rules are split between three places:

- **Services** (`lib/features/*/service`): status transitions, queue number
  generation, overdue sweep, audit writes, registration rollback.
- **Models** (`lib/features/models`): derived status (`effectiveStatus`,
  `isUpcoming`, `isOverdue`), backwards-compatible parsing, enum mapping.
- **Widgets**: which action is available for a status (for example,
  `review_action_bar.dart` shows read-only for approved and later stages, and
  `application_detail_screen.dart` chooses upload or book). This is UI gating,
  not enforcement.
- **Security rules**: the only server-side enforcement (ownership, role, role
  immutability, append-only audit, file size).

## Integration Architecture

All integrations are Firebase SDKs called directly from services or providers:
Auth (`FirebaseAuth.instance`), Firestore (`FirebaseFirestore.instance`),
Storage (`FirebaseStorage.instance`), Messaging (`FirebaseMessaging.instance`).
There is no abstraction layer between features and the SDKs in the live path.
Push notifications are prepared on the client only: the FCM token is stored in
`users/{uid}.fcm_token`, but nothing in the repository sends messages or
handles incoming ones (`onMessage` is not registered).

## Failure Handling

Only mechanisms present in the code:

| Failure | Handling |
| --- | --- |
| Uncaught framework, platform or zone error | Logged through `Printer.error` (wraps `dart:developer` `log`); a known hot-restart web assertion is filtered |
| Firebase initialization failure | Logged and rethrown; the app does not start |
| Invalid form input | Per-field `validator`s (`lib/core/functions/functions.dart`): required, email regex, Ugandan phone regex, password at least 6 characters |
| Auth errors | `FirebaseAuthException` mapped to user-facing text in the login screen; other errors show a generic message and are logged |
| Profile write fails at registration | Auth account deleted (best effort), error rethrown |
| Firestore write fails in a service | Logged and rethrown to the screen, which shows an error state or `SnackBar` |
| Audit write fails | Logged and swallowed so the primary action completes |
| Storage delete fails | Logged; the Firestore record is still deleted |
| Upload fails | Logged, `SnackBar` shown, progress cleared |
| Stream errors | Rendered by `AsyncValue.when(error: ...)` in each screen |
| Network loss | Firestore offline persistence serves cached reads and queues writes (SDK behaviour) |

There is no retry logic or custom offline queue in the live path. The
`lib/data/local/sync_service.dart` sembast queue is not wired in.

## Security Architecture

- **Identity:** Firebase Auth email/password. The uid is the `users` document
  id.
- **Authorization:** `firestore.rules` reads `users/{uid}.role` with
  `get()` to decide `isStaff()` and `isAdmin()`.
  - `users`: read own or staff; create own with role `applicant` only; update
    own without changing `role`, or any as admin; delete admin only.
  - `applications`, `appointments`: read/update own (by `applicant_id`) or
    staff; create only with own `applicant_id`.
  - `documents`: ownership derived from the parent application via `get()`.
  - `notifications`: owner reads/updates/deletes; staff create.
  - `audit_logs`: staff create, admin read, no update or delete.
  - Catch-all deny.
- **Storage:** `storage.rules` reads the role from Firestore
  (`firestore.get`) and allows owners to write under their own uid (under 20 MB)
  and staff to read all.
- **Client-side gating:** router redirects and admin-only UI; these are
  usability measures, the rules are the enforcement.

## Scalability Characteristics

What the implementation supports:

- Every compound query has a matching composite index in
  `firestore.indexes.json` (9 indexes).
- Real-time listeners are scoped by `applicant_id`, `user_id` or `reviewed_by`
  for non-staff users; the applicant home stream is limited to 5 and the
  notification stream to 50.
- Overdue updates are batched into one `WriteBatch` per screen load.
- Offline persistence with unlimited cache reduces cold-start reads.

Limits visible in the code: staff queries (`allAppointments`, `allUsers`,
`pendingApplications`, `approvedApplications`) are unpaginated; each rule
evaluation performs one or more `get()` document reads; queue numbers rely on
four random hexadecimal characters per centre and day rather than a counter.
