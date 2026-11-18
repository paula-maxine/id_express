# Technical Highlights

[Back to README](../README.md)

Only behaviour present in the code is described here.

## 1. Authorization enforced by security rules, with role derived from data

`firestore.rules` resolves the caller's role by reading
`users/{request.auth.uid}` and builds `isStaff()` and `isAdmin()` on top of
it. Three details make the model hold together:

- **No self-promotion:** `users` create requires `role == 'applicant'`, and the
  owner's update path requires `roleUnchanged()` (the field is either absent
  from the write or equal to the stored value). Only `isAdmin()` can change a
  role.
- **Derived ownership:** `documents` have no owner rule of their own; read,
  create, update and delete look up the parent application with `get()` and
  compare its `applicant_id` to the caller.
- **Append-only audit:** `audit_logs` allows create by staff and read by admins,
  and `update, delete: if false`.

`storage.rules` reuses the same role source through `firestore.get(...)`, so
Storage and Firestore authorization cannot drift apart. Both files end in a
catch-all deny.

## 2. A reactive router that follows role changes

`goRouterProvider` is a `keepAlive` Riverpod provider whose `redirect` calls
`ref.watch` on the Auth stream and on the Firestore profile stream. A role
change written by an admin flows through the profile snapshot into the
router, and the guards re-evaluate without a restart or re-login. The guard
returns `null` while the profile is still loading so a freshly registered user
is not bounced.

## 3. Consistency handling around account creation

`AuthService.registerWithEmailAndPassword` treats Auth account creation and
the profile write as one unit: if the Firestore write throws, it deletes the
just-created Auth user and rethrows. Sign-in is deliberately read-only and
only provisions a missing profile, which, combined with the rule that new
profiles must be `applicant`, prevents a sign-in from resetting a staff role.

## 4. Derived status with lazy persistence

`AppointmentModel.effectiveStatus` computes `overdue` locally from the
appointment date (end of day), so the UI is correct immediately. On the next
visit to an appointments screen, `AppointmentService.sweepOverdue` persists the
derived state for all affected appointments in a single Firestore
`WriteBatch`. The model also reads legacy documents: when `status` is absent,
it falls back to the older `is_cancelled` / `is_completed` booleans, and every
status write keeps those booleans in sync.

## 5. Real-time data model backed by declared indexes

Every list in the app is a Firestore snapshot stream exposed as a Riverpod
`StreamProvider`, rendered with `AsyncValue.when`. Each compound query has a
matching composite index in `firestore.indexes.json`, for example
`status + created_at` for the staff queue (with a `whereIn`),
`reviewed_by + updated_at` for "my reviews", `applicant_id + status` for the
in-progress counter and `user_id + created_at` for notifications. Offline
persistence with an unlimited cache (`main.dart`) makes cached snapshots
render first on cold start.

## 6. Upload pipeline with tracked progress and cleanup

`DocumentService.uploadDocument` streams `UploadTask.snapshotEvents` into a
`keepAlive` progress provider, then resolves the download URL and writes the
Firestore record. The progress subscription is cancelled and progress cleared
in `finally`, so a failed or abandoned upload cannot leave a stale progress
bar or a listener firing after disposal. Deletion is ordered so a failed
Storage delete is logged but the metadata is still removed.

## 7. Audited staff actions that cannot be blocked by audit failure

Approve, reject, biometrics capture and role assignment each perform the
primary write first and then the audit write in a `try`/`catch` that logs and
continues. The acting user is captured before the async gap in
`AdminService.assignRole`.

## 8. Defensive start-up and logging

`main.dart` installs three error sinks (framework, platform dispatcher, zone),
routes all of them to a single `Printer` logger over `dart:developer`, and
filters one specific Flutter-web hot-restart assertion so it cannot mask real
errors.

## 9. Web cache busting and release tooling

`web/index.html` fetches `version.txt` with `no-store` before loading
`flutter_bootstrap.js`; on a new value it clears the Cache API and unregisters
service workers. `firebase.json` serves the loader files and `version.txt` with
`no-cache` (including `main.dart.js`) and other `js`, `css`, `wasm`, `png`,
`jpg` and `svg` files with a one-year immutable cache.
`scripts/bump_version.dart` writes the version to both `pubspec.yaml` and
`version.txt`, and `scripts/deploy_testing.dart` builds and distributes test
builds under the AppSend 150 MB limit by uploading the arm64 split APK.
