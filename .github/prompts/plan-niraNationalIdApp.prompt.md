# NIRA National ID Registration App — Full Implementation Plan

## Overview

Transform the existing minimal ID Express Flutter app into a full-featured National ID registration system for NIRA Uganda. The app will use a **feature-driven architecture** with **Riverpod (code gen)** for state management, **go_router** for navigation, **Firebase (client-side only)** for backend, and focus on **Applicant + Officer** as primary roles with Supervisor/Admin as secondary dashboards. All 9 major NIRA modules will be implemented (offline/sync skipped since Firebase handles caching). The existing 4-screen, no-model, raw-map codebase will be completely restructured into ~30+ screens, 10+ data models, feature-organized ViewModels, and proper service abstractions.

---

## Step 0: Project Scaffolding & Dependencies

### Update pubspec.yaml — add all required dependencies

- **State management:** `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- **Navigation:** `go_router`
- **Serialization:** `json_serializable`, `json_annotation`
- **Code gen (dev):** `build_runner`, `riverpod_generator`, `riverpod_lint`, `json_serializable`
- **Firebase extras:** `firebase_messaging` (push notifications)
- **Auth extras:** `local_auth` (biometric/MFA optional), `flutter_secure_storage`
- **UI:** `google_fonts`, `intl` (date/locale), `cached_network_image`, `flutter_svg`
- **Utilities:** `uuid` (tracking refs), `image_picker` (keep), `file_picker`
- Keep: `firebase_core`, `firebase_auth`, `firebase_storage`, `cloud_firestore`

### Update analysis_options.yaml

- Add `custom_lint` with riverpod lint rules
- Keep `flutter_lints/flutter.yaml` include

### Create full folder structure under `lib/`

```
lib/
├── main.dart
├── app_exporter.dart
├── app/
│   ├── exporter.dart
│   ├── id_express.dart              # MaterialApp.router with ProviderScope
│   └── id_express_splash.dart
├── data/
│   ├── exporter.dart
│   ├── cloud/
│   │   ├── exporter.dart
│   │   ├── auth_cloud_service.dart
│   │   ├── application_cloud_service.dart
│   │   ├── document_cloud_service.dart
│   │   ├── appointment_cloud_service.dart
│   │   ├── audit_cloud_service.dart
│   │   ├── service_centre_cloud_service.dart
│   │   └── user_cloud_service.dart
│   ├── model/
│   │   ├── exporter.dart
│   │   ├── user_model.dart
│   │   ├── application_model.dart
│   │   ├── address_model.dart
│   │   ├── document_model.dart
│   │   ├── appointment_model.dart
│   │   ├── audit_log_model.dart
│   │   ├── service_centre_model.dart
│   │   └── enums/
│   │       ├── user_role.dart
│   │       ├── application_status.dart
│   │       ├── document_type.dart
│   │       └── gender.dart
│   └── mock/
│       └── exporter.dart
├── global/
│   ├── exporter.dart
│   ├── constants/
│   │   ├── border_radius.dart
│   │   ├── dimens.dart
│   │   ├── durations.dart
│   │   ├── formatters.dart
│   │   ├── margins.dart
│   │   ├── padding.dart
│   │   ├── spacing.dart
│   │   ├── strings.dart
│   │   └── exporter.dart
│   ├── functions/
│   │   ├── validators.dart
│   │   ├── links_launcher.dart
│   │   └── exporter.dart
│   ├── responsive/
│   │   ├── id_express_responsive.dart
│   │   ├── id_express_responsive_builder.dart
│   │   └── exporter.dart
│   ├── theme/
│   │   ├── colors.dart
│   │   ├── theme.dart
│   │   ├── dark_theme.dart
│   │   ├── text_theme.dart
│   │   ├── nira_theme_extension.dart
│   │   └── exporter.dart
│   └── widgets/
│       ├── disclaimer.dart
│       ├── dividers.dart
│       ├── entrance_fader.dart
│       ├── spaces.dart
│       ├── status_badge.dart
│       ├── loading_overlay.dart
│       ├── error_display.dart
│       ├── empty_state.dart
│       ├── nira_app_bar.dart
│       ├── nira_drawer.dart
│       ├── form_fields/
│       │   ├── nira_text_field.dart
│       │   ├── nira_dropdown_field.dart
│       │   ├── nira_date_picker_field.dart
│       │   └── exporter.dart
│       ├── app_button/
│       │   ├── app_button.dart
│       │   ├── app_text_button.dart
│       │   └── exporter.dart
│       └── exporter.dart
├── providers/
│   ├── exporter.dart
│   ├── go_router_provider.dart
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   ├── application_provider.dart
│   ├── appointment_provider.dart
│   └── audit_provider.dart
├── routes/
│   ├── exporter.dart
│   ├── paths.dart
│   ├── routes.dart
│   └── error_page.dart
└── screens/
    ├── exporter.dart
    ├── auth/
    │   ├── login_screen.dart
    │   ├── signup_screen.dart
    │   ├── forgot_password_screen.dart
    │   ├── view_model/
    │   │   ├── login_view_model.dart
    │   │   └── signup_view_model.dart
    │   └── exporter.dart
    ├── splash/
    │   └── splash_screen.dart
    ├── applicant/
    │   ├── dashboard/
    │   │   ├── applicant_dashboard_screen.dart
    │   │   └── view_model/applicant_dashboard_vm.dart
    │   ├── pre_registration/
    │   │   ├── pre_registration_screen.dart
    │   │   ├── widgets/
    │   │   │   ├── demographics_form.dart
    │   │   │   ├── guardian_details_form.dart
    │   │   │   ├── address_form.dart
    │   │   │   └── review_submission.dart
    │   │   └── view_model/pre_registration_vm.dart
    │   ├── document_upload/
    │   │   ├── document_upload_screen.dart
    │   │   ├── document_preview_screen.dart
    │   │   ├── widgets/
    │   │   │   ├── document_picker.dart
    │   │   │   └── upload_progress.dart
    │   │   └── view_model/document_upload_vm.dart
    │   ├── appointments/
    │   │   ├── book_appointment_screen.dart
    │   │   ├── appointment_details_screen.dart
    │   │   ├── widgets/
    │   │   │   ├── centre_selector.dart
    │   │   │   ├── date_time_selector.dart
    │   │   │   └── queue_token_card.dart
    │   │   └── view_model/appointment_vm.dart
    │   ├── status_tracking/
    │   │   ├── applications_list_screen.dart
    │   │   ├── application_detail_screen.dart
    │   │   └── view_model/status_tracking_vm.dart
    │   └── exporter.dart
    ├── officer/
    │   ├── dashboard/
    │   │   ├── officer_dashboard_screen.dart
    │   │   └── view_model/officer_dashboard_vm.dart
    │   ├── verification/
    │   │   ├── pending_applications_screen.dart
    │   │   ├── application_review_screen.dart
    │   │   ├── widgets/
    │   │   │   ├── demographic_review_card.dart
    │   │   │   ├── document_review_card.dart
    │   │   │   ├── rejection_reason_dialog.dart
    │   │   │   └── verification_checklist.dart
    │   │   └── view_model/verification_vm.dart
    │   ├── appointments/
    │   │   ├── daily_appointments_screen.dart
    │   │   └── view_model/officer_appointments_vm.dart
    │   └── exporter.dart
    ├── admin/
    │   ├── admin_dashboard_screen.dart
    │   ├── user_management_screen.dart
    │   ├── reports_screen.dart
    │   ├── audit_logs_screen.dart
    │   ├── view_model/admin_vm.dart
    │   └── exporter.dart
    ├── settings/
    │   ├── settings_screen.dart
    │   ├── profile_screen.dart
    │   ├── privacy_policy_screen.dart
    │   └── exporter.dart
    └── shared/
        ├── consent_screen.dart
        ├── privacy_notice_screen.dart
        └── exporter.dart
