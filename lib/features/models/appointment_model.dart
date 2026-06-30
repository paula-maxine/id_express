/// Appointment model for biometric capture scheduling
class AppointmentModel {
  /// Creates an appointment model
  const AppointmentModel({
    required this.appointmentId,
    required this.applicationId,
    required this.applicantId,
    required this.centerId,
    required this.centerName,
    required this.appointmentDate,
    required this.timeSlot,
    this.isCancelled = false,
    this.isCompleted = false,
    this.queueNumber = '',
    this.centerAddress = '',
    this.createdAt,
    this.updatedAt,
  });

  /// Appointment ID
  final String appointmentId;

  /// Associated application ID
  final String applicationId;

  /// Applicant user ID
  final String applicantId;

  /// Registration center ID
  final String centerId;

  /// Registration center name
  final String centerName;

  /// Registration center address
  final String centerAddress;

  /// Appointment date
  final DateTime appointmentDate;

  /// Time slot (e.g., "9:00 AM - 10:00 AM")
  final String timeSlot;

  /// Queue number
  final String queueNumber;

  /// Whether appointment is cancelled
  final bool isCancelled;

  /// Whether appointment is completed
  final bool isCompleted;

  /// Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Factory from Firestore document
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      appointmentId: map['appointment_id'] as String? ?? '',
      applicationId: map['application_id'] as String? ?? '',
      applicantId: map['applicant_id'] as String? ?? '',
      centerId: map['center_id'] as String? ?? '',
      centerName: map['center_name'] as String? ?? '',
      centerAddress: map['center_address'] as String? ?? '',
      appointmentDate: map['appointment_date'] != null
          ? DateTime.parse(map['appointment_date'] as String)
          : DateTime.now(),
      timeSlot: map['time_slot'] as String? ?? '',
      queueNumber: map['queue_number'] as String? ?? '',
      isCancelled: map['is_cancelled'] as bool? ?? false,
      isCompleted: map['is_completed'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'appointment_id': appointmentId,
      'application_id': applicationId,
      'applicant_id': applicantId,
      'center_id': centerId,
      'center_name': centerName,
      'center_address': centerAddress,
      'appointment_date': appointmentDate.toIso8601String(),
      'time_slot': timeSlot,
      'queue_number': queueNumber,
      'is_cancelled': isCancelled,
      'is_completed': isCompleted,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Convenience getter for Firestore withConverter
  Map<String, dynamic> get asMap => toMap();

  /// Immutable copy
  AppointmentModel copyWith({
    String? appointmentId,
    String? applicationId,
    String? applicantId,
    String? centerId,
    String? centerName,
    String? centerAddress,
    DateTime? appointmentDate,
    String? timeSlot,
    String? queueNumber,
    bool? isCancelled,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      appointmentId: appointmentId ?? this.appointmentId,
      applicationId: applicationId ?? this.applicationId,
      applicantId: applicantId ?? this.applicantId,
      centerId: centerId ?? this.centerId,
      centerName: centerName ?? this.centerName,
      centerAddress: centerAddress ?? this.centerAddress,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      queueNumber: queueNumber ?? this.queueNumber,
      isCancelled: isCancelled ?? this.isCancelled,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty instance
  static AppointmentModel get empty => AppointmentModel(
    appointmentId: '',
    applicationId: '',
    applicantId: '',
    centerId: '',
    centerName: '',
    appointmentDate: DateTime.now(),
    timeSlot: '',
  );

  /// Check if appointment is upcoming
  bool get isUpcoming =>
      appointmentDate.isAfter(DateTime.now()) && !isCancelled;

  /// Check if appointment is past
  bool get isPast => appointmentDate.isBefore(DateTime.now());

  /// Check if appointment is today
  bool get isToday {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;
  }
}
