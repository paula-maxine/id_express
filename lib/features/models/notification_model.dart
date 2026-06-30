import 'enums.dart';

/// Notification model
class NotificationModel {
  /// Creates a notification model
  const NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.applicationId = '',
    this.appointmentId = '',
    this.isRead = false,
    this.createdAt,
  });

  /// Notification ID
  final String notificationId;

  /// User ID
  final String userId;

  /// Notification type
  final NotificationType type;

  /// Notification title
  final String title;

  /// Notification message
  final String message;

  /// Associated application ID (if applicable)
  final String applicationId;

  /// Associated appointment ID (if applicable)
  final String appointmentId;

  /// Whether notification is read
  final bool isRead;

  /// Created at timestamp
  final DateTime? createdAt;

  /// Factory from Firestore document
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notification_id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      type: _typeFromString(map['type'] as String? ?? 'system'),
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      applicationId: map['application_id'] as String? ?? '',
      appointmentId: map['appointment_id'] as String? ?? '',
      isRead: map['is_read'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'notification_id': notificationId,
      'user_id': userId,
      'type': type.name,
      'title': title,
      'message': message,
      'application_id': applicationId,
      'appointment_id': appointmentId,
      'is_read': isRead,
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  /// Convenience getter for Firestore withConverter
  Map<String, dynamic> get asMap => toMap();

  /// Immutable copy
  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    String? applicationId,
    String? appointmentId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      applicationId: applicationId ?? this.applicationId,
      appointmentId: appointmentId ?? this.appointmentId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Empty instance
  static NotificationModel get empty => NotificationModel(
    notificationId: '',
    userId: '',
    type: NotificationType.system,
    title: '',
    message: '',
  );

  /// Helper to convert enum from string
  static NotificationType _typeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'application_status':
        return NotificationType.applicationStatus;
      case 'appointment_reminder':
        return NotificationType.appointmentReminder;
      case 'biometric_appointment':
        return NotificationType.biometricAppointment;
      case 'id_ready':
        return NotificationType.idReady;
      case 'announcement':
        return NotificationType.announcement;
      default:
        return NotificationType.system;
    }
  }
}