```

Delete the existing `lib/screens/` and `lib/services/` files — all replaced by the new structure.

---

## Step 1: Data Models (`lib/data/model/`)

Typed, immutable model classes with `json_serializable` and `fieldRename: FieldRename.snake`.

### Enums

- **`UserRole`** — `applicant`, `officer`, `supervisor`, `admin`
- **`ApplicationStatus`** — `submitted`, `underReview`, `approved`, `biometricPending`, `cardReady`, `rejected`
- **`DocumentType`** — `birthCertificate`, `passportPhoto`, `supportingDocument`, `nationalId`
- **`Gender`** — `male`, `female`

### `UserModel`

Fields: `uid`, `email`, `fullName`, `role` (UserRole), `phone`, `createdAt`, `isActive`, `lastLogin`, `fcmToken`, `consentGiven`

### `ApplicationModel`

Fields: `id`, `applicantUid`, `trackingRef` (format: `NIRA-{YEAR}-{6-char UUID}`), `fullName`, `dateOfBirth`, `gender`, `nationality`, `address` (embedded `AddressModel`), `parentGuardianName`, `parentGuardianId`, `status` (ApplicationStatus), `officerUid`, `rejectionReason`, `createdAt`, `updatedAt`, `documentIds` (list of doc IDs)

### `AddressModel`

Fields: `district`, `county`, `subCounty`, `parish`, `village`

### `DocumentModel`

Fields: `id`, `applicationId`, `type` (DocumentType), `fileName`, `imageUrl`, `fileSize`, `mimeType`, `uploadedAt`, `isVerified`, `verifiedByUid`, `verifiedAt`, `flagReason`

### `AppointmentModel`

Fields: `id`, `applicationId`, `applicantUid`, `serviceCentreId`, `dateTime`, `queueToken`, `status` (`scheduled`, `confirmed`, `cancelled`, `completed`), `createdAt`

### `ServiceCentreModel`

Fields: `id`, `name`, `district`, `address`, `operatingHours`, `isActive`

### `AuditLogModel`

Fields: `id`, `userId`, `userRole`, `action` (enum: `login`, `logout`, `create`, `update`, `approve`, `reject`, `upload`, `delete`), `targetCollection`, `targetDocId`, `details` (Map), `timestamp`

---

## Step 2: Cloud Services (`lib/data/cloud/`)

Each service is a clean class returning typed models. All use custom exceptions (not raw strings). Instantiated via Riverpod providers for DI.

### `AuthCloudService`

Methods: `signUp(email, password, fullName)`, `login(email, password)`, `logout()`, `resetPassword(email)`, `updatePassword(newPassword)`, `authStateChanges` (Stream), `verifyEmail()`

### `UserCloudService`

Methods: `createUser(UserModel)`, `getUser(uid)`, `updateUser(uid, fields)`, `getUsersByRole(UserRole)`, `deactivateUser(uid)`, `assignRole(uid, UserRole)`

### `ApplicationCloudService`

Methods: `createApplication(ApplicationModel)`, `getApplication(id)`, `getApplicationsByApplicant(uid)` (Stream), `getApplicationsByStatus(status)` (Stream), `getPendingApplicationsForOfficer()` (Stream), `updateApplicationStatus(id, status, officerUid, {reason})`, `updateApplication(id, fields)`

### `DocumentCloudService`

Combines Storage + Firestore for documents. Methods: `uploadDocument(applicationId, type, file)` — validates size < 5 MB, type jpg/png/pdf; `getDocumentsByApplication(applicationId)`; `verifyDocument(docId, officerUid)`; `flagDocument(docId, reason)`; `deleteDocument(docId)`

### `AppointmentCloudService`

Methods: `createAppointment(AppointmentModel)`, `getAppointmentsByApplicant(uid)`, `getAppointmentsByDate(centreId, date)`, `getAvailableSlots(centreId, date)`, `cancelAppointment(id)`, `rescheduleAppointment(id, newDateTime)`

### `AuditCloudService`

Append-only logging. Methods: `logAction(AuditLogModel)`, `getAuditLogs({filters})`, `getAuditLogsByUser(uid)`

Called automatically by other services on key actions — not called directly by ViewModels.

### `ServiceCentreCloudService`

Read-only for clients. Methods: `getAllCentres()`, `getCentresByDistrict(district)`, `getCentre(id)`

---

## Step 3: Riverpod Providers (`lib/providers/`)

Using `@riverpod` annotations (code generation via `riverpod_generator`).

- **`authProvider`** — `StreamProvider` wrapping `FirebaseAuth.authStateChanges()`
- **`currentUserProvider`** — `FutureProvider<UserModel?>` fetching from Firestore, depends on `authProvider`
- **`userRoleProvider`** — derived from `currentUserProvider`, returns `UserRole?`, used for route guards
- **`applicationListProvider(uid)`** — `StreamProvider` family, real-time application list
- **`pendingVerificationsProvider`** — `StreamProvider` for officer's pending review queue
- **`appointmentListProvider(uid)`** — `FutureProvider` for user's appointments
- **`auditLogProvider`** — `FutureProvider` for admin audit log view
- **Service providers** — one `Provider` per cloud service (e.g., `authCloudServiceProvider`, `applicationCloudServiceProvider`) for DI

---

## Step 4: Routing (`lib/routes/`)

### `paths.dart` — Route path constants

```
/splash
/login
/signup
/forgot-password
/applicant                        (dashboard)
/applicant/register
/applicant/documents
/applicant/appointments
/applicant/appointments/book
/applicant/status
/applicant/status/:id
/officer                          (dashboard)
/officer/pending
/officer/review/:id
/officer/appointments
/admin                            (dashboard)
/admin/users
/admin/reports
/admin/audit-logs
/settings
/settings/profile
/privacy
/consent
```

### `routes.dart` — GoRouter configuration

- `redirect` logic: unauthenticated → `/login`; authenticated → role-appropriate dashboard (`/applicant`, `/officer`, `/admin`)
- `ShellRoute` per role for persistent bottom nav / drawer
- Nested routes within each role section
- Reactive redirects via `ref.watch(userRoleProvider)` inside `goRouterProvider`

### `error_page.dart` — 404 / unknown route fallback

### `goRouterProvider` — Riverpod provider creating the `GoRouter` instance

---

## Step 5: Global Theme & Shared Widgets (`lib/global/`)

### Theme (`lib/global/theme/`)

- `ColorScheme.fromSeed` with NIRA brand seed `#0D47A1` (deep blue, primary) and `#FFC107` (amber, accent — Uganda flag colors)
- Light + dark `ThemeData` provided to `MaterialApp.router`
- `NiraThemeExtension` (`ThemeExtension<NiraThemeExtension>`) — custom tokens: `successColor`, `warningColor`, `dangerColor`, `statusColors` (Map<ApplicationStatus, Color>)
- `google_fonts` — `Inter` as primary typeface; defined in `TextTheme`
- Component themes: `elevatedButtonTheme`, `cardTheme`, `inputDecorationTheme`, `appBarTheme`, `chipTheme`

