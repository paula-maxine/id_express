# Feature Catalog

[Back to README](../README.md)

Roles: **applicant** (citizen), **officer**, **supervisor**, **admin**.
"Staff" means officer, supervisor or admin (`isStaff()` in `firestore.rules`,
`role != applicant` in the router).

---

## 1. Registration and sign-in

- **Purpose:** create and authenticate accounts and attach a role.
- **Users:** everyone.
- **Implementation:** `lib/features/auth/`.
- **Workflow:** Welcome → Register (full name, email, phone, password) or
  Login (email, password). Login routes by role.
- **Business rules:**
  - Validators: required name, email regex, phone `^(\+256|0)7[0-9]{8}$`,
    password at least 6 characters (`lib/core/functions/functions.dart`).
  - New profiles are always `applicant`; rules reject any other role at create.
  - Registration deletes the Auth account if the profile write fails.
  - Sign-in never overwrites an existing profile; it creates one only if
    missing.
- **Dependencies:** Firebase Auth, Firestore `users`.
- **Relevant code:** `service/auth_service.dart`,
  `view_model/auth_providers.dart`, `view/login_screen.dart`,
  `view/register_screen.dart`.

## 2. Role-based navigation

- **Purpose:** keep each role on its own screens.
- **Users:** everyone.
- **Implementation:** `lib/routes/router.dart`.
- **Workflow:** the `redirect` callback re-runs when the Auth stream or the
  profile stream changes.
- **Business rules:** unauthenticated users reach only public routes; staff are
  redirected away from `/applicant-home`; applicants away from
  `/officer-home`, `/officer/dashboard`, `/admin/manage-users`; signed-in users
  are redirected off public routes to their home.
- **Relevant code:** `router.dart`, `paths.dart`,
  `features/auth/view_model/auth_providers.dart`.

## 3. Applicant dashboard

- **Purpose:** entry point for citizens.
- **Users:** applicants.
- **Implementation:** `lib/features/applicant_home/`.
- **Workflow:** shows four service cards (new registration, renewal,
  replacement, change of particulars), the five most recent applications and
  live counts of in-progress applications and upcoming appointments.
- **Business rules:** "in progress" means status `submitted`, `underReview` or
  `approved`; "upcoming" is computed in memory using
  `AppointmentModel.isUpcoming` so passed appointments are excluded.
- **Relevant code:** `view_model/applicant_home_providers.dart`,
  `model/service_type.dart`, `view/applicant_home_screen.dart`.

## 4. Multi-step application

- **Purpose:** collect the data for an ID application.
- **Users:** applicants.
- **Implementation:** `lib/features/application_form/`.
- **Workflow:** Personal info → Family info → Address info → Review → Submit.
- **Business rules:**
  - Each step validates its own form before advancing; the step index is
    clamped to 0..3.
  - Previous NIN is required for renewal, replacement and change of
    particulars.
  - Empty permanent address defaults to the current address; unset date of
    birth, gender and marital status default to `2000-01-01`, `male` and
    `single` in the service.
  - New applications are written with status `submitted`.
  - All field providers are cleared after a successful submit.
- **Dependencies:** Firestore `applications`, `uuid`.
- **Relevant code:** `view_model/application_form_providers.dart`,
  `service/application_service.dart`, `view/*_step.dart`.

## 5. Application tracking

- **Purpose:** let applicants follow their applications.
- **Users:** applicants.
- **Implementation:** `lib/features/applications/`.
- **Workflow:** list (filterable by status) → detail with a six-stage timeline
  (submitted, under review, approved, biometrics captured, ID ready,
  completed), the rejection reason when rejected, and an action bar.
- **Business rules:** approved → "Schedule Booking"; draft or rejected →
  "Upload Documents"; other statuses → no action.
- **Relevant code:** `view_model/applications_providers.dart`,
  `view/application_detail_screen.dart`, `view/application_list_item.dart`.

## 6. Document upload

- **Purpose:** attach supporting documents to an application.
- **Users:** applicants (upload); staff (view metadata during review).
- **Implementation:** `lib/features/documents/`.
- **Workflow:** choose a document type → pick an image from the gallery →
  upload with a progress indicator → the card shows the uploaded file.
