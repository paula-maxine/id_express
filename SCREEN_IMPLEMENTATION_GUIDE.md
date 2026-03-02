# NIRA Implementation - Screen Implementation Guide

## Overview

This guide provides step-by-step instructions for implementing the remaining screens. The foundation is complete with all services, providers, and theming in place.

## Architecture Pattern

All feature screens follow this pattern:

```
lib/screens/{feature}/
├── {feature}_screen.dart          # Main UI screen
├── view_model/
│   └── {feature}_view_model.dart  # State management (if needed)
└── widgets/
    └── {widget_name}.dart         # Feature-specific components
```

## ViewModel Pattern (when needed)

For complex screens with business logic:

```dart
class MyViewModel extends ChangeNotifier {
  final MyCloudService _service;
  
  bool _isLoading = false;
  String? _error;
  
  MyViewModel(this._service);
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> doSomething() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Call service
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

## Screen Implementation Checklist

### Step 6: Auth Screens (Priority: HIGH)

#### LoginScreen

**File**: `lib/screens/auth/login_screen.dart`
**Key Features**:

- Email TextFormField with validator
- Password TextFormField with visibility toggle
- "Forgot Password?" TextButton
- "Sign Up" TextButton
- Login AppButton with isLoading state
- Error message display
- Link to signup

**Implementation Notes**:

- Use `ref.watch(authCloudServiceProvider)` to get auth service
- Call `authService.login(email, password)`
- On success, GoRouter auto-redirects via authStateProvider
- Log audit action: `action: 'login'`

**Template**:

```dart
class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authCloudServiceProvider);
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    
    // Build form with email, password, buttons
    // Call authService.login() on submit
  }
}
```

#### SignupScreen

**File**: `lib/screens/auth/signup_screen.dart`
**Key Features**:

- Full name, email, phone, password, confirm password
- Privacy consent checkbox (REQUIRED)
- Link to `/privacy` for policy
- Validation using `AppValidators`
- Success → auto login + redirect

#### ForgotPasswordScreen

**File**: `lib/screens/auth/forgot_password_screen.dart`
**Key Features**:

- Email TextFormField
- "Send Reset Link" button
- Success/error message display
- "Back to Login" link

---

### Step 7: Applicant Screens (Priority: HIGH)

#### ApplicantDashboardScreen

**File**: `lib/screens/applicant/dashboard/applicant_dashboard_screen.dart`
**Key Features**:

- Active applications count card
- Upcoming appointments card
- Recent status card
- Quick action buttons (New Registration, My Documents, etc.)
- Drawer with user name, role, menu items

**Data Sources**:

- `ref.watch(applicationListProvider)` - user's applications
- `ref.watch(appointmentStreamProvider)` - upcoming appointments

#### PreRegistrationScreen

**File**: `lib/screens/applicant/pre_registration/pre_registration_screen.dart`
**Structure**: 5-step Stepper

1. **Demographics** - full name, DOB, gender, nationality
2. **Address** - district (dropdown), county, sub-county, parish, village
3. **Guardian Details** - conditional (if age < 18)
4. **Document Upload** - birth cert + passport photo
5. **Review & Submit** - read-only preview + consent checkbox

**Key Implementation**:

- Use `Stepper` widget for step navigation
- Validate each step before advancing
- On submit:
  - Generate tracking ref: `NIRA-{year}-{uuid.substring(0,6).toUpperCase()}`
  - Create ApplicationModel
  - Call `appService.createApplication()`
  - Upload documents via `docService.createDocumentRecord()`
  - Log audit: `action: 'create'`
  - Navigate to `ApplicationDetailScreen`

**ViewModel**: `PreRegistrationViewModel extends ChangeNotifier`

- Methods: `advanceStep()`, `goToPreviousStep()`, `submitApplication()`

#### DocumentUploadScreen

**File**: `lib/screens/applicant/document_upload/document_upload_screen.dart`
**Features**:

- Display existing documents for application (grid)
- Add new document button
- File picker (jpg/png/pdf, < 5MB)
- Upload progress indicator
- Verify/pending status badges

**Data Source**: `ref.watch(documentsStreamProvider(appId))`

#### DocumentPreviewScreen

**File**: `lib/screens/applicant/document_upload/document_preview_screen.dart`
**Features**:

- Full-screen InteractiveViewer for image
- Document metadata (type, size, uploaded date, verification status)
- Verify/flag buttons (if officer viewing)

#### ApplicationsListScreen

**File**: `lib/screens/applicant/status_tracking/applications_list_screen.dart`
**Features**:

- StreamBuilder on `applicationListProvider`
- ListView of application cards (tracking ref, status badge, date)
- Empty state when no applications
- Tap → ApplicationDetailScreen

#### ApplicationDetailScreen

**File**: `lib/screens/applicant/status_tracking/application_detail_screen.dart`
**Sections**:

- Header: tracking ref, status badge, creation date
- Status timeline (visual stepper)
- Demographics section (read-only)
- Documents section (grid with thumbnails)
- Officer comments / rejection reason
- Appointment info (if any)
- Actions: "Upload Documents", "Book Appointment" (conditional)

**Data Sources**:

- `ref.watch(applicationProvider(appId))`
- `ref.watch(documentsStreamProvider(appId))`
- `ref.watch(appointmentStreamProvider)`

#### BookAppointmentScreen

**File**: `lib/screens/applicant/appointments/book_appointment_screen.dart`
**Steps** (using Stepper):

1. Select service centre (dropdown or list)
2. Select date (DatePicker, weekdays only, min today+1, max 60 days)
3. Select time slot (GridView of 30-min slots)
4. Confirm (summary card + button)

**Key Logic**:

- Fetch available slots: `appointmentService.getAppointmentsByDate(centreId, date)`
- Generate queue token: `{centreCode}-{date}-{4-digit sequence}`
- Create appointment with status: `'scheduled'`
- Log audit: `action: 'create'` targetCollection: `'appointments'`

#### AppointmentDetailsScreen

**File**: `lib/screens/applicant/appointments/appointment_details_screen.dart`
**Features**:

- QueueTokenCard (prominent display)
- Centre name, date, time
- Reschedule button → DatePicker
- Cancel button (with confirmation)

**Data Source**: Route parameter `appointmentId`

#### Status Tracking ViewModel (optional)

**File**: `lib/screens/applicant/status_tracking/view_model/status_tracking_vm.dart`

---

### Step 8: Officer Screens (Priority: MEDIUM)

#### OfficerDashboardScreen

**File**: `lib/screens/officer/dashboard/officer_dashboard_screen.dart`
**Features**:

- Pending reviews count
- Today's appointments count
- Approved today count
- Recent pending applications (top 5)
- Quick action buttons: "Review Queue", "Today's Appointments"

**Data Sources**:

- `ref.watch(pendingVerificationsProvider)`
- `ref.watch(appointmentsByDateProvider((centreId, today)))`

#### PendingApplicationsScreen

**File**: `lib/screens/officer/verification/pending_applications_screen.dart`
**Features**:

- Filter chips: All, Submitted, Under Review
- ListView of application cards
- Card shows: applicant name, tracking ref, submission date, status badge
- Tap → ApplicationReviewScreen

**Data Source**: `ref.watch(pendingVerificationsProvider)`

#### ApplicationReviewScreen

**File**: `lib/screens/officer/verification/application_review_screen.dart`
**Main Sections** (using SingleChildScrollView):

1. **DemographicReviewCard** - name, dob, gender, nationality, address (editable)
2. **DocumentReviewCard** - each doc with thumbnail, Verify/Flag buttons
3. **VerificationChecklist** - checkboxes for validation items
4. **Sticky action bar** (bottom):
   - "Approve" → status: `'biometricPending'`
   - "Reject" → show RejectionReasonDialog, status: `'rejected'`
   - "Flag for More Info" → status back to `'submitted'` with note

**Key Logic**:

- Update status: `appService.updateApplicationStatus(appId, newStatus, officerUid, reason?)`
- Verify document: `docService.verifyDocument(docId, officerUid)`
- Flag document: `docService.flagDocument(docId, reason)`
- Log all actions to audit

#### RejectionReasonDialog

**File**: `lib/screens/officer/verification/widgets/rejection_reason_dialog.dart`
**Features**:

- Text field for rejection reason (min 20 chars)
- "Confirm Rejection" / "Cancel" buttons
- Validates required and min length

#### DailyAppointmentsScreen

**File**: `lib/screens/officer/appointments/daily_appointments_screen.dart`
**Features**:

- FutureBuilder on appointments for today
- ListView of appointment cards: time, queue token, applicant name, tracking ref
- "Mark as Completed" button per appointment
- Empty state if no appointments

---

### Step 9: Admin Screens (Priority: MEDIUM)

#### AdminDashboardScreen

**File**: `lib/screens/admin/admin_dashboard_screen.dart`
**Metrics**:

- Total registered users
- Applications by status (bar summary)
- Registrations this month (chart or counter)

#### UserManagementScreen

**File**: `lib/screens/admin/user_management_screen.dart`
**Features**:

- DataTable or ListView of users
- Per user: name, email, role (chip with change dropdown), active (toggle)
- Edit role → show dropdown with roles
- All changes logged to audit

#### ReportsScreen

**File**: `lib/screens/admin/reports_screen.dart`
**Metrics**:

- Date range filter (date pickers)
- Total applications, approval rate
- Rejection reasons frequency
- Registrations by district (grouped list)

#### AuditLogsScreen

**File**: `lib/screens/admin/audit_logs_screen.dart`
**Features**:

- Search by user (text field)
- Filter by action type (multi-select chips)
- Date range filter
- ListView of audit entries: timestamp, user ID, role, action, target

**Data Source**: `ref.watch(auditLogProvider)`

---

### Step 10: Settings & Shared Screens (Priority: MEDIUM)

#### SettingsScreen

**File**: `lib/screens/settings/settings_screen.dart`
**Options**:

- Theme toggle (Light/Dark/System)
- "Profile" → ProfileScreen
- "Privacy Policy" → PrivacyPolicyScreen
- App version (from `package_info_plus`)
- Logout button (with confirmation dialog)

#### ProfileScreen

**File**: `lib/screens/settings/profile_screen.dart`
**Features**:

- Avatar (initials)
- Edit: full name, phone
- Email (read-only)
- "Change Password" → password reset flow
- Save button with validation

#### PrivacyNoticeScreen

**File**: `lib/screens/shared/privacy_notice_screen.dart`
**Content**:

- Static HTML or formatted text
- References: Registration of Persons Act, Data Protection and Privacy Act (Uganda)
- Data handling explanation
- Sections: data collection, usage, rights, etc.

#### ConsentScreen

**File**: `lib/screens/shared/consent_screen.dart`
**Features**:

- Checkbox list of consent items
- "I Agree" button (enables when all checked)
- Stores `consentGiven: true` on user record
- Shown once before first registration

---

## Common Patterns

### Using Providers in Screens

```dart
// Watch a provider
final data = ref.watch(myProvider);