### Shared Widgets (`lib/global/widgets/`)

- **`StatusBadge`** — color-coded chip for `ApplicationStatus` using `NiraThemeExtension.statusColors`
- **`NiraAppBar`** — consistent app bar with optional back button, role indicator chip
- **`NiraDrawer`** — navigation drawer, menu items conditional on `UserRole`
- **`NiraTextField`** — styled `TextFormField` with error state, prefix icon
- **`NiraDropdownField`** — styled `DropdownButtonFormField<T>`
- **`NiraDatePickerField`** — tappable date field launching `showDatePicker`
- **`LoadingOverlay`** — full-screen `Stack` overlay with `CircularProgressIndicator` and message
- **`ErrorDisplay`** — centered icon + message + optional retry `ElevatedButton`
- **`EmptyState`** — SVG illustration + headline + body text for empty lists
- **`AppButton`** — primary `ElevatedButton` with `isLoading` → `CircularProgressIndicator` swap
- **`EntranceFader`** — `AnimatedOpacity` + `AnimatedSlide` entrance animation wrapper

### Constants (`lib/global/constants/`)

- `AppDimens` — icon sizes, avatar sizes, image dimensions
- `AppSpacing` — 4, 8, 12, 16, 24, 32, 48 spacing scale
- `AppPadding` — screen horizontal padding, card padding
- `AppBorderRadius` — sm (4), md (8), lg (12), xl (16), pill (100)
- `AppDurations` — fast (150ms), medium (300ms), slow (500ms)
- `AppStrings` — app name, NIRA full name, tagline, error messages