- **Business rules:** six types listed, passport photo and birth certificate
  marked required (display only, not enforced); Storage path
  `documents/{uid}/{applicationId}/{docId}-{fileName}`; Storage rules cap
  files at 20 MB.
- **Dependencies:** Cloud Storage, Firestore `documents`, `image_picker`.
- **Relevant code:** `service/document_service.dart`,
  `view/documents_screen.dart`, `view/document_upload_card.dart`.

## 7. Appointment booking and management

- **Purpose:** schedule the in-person visit after approval.
- **Users:** applicants (book, view, cancel); staff (view all, mark done).
- **Implementation:** `lib/features/appointments/`.
- **Workflow:** choose one of six centres → choose a date → choose a slot →
  confirm. Applicants see their appointments and can cancel; staff open
  "Manage Appointments" from the dashboard.
- **Business rules:**
  - Dates: weekdays only, tomorrow up to 90 days ahead; seven fixed slots.
  - Queue number: first three letters of centre id + `yyyyMMdd` + four UUID
    characters.
  - Status: `confirmed`, `completed`, `overdue`, `cancelled`; a confirmed
    appointment past the end of its day is displayed as overdue and persisted
    as overdue on the next screen visit (batched).
- **Relevant code:** `service/appointment_service.dart`,
  `features/models/appointment_model.dart`,
  `view/book_appointment_screen.dart`, `view/manage_appointments_screen.dart`.

## 8. Staff review

- **Purpose:** decide on applications.
- **Users:** staff.
- **Implementation:** `lib/features/officer/`.
- **Workflow:** dashboard with status filter and statistics → review screen
  (applicant details, documents) → Approve (optional notes) / Reject (reason
  required) / for approved applications, Mark Biometrics Captured.
- **Business rules:** pending queue = `submitted` + `underReview`, oldest
  first; approved and later stages are read-only except biometrics; each
  action records `reviewed_by` and writes an audit entry.
- **Dependencies:** Firestore `applications`, `documents`, `audit_logs`.
- **Relevant code:** `service/officer_service.dart`,
  `view_model/officer_providers.dart`, `view/review_action_bar.dart`,
  `view/reject_reason_dialog.dart`.

## 9. User and role administration

- **Purpose:** grant staff roles.
- **Users:** admins.
- **Implementation:** `lib/features/admin/`.
- **Workflow:** dashboard "Manage Users" icon (admins only) → list ordered by
  display name → choose a role → confirm.
- **Business rules:** only admins may change `role` (rules); each change
  writes a `role_assigned` audit entry.
- **Relevant code:** `service/admin_service.dart`,
  `view/manage_users_screen.dart`.

## 10. Audit trail

- **Purpose:** record who did what.
- **Users:** written by staff actions; readable by admins (rules).
- **Implementation:** `lib/data/cloud/audit_cloud_service.dart` called from
  `OfficerReviewService` and `AdminService`.
- **Business rules:** actions `application_approved`,
  `application_rejected`, `biometrics_captured`, `role_assigned`; append-only
  by rule. There is no audit viewer screen in the app.

## 11. Notifications

- **Purpose:** inform users of changes.
- **Users:** everyone.
- **Implementation:** `lib/features/notifications/`.
- **Workflow:** Profile → Enable Notifications requests permission and stores
  the FCM token on the user document; the notifications screen lists the latest
  50 and marks an item read on tap; unread count is streamed.
- **Business rules:** only staff may create notification documents (rules).
- **External integrations:** Firebase Cloud Messaging.
- **Limitation:** no code in this repository creates notifications or sends
  push messages.

## 12. Profile and sign-out

- **Implementation:** `lib/features/profile/view/profile_screen.dart`.
- Shows the user's details, the notification opt-in, a "Change Password" tile
  (no action) and sign-out with confirmation.

## 13. Test-build distribution (tooling)

- **Implementation:** `scripts/bump_version.dart`,
  `scripts/deploy_testing.dart`, documented in `scripts/README.md`.
- Bumps the version, builds an IPA and a split-per-ABI APK, uploads the
  arm64 APK and IPA to AppSend (150 MB cap) and prints install links.