// Handle async states
final asyncValue = ref.watch(asyncProvider);
asyncValue.when(
  data: (data) => buildContent(data),
  loading: () => LoadingOverlay(isLoading: true, child: SizedBox.expand()),
  error: (e, st) => ErrorDisplay(message: e.toString()),
);
```

### Creating a ViewModel

```dart
final myViewModelProvider = StateNotifierProvider<MyViewModelState, MyViewModel>(
  (ref) => MyViewModel(ref.watch(myServiceProvider)),
);
```

### Using Form Validation

```dart
if (AppValidators.validateEmail(email) != null) {
  // Show error
}
```

### Logging Audit Events

```dart
final auditService = ref.watch(auditCloudServiceProvider);
await auditService.logAction(
  AuditLogModel(
    id: uuid.v4(),
    userId: userId,
    userRole: userRole,
    action: 'create',
    targetCollection: 'applications',
    targetDocId: appId,
    details: {'reason': 'submitted'},
    timestamp: DateTime.now(),
  ),
);
```

---

## Dependencies & Imports

Standard imports for feature screens:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// From our app
import '../../../data/cloud/exporter.dart';
import '../../../data/model/exporter.dart';
import '../../../global/exporter.dart';
import '../../../providers/exporter.dart';
import '../../../routes/paths.dart';
```