### Validators (`lib/global/functions/validators.dart`)

Pure functions returning `String?` (null = valid):
- `validateEmail`, `validatePhone`, `validateRequired`, `validatePassword` (min 8, upper+lower+digit), `validateConfirmPassword`, `validateNIN` (NIRA National ID Number format), `validateFileSize(bytes, maxBytes)`, `validateDateOfBirth(dob)` (not future, not over 120 years)

---

## Step 6: Auth Screens (`lib/screens/auth/`)

### `LoginScreen`

- Email + password fields using `NiraTextField`
- "Forgot Password" `TextButton` → `/forgot-password`
- Submit triggers `LoginViewModel.login()`, watches loading + error state
- On success, `go_router` redirect handles navigation by role

### `SignupScreen`

- Full name, email, phone, password, confirm password
- Default role = `applicant` (not user-selectable; officers created by admins)
- Privacy consent `Checkbox` + link to `PrivacyNoticeScreen` — required before submit
- `SignupViewModel.signUp()` creates auth user + Firestore profile

### `ForgotPasswordScreen`

- Email input, "Send Reset Link" triggers `AuthCloudService.resetPassword()`
- Success / error message display

### ViewModels (`lib/screens/auth/view_model/`)

`LoginViewModel` and `SignupViewModel` extend `ChangeNotifier`:
- Properties: `isLoading`, `errorMessage`
- Methods: `login(email, password)`, `signUp(...)`, `clearError()`
- Delegate to `AuthCloudService` and `UserCloudService`
- Log audit action on successful login/logout

