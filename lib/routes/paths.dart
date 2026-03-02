/// Route path constants
class RoutesPaths {
  // Common routes
  static const String home = '/';

  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Applicant routes
  static const String applicantDashboard = '/applicant';
  static const String preRegistration = '/applicant/register';
  static const String documentUpload = '/applicant/documents';
  static const String documentPreview = '/applicant/documents/preview/:id';
  static const String appointments = '/applicant/appointments';
  static const String bookAppointment = '/applicant/appointments/book';
  static const String appointmentDetails = '/applicant/appointments/:id';
  static const String statusTracking = '/applicant/status';
  static const String applicationDetail = '/applicant/status/:id';

  // Officer routes
  static const String officerDashboard = '/officer';
  static const String pendingApplications = '/officer/pending';
  static const String applicationReview = '/officer/review/:id';
  static const String dailyAppointments = '/officer/appointments';

  // Admin routes
  static const String adminDashboard = '/admin';
  static const String userManagement = '/admin/users';
  static const String reports = '/admin/reports';
  static const String auditLogs = '/admin/audit-logs';

  // Settings routes
  static const String settings = '/settings';
  static const String profile = '/settings/profile';
  static const String privacyPolicy = '/privacy';
  static const String consent = '/consent';

  // Shared routes
  static const String notFound = '/404';
  static const String error = '/error';
}