---

## Testing Checklist (Step 14)

For each screen, create unit tests:

```dart
test('Form validates required fields', () {
  expect(AppValidators.validateRequired(''), isNotNull);
  expect(AppValidators.validateRequired('value'), isNull);
});

test('LoginScreen shows error on failed login', () async {
  // Mock authService
  // Pump widget
  // Enter invalid credentials
  // Verify error message appears
});
```

---

## Firestore Security Rules (Step 12)

Key rules to implement:

```javascript
// Applicants can only read own applications
match /applications/{appId} {
  allow read: if request.auth.uid == resource.data.applicant_uid
                || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['officer', 'supervisor', 'admin'];
  allow create: if request.auth.uid == request.resource.data.applicant_uid;
  allow update: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['officer', 'supervisor', 'admin'];
}

// Audit logs are append-only
match /audit_logs/{logId} {
  allow read: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'supervisor'];
  allow create: if request.auth.uid != null;
  allow update, delete: if false;
}
```

---

## Next Command to Build

Once screens are implemented:

```bash
# Clean before build
flutter clean

# Get dependencies
flutter pub get

# Generate code (json_serializable, riverpod_generator)
dart run build_runner build

# Run tests
flutter test

# Run the app
flutter run
```

---

## Progress Tracking

Use this list to track screen implementation:

### Auth Screens

- [ ] LoginScreen
- [ ] SignupScreen  
- [ ] ForgotPasswordScreen

### Applicant Screens

- [ ] ApplicantDashboardScreen
- [ ] PreRegistrationScreen (5-step stepper)
- [ ] DocumentUploadScreen
- [ ] DocumentPreviewScreen
- [ ] ApplicationsListScreen
- [ ] ApplicationDetailScreen
- [ ] BookAppointmentScreen (4-step)
- [ ] AppointmentDetailsScreen

### Officer Screens

- [ ] OfficerDashboardScreen
- [ ] PendingApplicationsScreen
- [ ] ApplicationReviewScreen
- [ ] RejectionReasonDialog
- [ ] DailyAppointmentsScreen

### Admin Screens

- [ ] AdminDashboardScreen
- [ ] UserManagementScreen
- [ ] ReportsScreen
- [ ] AuditLogsScreen

### Settings Screens

- [ ] SettingsScreen
- [ ] ProfileScreen
- [ ] PrivacyNoticeScreen
- [ ] ConsentScreen

---

## Notes

- All models, services, and providers are ready
- Use `const` constructors where possible for performance
- Remember to handle loading and error states
- Log all user actions to audit trail
- Test on Android, iOS, and Web if possible
- Keep responsive design in mind (use MediaQuery or LayoutBuilder)