---

## Step 7: Applicant Screens (`lib/screens/applicant/`)

### `ApplicantDashboardScreen`

Overview cards: active applications count, upcoming appointments, recent status change (StreamBuilder). Quick actions: "New Registration", "My Documents", "Book Appointment", "My Appointments".

### `PreRegistrationScreen` (Multi-step `Stepper`)

5 steps:

1. **Demographics** — full name, DOB (`NiraDatePickerField`), gender (dropdown), nationality
2. **Address** — district (dropdown, seeded from service centres data), county, sub-county, parish, village
3. **Guardian Details** — shown only if age < 18; parent/guardian name + national ID
4. **Document Upload** — attach birth certificate + passport photo using `DocumentPicker` widget; file validation inline
5. **Review & Submit** — read-only preview of all entered data; consent checkbox; "Submit" button

On submit:
- Generate `trackingRef` = `NIRA-{year}-{uuid.v4().substring(0,6).toUpperCase()}`
- Create `ApplicationModel` in Firestore via `ApplicationCloudService.createApplication()`
- Upload documents via `DocumentCloudService.uploadDocument()` for each attached file
- Log audit: `action = create`, `targetCollection = applications`
- Navigate to `ApplicationDetailScreen` for the new application

ViewModel: `PreRegistrationVM` holds form state across steps, validates each step before advancing.

### `DocumentUploadScreen`

Add documents to an existing application. Reuses `DocumentPicker`. Shows existing documents for the application with verify/pending status. Validates type (jpg/png/pdf) and size (< 5 MB) before upload. Shows `UploadProgress` widget during upload.

### `DocumentPreviewScreen`

Full-size `InteractiveViewer` wrapping `CachedNetworkImage` (or PDF viewer for PDF docs). Document metadata shown in bottom sheet.

### `ApplicationsListScreen`

`StreamBuilder` on `applicationListProvider(uid)`. `ListView.builder` of cards with: tracking ref, full name, `StatusBadge`, created date. Tap → `ApplicationDetailScreen`. Empty state when no applications.

