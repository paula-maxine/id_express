/// Route paths
library;

/// Initial path
const String initialPath = '/';

/// Welcome/Landing page
const String welcomePath = '/welcome';

/// Auth paths
const String loginPath = '/login';
const String signupPath = '/signup';
const String forgotPasswordPath = '/forgot-password';
const String registerPath = '/register';
const String otpVerifyPath = '/otp-verify';

/// Splash
const String splashPath = '/splash';

/// Home paths
const String homePath = '/home';
const String applicantHomePath = '/applicant-home';
const String officerHomePath = '/officer-home';

/// Application paths
const String newApplicationPath = '/application/new';
const String applicationsListPath = '/applications';
const String applicationDetailPath = '/application/:id';

/// Document paths
const String documentsPath = '/documents';
const String uploadDocumentPath = '/upload-document';

/// Appointment paths
const String appointmentsPath = '/appointments';
const String bookAppointmentPath = '/book-appointment';
const String appointmentDetailPath = '/appointment/:id';

/// Notification paths
const String notificationsPath = '/notifications';

/// Profile paths
const String profilePath = '/profile';
const String editProfilePath = '/profile/edit';

/// Officer paths
const String officerDashboardPath = '/officer/dashboard';
const String officerReviewPath = '/officer/review/:id';
const String officerAuditLogsPath = '/officer/audit-logs';
const String pendingApplicationsPath = '/officer/pending-applications';
const String dailyAppointmentsPath = '/officer/daily-appointments';

/// Admin paths
const String adminDashboardPath = '/admin/dashboard';

/// Settings paths
const String settingsPath = '/settings';
const String privacyPolicyPath = '/privacy-policy';

/// Applicant sub-paths
const String preRegistrationPath = '/applicant/pre-registration';
const String applicantBookAppointmentPath = '/applicant/book-appointment';
const String appointmentDetailsPath = '/applicant/appointment-details';

/// Compatibility class for legacy screens that use [RoutesPaths.path] notation.
abstract final class RoutesPaths {
  static const String splash = splashPath;
  static const String home = homePath;
  static const String login = loginPath;
  static const String signup = signupPath;
  static const String forgotPassword = forgotPasswordPath;
  static const String applicantDashboard = applicantHomePath;
  static const String officerDashboard = officerDashboardPath;
  static const String adminDashboard = adminDashboardPath;
  static const String preRegistration = preRegistrationPath;
  static const String bookAppointment = applicantBookAppointmentPath;
  static const String appointmentDetails = appointmentDetailsPath;
  static const String pendingApplications = pendingApplicationsPath;
  static const String dailyAppointments = dailyAppointmentsPath;
  static const String settings = settingsPath;
  static const String privacyPolicy = privacyPolicyPath;
}
