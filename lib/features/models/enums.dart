/// User role enum
enum UserRole {
  /// Applicant/Citizen
  applicant,

  /// NIRA Officer/Staff
  officer,

  /// Supervisor
  supervisor,

  /// Administrator
  admin,
}

/// Application type enum
enum ApplicationType {
  /// New registration
  newRegistration,

  /// Renewal
  renewal,

  /// Replacement (lost/damaged)
  replacement,

  /// Change of particulars
  changeOfParticulars,
}

/// Application status enum
enum ApplicationStatus {
  /// Draft - not yet submitted
  draft,

  /// Submitted - waiting for review
  submitted,

  /// Under review by officer
  underReview,

  /// Approved - ready for biometric capture
  approved,

  /// Rejected - needs correction
  rejected,

  /// Biometric captured - processing
  biometricCaptured,

  /// ID ready for collection
  idReady,

  /// Completed - ID collected
  completed,

  /// Cancelled
  cancelled,
}

/// Appointment lifecycle status enum
enum AppointmentStatus {
  /// Confirmed - booked and upcoming
  confirmed,

  /// Completed - marked as done by an officer/admin
  completed,

  /// Overdue - appointment date has passed without being completed
  overdue,

  /// Cancelled by the applicant
  cancelled,
}

/// Document type enum
enum DocumentType {
  /// Passport photo
  passportPhoto,

  /// Birth certificate
  birthCertificate,

  /// School ID
  schoolId,

  /// Previous national ID
  previousNationalId,

  /// Marriage certificate
  marriageCertificate,

  /// Recommendation letter
  recommendationLetter,

  /// Other supporting document
  other,
}

/// Gender enum
enum Gender {
  /// Male
  male,

  /// Female
  female,
}

/// Marital status enum
enum MaritalStatus {
  /// Single
  single,

  /// Married
  married,

  /// Divorced
  divorced,

  /// Widowed
  widowed,
}

/// Notification type enum
enum NotificationType {
  /// Application status update
  applicationStatus,

  /// Appointment reminder
  appointmentReminder,

  /// Biometric appointment
  biometricAppointment,

  /// ID ready for collection
  idReady,

  /// General announcement
  announcement,

  /// System notification
  system,
}
