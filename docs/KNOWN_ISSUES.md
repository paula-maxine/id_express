# Known Issues

[Back to README](../README.md)

Recorded during submission preparation on 2026-11-18. Nothing here was changed
in the code. "Blocks dev" / "Blocks prod" state whether the issue stops
development or a production release.

| # | Issue | Component | Impact | Blocks dev | Blocks prod |
| --- | --- | --- | --- | --- | --- |
| 1 | `test/model_test.dart` fails: `type 'AddressModel' is not a subtype of type 'Map<String, dynamic>'` | `lib/data/model/application_model.dart` (legacy, unused by the app) | 1 of 2 tests fails | No | No |
| 2 | Inactive legacy code: `lib/data/` (except the audit writer and its model), `lib/global/`, `lib/services/`, `lib/utils/`, `lib/routes/error_page.dart` are not imported by the live app | lib | 2,737 hand-written lines a reader must learn to ignore; two `AuditLogModel` classes with different field names | No | No |
| 3 | Declared but unused packages: `local_auth`, `flutter_secure_storage`, `package_info_plus` (never imported); `sembast`, `path_provider`, `connectivity_plus` (only by inactive code); `file_picker`, `cached_network_image`, `flutter_svg` (only re-exported); dev `mocktail`, `checks`, `integration_test` | `pubspec.yaml` | Larger dependency surface and build | No | No |
| 4 | Nothing creates `notifications` documents or sends push messages; no `onMessage` handlers | notifications | Notification screen stays empty without an external sender | No | Yes, if notifications are required |
| 5 | Document upload uses `dart:io` `File` and `putFile` | `lib/features/documents/service/document_service.dart` | Upload does not work on web | No | Yes, for web |
| 6 | New applications are created as `submitted`; the "Upload Documents" action appears only for `draft` or `rejected` | application form, application detail | Applicants cannot attach documents before first review | No | Product decision |
| 7 | Applicants may update any field of their own application, including `status` and `reviewed_by` (rule: owner update allowed) | `firestore.rules` | A modified client could self-approve | No | Yes |
| 8 | Applicants may update their own appointments without field restrictions | `firestore.rules` | Same class as #7 | No | Yes |
| 9 | `/admin/manage-users` is in the staff route set, so officers and supervisors can open it by URL; rules still block their role writes | `lib/routes/router.dart` | UI exposure only | No | No |
| 10 | Centres and time slots are hard-coded; no capacity or double-booking check; queue number uses 4 random hex characters | `book_appointment_screen.dart`, `appointment_service.dart` | Collisions and overbooking possible | No | Yes, at scale |
| 11 | Statuses `underReview`, `idReady`, `completed`, `cancelled`, `draft` are never written by the app | application flow | Timeline stages past biometrics are unreachable | No | Product gap |
| 12 | Placeholders: "Change Password" tile has no action; `/otp-verify` shows "coming soon"; officer "View" document button has no action; `sendPasswordResetEmail`, `updateUserProfile`, `deleteDocument` are not called from the UI | profile, router, officer review | Incomplete features | No | Partially |
| 13 | Service defaults: missing date of birth, gender, marital status become `2000-01-01`, `male`, `single` | `application_service.dart` | Silent data defaults if a step is skipped | No | Should be reviewed |
| 14 | Dates stored as ISO-8601 strings without timezone instead of Firestore `Timestamp` | all models | Ordering assumes one timezone | No | Low |
| 15 | Staff queries are unpaginated (`allUsers`, `allAppointments`, pending/approved queues) | officer, admin, appointments | Cost and latency grow with data | No | At scale |
| 16 | macOS and Linux entries in `lib/firebase_options.dart` hold `YOUR_...` placeholders; macOS entitlements have no `network.client` | desktop | Firebase does not work on macOS or Linux as committed | No | For desktop |
| 17 | Android `applicationId`/`namespace` and iOS/macOS bundle id are `com.example...`; Android release uses debug signing | platform config | Cannot publish as is | No | Yes |
| 18 | iOS: no `NSPhotoLibraryUsageDescription` in `Info.plist` although `image_picker` is used; no Push Notifications entitlement file | `ios/Runner` | App Store review risk; iOS push needs setup | No | Yes, for App Store |
| 19 | Committed `pubspec.lock` resolves 6 Flutter-SDK-pinned packages (for example `vector_math`, `test_api`) to older versions than Flutter 3.47.8 expects; `flutter pub get` rewrites them, and also adds an `analyzer.exclude` block to `analysis_options.yaml` | build | Tooling changes these files on first `pub get` | No | No |
| 20 | Android build warns that plugins apply the Kotlin Gradle Plugin, which future Flutter versions will reject | Android | Future build break | No | Later |
| 21 | `storage.rules` exists but `firebase.json` has no `storage` entry, so `firebase deploy` does not publish it | `firebase.json` | Storage rules must be deployed by hand | No | Yes, until deployed |
| 22 | `pubspec.yaml` description is the template text "A new Flutter project." | metadata | Cosmetic | No | No |

## Resolutions suggested by the repository

- #1: the generated `toJson` would need `explicitToJson: true` for the nested
  `AddressModel`; alternatively the legacy model and its test can be retired
  together.
- #2 and #3: the inactive folders and the unused packages can be removed in one
  change once confirmed unused.
- #7 and #8: restrict owner updates with `request.resource.data.diff(resource.data).affectedKeys().hasOnly([...])`.