### `ApplicationDetailScreen`

Routed with `applicationId`. Sections:
- Header: tracking ref, `StatusBadge`, creation date
- Status timeline: visual stepper of application statuses showing current + completed
- Demographics: name, DOB, gender, nationality, address
- Guardian info (if present)
- Documents: thumbnail grid with per-document verification status
- Officer comments / rejection reason (if any)
- Appointment info (if booked)
- Actions: "Upload More Documents" (if under review), "Book Appointment" (if approved)

### `BookAppointmentScreen`

1. Select service centre — `CentreSelector` widget (searchable `DropdownSearch`-style with district filter)
2. Select date — `DatePicker` limited to weekdays, min today + 1 day, max 60 days
3. Select time slot — `GridView` of available 30-minute slots, fetched from `AppointmentCloudService.getAvailableSlots()`
4. Confirm — shows summary, "Confirm Booking" button
5. On success: generate `queueToken` = `{centreCode}-{date}-{4 digit sequence}`, navigate to `AppointmentDetailsScreen`

### `AppointmentDetailsScreen`

Queue token card (`QueueTokenCard` widget — prominent number, centre name, date/time). Reschedule + Cancel actions.

---

## Step 8: Officer Screens (`lib/screens/officer/`)

### `OfficerDashboardScreen`

Stats row: pending reviews, today's appointments, approved today. Recent pending applications list (top 5). Quick actions: "Review Queue", "Today's Appointments".

### `PendingApplicationsScreen`

`StreamBuilder` on `pendingVerificationsProvider`. Filter chips: All, Submitted, Under Review. `ListView.builder` of application cards with: applicant name, tracking ref, submission date, `StatusBadge`. Tap → `ApplicationReviewScreen`.

### `ApplicationReviewScreen`

Officer's primary work screen. Sections:

- **`DemographicReviewCard`** — all applicant demographics, editable (inline edit with save logs audit action `update`)
- **`DocumentReviewCard`** — document thumbnail, type label, Verify (`check` icon) / Flag (`flag` icon) buttons per document; tapping thumbnail opens `DocumentPreviewScreen`
- **`VerificationChecklist`** — checkboxes: identity confirmed, documents valid, data complete, photo matches
- **Action bar** (sticky bottom):
  - "Approve" → `ApplicationCloudService.updateApplicationStatus(id, biometricPending, officerUid)`
  - "Reject" → opens `RejectionReasonDialog` (text field, required, min 20 chars) → `updateApplicationStatus(id, rejected, officerUid, reason: ...)`
  - "Flag for More Info" → sets status back to `submitted` with a flag note

All actions: logged to audit trail, navigate back to `PendingApplicationsScreen`.

### `RejectionReasonDialog`

`AlertDialog` with `NiraTextField` for reason, validates not empty and min length. "Confirm Rejection" / "Cancel" actions.

### `DailyAppointmentsScreen`

`FutureBuilder` on `appointmentListProvider` filtered by today's date + officer's service centre. `ListView` of appointment cards: time slot, queue token, applicant name, application tracking ref. Mark as completed action.

---

## Step 9: Admin Screens (`lib/screens/admin/`)

Secondary priority — simpler dashboard-style views. Accessible only to `UserRole.admin` and `UserRole.supervisor`.

### `AdminDashboardScreen`

System-wide stats via Firestore aggregate queries: total registered users, applications by status (bar summary), registrations this month.

### `UserManagementScreen`

`ListView.builder` of all user documents. Per user: name, email, role chip, active status toggle, "Change Role" dropdown. All changes logged to audit.

### `ReportsScreen`

Summary metrics with date range filter: total applications, approval rate, rejection reasons frequency, registrations by district. Static `DataTable` or basic `ListView` of grouped metrics.

### `AuditLogsScreen`

Searchable, filterable `ListView` of audit log entries. Filter by: user (text search), action type (multi-select chips), date range (date pickers). Each entry shows: timestamp, user ID, role, action, target document ID.

