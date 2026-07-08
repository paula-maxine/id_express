import 'enums.dart';

/// Appointment model for scheduling a service booking
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
    this.serviceType = ApplicationType.newRegistration,
    this.status = AppointmentStatus.confirmed,
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

  /// The service (application type) this appointment is for
  final ApplicationType serviceType;

  /// Registration center ID (location)
  final String centerId;

  /// Registration center name (location)
  final String centerName;

  /// Registration center address (location)
  final String centerAddress;

  /// Appointment date
  final DateTime appointmentDate;

  /// Time slot (e.g., "9:00 AM - 10:00 AM")
  final String timeSlot;

  /// Queue number
  final String queueNumber;

  /// Persisted lifecycle status
  final AppointmentStatus status;

  /// Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Factory from Firestore document
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    // Backwards-compatible status resolution: prefer the explicit status
    // field, but fall back to the legacy boolean flags for older documents.
    AppointmentStatus resolveStatus() {
      final raw = map['status'] as String?;
      if (raw != null && raw.isNotEmpty) {
        return _statusFromString(raw);
      }
      if (map['is_cancelled'] as bool? ?? false) {
        return AppointmentStatus.cancelled;
      }
      if (map['is_completed'] as bool? ?? false) {
        return AppointmentStatus.completed;
      }
      return AppointmentStatus.confirmed;
    }

    return AppointmentModel(
      appointmentId: map['appointment_id'] as String? ?? '',
      applicationId: map['application_id'] as String? ?? '',
      applicantId: map['applicant_id'] as String? ?? '',
      serviceType: _serviceTypeFromString(
        map['service_type'] as String? ?? 'newRegistration',
      ),
      centerId: map['center_id'] as String? ?? '',
      centerName: map['center_name'] as String? ?? '',
      centerAddress: map['center_address'] as String? ?? '',
      appointmentDate: map['appointment_date'] != null
          ? DateTime.parse(map['appointment_date'] as String)
          : DateTime.now(),
      timeSlot: map['time_slot'] as String? ?? '',
      queueNumber: map['queue_number'] as String? ?? '',
      status: resolveStatus(),
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
      'service_type': serviceType.name,
      'center_id': centerId,
      'center_name': centerName,
      'center_address': centerAddress,
      'appointment_date': appointmentDate.toIso8601String(),
      'time_slot': timeSlot,
      'queue_number': queueNumber,
      'status': status.name,
      // Legacy flags kept in sync for any consumer still reading them.
      'is_cancelled': status == AppointmentStatus.cancelled,
      'is_completed': status == AppointmentStatus.completed,
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
    ApplicationType? serviceType,
    String? centerId,
    String? centerName,
    String? centerAddress,
    DateTime? appointmentDate,
    String? timeSlot,
    String? queueNumber,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      appointmentId: appointmentId ?? this.appointmentId,
      applicationId: applicationId ?? this.applicationId,
      applicantId: applicantId ?? this.applicantId,
      serviceType: serviceType ?? this.serviceType,
      centerId: centerId ?? this.centerId,
      centerName: centerName ?? this.centerName,
      centerAddress: centerAddress ?? this.centerAddress,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      queueNumber: queueNumber ?? this.queueNumber,
      status: status ?? this.status,
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

  /// Whether this appointment was cancelled
  bool get isCancelled => status == AppointmentStatus.cancelled;

  /// Whether this appointment was completed (marked done)
  bool get isCompleted => status == AppointmentStatus.completed;

  /// Whether the appointment date/slot has already passed.
  ///
  /// The slot end is treated as the end of the appointment day so an
  /// appointment only becomes past the day after its date.
  bool get _hasPassed {
    final endOfDay = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      23,
      59,
      59,
    );
    return DateTime.now().isAfter(endOfDay);
  }

  /// The status to display, computed locally.
  ///
  /// If the appointment is still marked [AppointmentStatus.confirmed] but its
  /// date has already passed, it is surfaced as [AppointmentStatus.overdue]
  /// immediately — even before the cloud record is updated by the sweep.
  AppointmentStatus get effectiveStatus {
    if (status == AppointmentStatus.confirmed && _hasPassed) {
      return AppointmentStatus.overdue;
    }
    return status;
  }

  /// Whether the appointment is upcoming (confirmed and not yet passed)
  bool get isUpcoming =>
      status == AppointmentStatus.confirmed && !_hasPassed;

  /// Whether the appointment is overdue (locally computed)
  bool get isOverdue => effectiveStatus == AppointmentStatus.overdue;

  /// Whether the appointment is today
  bool get isToday {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;
  }

  /// Parse [AppointmentStatus] from its stored name
  static AppointmentStatus _statusFromString(String value) {
    switch (value.toLowerCase()) {
      case 'completed':
        return AppointmentStatus.completed;
      case 'overdue':
        return AppointmentStatus.overdue;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      default:
        return AppointmentStatus.confirmed;
    }
  }

  /// Parse [ApplicationType] from its stored name
  static ApplicationType _serviceTypeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'renewal':
        return ApplicationType.renewal;
      case 'replacement':
        return ApplicationType.replacement;
      case 'changeofparticulars':
      case 'change_of_particulars':
        return ApplicationType.changeOfParticulars;
      default:
        return ApplicationType.newRegistration;
    }
  }
}

/// Human-readable label helpers for appointment enums
extension AppointmentStatusLabel on AppointmentStatus {
  /// Display label
  String get label => switch (this) {
    AppointmentStatus.confirmed => 'Confirmed',
    AppointmentStatus.completed => 'Completed',
    AppointmentStatus.overdue => 'Overdue',
    AppointmentStatus.cancelled => 'Cancelled',
  };
}

/// Display label for the service type
extension ApplicationTypeLabel on ApplicationType {
  /// Display label
  String get serviceLabel => switch (this) {
    ApplicationType.newRegistration => 'New Registration',
    ApplicationType.renewal => 'Renewal',
    ApplicationType.replacement => 'Replacement',
    ApplicationType.changeOfParticulars => 'Change of Particulars',
  };
}
