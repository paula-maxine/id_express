# Features

**Code files in this unit: 207** (188 hand-written Dart files + 19 platform-runner
source files).
Counting rule: tracked files ending in `.dart` under `lib/`, `test/` and
`scripts/`, excluding generated `*.g.dart` and the CLI-generated
`lib/firebase_options.dart`; plus `.kt`, `.swift`, `.cc`, `.cpp` and `.h`
files in the platform runners, excluding generated plugin registrants. Build
output, config, rules, Markdown and assets are not counted. Counted 2026-11-18.

- Email and password registration with automatic `applicant` role
- Registration rollback when the profile write fails
- Email and password sign-in with profile provisioning for users without one
- Role-based routing for applicants, officers, supervisors and admins
- Applicant dashboard with four services, recent applications and live counters
- Four-step ID application (personal, family, address, review)
- Four service types: new registration, renewal, replacement, change of particulars
- Per-step form validation, including Ugandan phone format and previous NIN rules
- Application list with status filter
- Live application detail with status timeline and rejection reason
- Document upload to Cloud Storage with progress
- Appointment booking with centre, weekday date and time slot
- Queue number generation per appointment
- Appointment cancellation by applicants
- Overdue detection with batched status persistence
- Staff appointment management with "mark done"
- Staff dashboard with pending and approved queues and statistics
- Application review with approve, reject with reason and biometrics capture
- Admin user list and role assignment
- Append-only audit log of review and role actions
- Push notification opt-in with FCM token storage
- In-app notification list with unread count and mark-as-read
- Profile screen with sign-out
- Firestore offline persistence
- Role-based Firestore and Storage security rules
- Composite Firestore indexes for all compound queries
- Web cache busting by version file
- Version bump and AppSend test-build distribution scripts

Details: [docs/FEATURE_CATALOG.md](docs/FEATURE_CATALOG.md).