---

## Step 10: Settings & Shared Screens

### `SettingsScreen`

- Theme toggle (`ThemeMode.light` / `ThemeMode.dark` / `ThemeMode.system`) via `ValueNotifier<ThemeMode>` stored in app state
- "Profile" → `/settings/profile`
- "Privacy Policy" → `/privacy`
- App version from `package_info_plus`
- Logout button (with confirmation dialog)

### `ProfileScreen`

View + edit: full name, email (read-only), phone. "Change Password" → `ForgotPasswordScreen` pre-filled. Avatar placeholder (initials).

### `PrivacyNoticeScreen`

Static content explaining NIRA data handling, references to Registration of Persons Act and Data Protection and Privacy Act (Uganda). Formatted text with section headers.

### `ConsentScreen`

Shown once before first registration submission. Checkbox list of consent items. "I Agree" enables and submits. Stores `consentGiven = true` on `UserModel`.

---

## Step 11: Audit Logging Integration

`AuditCloudService.logAction()` called at these triggers:

| Action | Trigger location |
|---|---|
| `login` | `LoginViewModel.login()` on success |
| `logout` | `SettingsScreen` logout handler |
| `loginFailed` | `LoginViewModel.login()` on auth failure |
| `create` | `ApplicationCloudService.createApplication()` |
| `upload` | `DocumentCloudService.uploadDocument()` |
| `update` | Any demographic edit in `ApplicationReviewScreen` |
| `approve` | `ApplicationCloudService.updateApplicationStatus()` → approved |
| `reject` | `ApplicationCloudService.updateApplicationStatus()` → rejected |
| `flag` | `DocumentCloudService.flagDocument()` |
| `verify` | `DocumentCloudService.verifyDocument()` |
| `delete` | `DocumentCloudService.deleteDocument()` |
| `roleChange` | `UserCloudService.assignRole()` |
| `deactivate` | `UserCloudService.deactivateUser()` |

Log fields per entry: `userId`, `userRole`, `action`, `targetCollection`, `targetDocId`, `details` (Map with context), `timestamp`.

Audit logs are append-only — Firestore Security Rules deny `update` and `delete` on `audit_logs` collection for all clients.

---

## Step 12: Firestore Schema & Security Rules

### Collections

| Collection | Doc ID | Key Fields |
|---|---|---|
| `users` | Firebase UID | email, fullName, phone, role, isActive, fcmToken, consentGiven, createdAt, lastLogin |
| `applications` | Auto | trackingRef, applicantUid, fullName, dob, gender, nationality, address{}, guardianName, guardianId, status, officerUid, rejectionReason, documentIds[], createdAt, updatedAt |
| `documents` | Auto | applicationId, type, fileName, imageUrl, fileSize, mimeType, isVerified, verifiedByUid, flagReason, uploadedAt |
| `appointments` | Auto | applicationId, applicantUid, serviceCentreId, dateTime, queueToken, status, createdAt |
| `service_centres` | Manual | name, district, address, operatingHours, isActive |
| `audit_logs` | Auto | userId, userRole, action, targetCollection, targetDocId, details, timestamp |

### Security Rules conceptual model

- **Applicant**: read/write own `users` doc; create `applications`; read own `applications`/`documents`/`appointments`; create `appointments`
- **Officer**: read all `applications` where status in [submitted, underReview] or assigned to them; update `applications` status + fields; read + create `audit_logs`; read `appointments` for their centre
- **Supervisor**: read all `applications`, `users`, `audit_logs`, `appointments`; no write on `users`
- **Admin**: full read/write on `users`; read all collections; assign roles
- **`audit_logs`**: no `update` or `delete` for any role (append-only)

---

## Step 13: Push Notifications (FCM)

- Add `firebase_messaging` dependency
- Request notification permissions on app start (inside `main()` after Firebase init)
- Store FCM token in `users/{uid}.fcmToken` on each login
- Key notification triggers (in-app, using `FirebaseMessaging.onMessage` stream):
  - Applicant: status change on their application
  - Officer: new application submitted for review
  - Applicant: appointment confirmation / reminder
- In-app notification bell icon in `NiraAppBar` with `StreamBuilder` on unread count

---

## Step 14: Testing Framework

### Structure

```
test/
├── unit/
│   ├── models/
│   │   ├── user_model_test.dart
│   │   ├── application_model_test.dart
│   │   └── document_model_test.dart
│   ├── validators_test.dart
│   └── view_models/
│       ├── login_view_model_test.dart
│       ├── pre_registration_vm_test.dart
│       └── verification_vm_test.dart
├── widget/
│   ├── status_badge_test.dart
│   ├── app_button_test.dart
│   ├── login_screen_test.dart
│   └── pre_registration_screen_test.dart
integration_test/
├── auth_flow_test.dart       # signup → login → dashboard
├── pre_registration_test.dart # full registration form submission
└── officer_review_test.dart  # officer review → approve flow
```

### Patterns

- **Unit tests**: Arrange-Act-Assert; mock services with `mocktail`; Riverpod `ProviderContainer` with overrides for DI
- **Widget tests**: `pumpWidget` with `ProviderScope(overrides: [...])`, `flutter_test` matchers + `package:checks`
- **Integration tests**: `integration_test` package (Flutter SDK); real Firebase test project or emulator

### Required test cases (per NIRA spec)

- Valid login → navigates to correct role dashboard
- Invalid login → error message displayed
- Form validation → each required field shows error when empty
- Document upload → file size > 5 MB is rejected
- Application status update → `StreamBuilder` reflects change
- Audit log entry created on application submission

---

## Step 15: Legal Compliance UI

- **`PrivacyNoticeScreen`**: references Registration of Persons Act + Data Protection and Privacy Act (Uganda 2019)
- **`ConsentScreen`**: explicit consent before first registration; stored on user record
- **Data minimisation**: only collect fields listed in spec; no optional over-collection
- **Auto-clear**: delete local file references after successful upload (`DocumentCloudService` clears temp file path)
- **Masked data**: NIN/ID numbers masked in list views (show last 4 digits only)
- **Session timeout**: re-prompt for password after 30 minutes of inactivity (optional, using `flutter_secure_storage` for session tracking)

---

## Step 16: App Entry Point & Wiring (`lib/main.dart`)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();
  runApp(const ProviderScope(child: IdExpress()));
}
```

`IdExpress` widget (`lib/app/id_express.dart`):
- `ConsumerWidget` watching `goRouterProvider` and `themeProvider`
- `MaterialApp.router` with `routerConfig: goRouter`, `theme: AppTheme.light`, `darkTheme: AppTheme.dark`, `themeMode: themeMode`

---

## Key Architectural Decisions

| Decision | Choice | Rationale |
|---|---|---|
| State management | Riverpod (code gen) | Cleaner `@riverpod` annotations, compile-time safety, excellent DI support |
| Navigation | go_router | Per rules.md; declarative, deep linking, role-based redirects |
| Backend | Firebase client-side only | No Cloud Functions; Firestore Security Rules + client RBAC |
| Offline/sync | Skipped | Firebase SDK handles local caching natively |
| Roles in scope | Applicant + Officer primary; Admin/Supervisor secondary | Per user decision |
| Data models | json_serializable + fieldRename.snake | Type safety, consistent snake_case ↔ camelCase mapping |
| Existing code | Fully replaced | Current screens/services violate all rules.md guidelines |
| Audit logging | Append-only Firestore collection | Tamper-resistant; matches NIRA audit trail requirement |
| Tracking ref format | `NIRA-{YEAR}-{6-char UUID}` | Human-readable, unique, NIRA-branded |
| Document validation | Client-side: type (jpg/png/pdf) + size (< 5 MB) | Immediate user feedback; Firestore rules for server enforcement |
| Theme | Material 3, ColorScheme.fromSeed, light + dark | Per rules.md; NIRA brand colors (deep blue + amber) |
| Typography | google_fonts Inter | Clean, screen-optimized, widely legible |
