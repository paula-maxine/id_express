/// Audit log model for officer actions
class AuditLogModel {
  /// Creates an audit log model
  const AuditLogModel({
    required this.logId,
    required this.officerId,
    required this.officerName,
    required this.action,
    required this.timestamp,
    this.applicationId = '',
    this.details = '',
    this.ipAddress = '',
  });

  /// Log ID
  final String logId;

  /// Officer user ID
  final String officerId;

  /// Officer name
  final String officerName;

  /// Action performed
  final String action;

  /// Associated application ID (if applicable)
  final String applicationId;

  /// Additional details
  final String details;

  /// IP address
  final String ipAddress;

  /// Timestamp
  final DateTime timestamp;

  /// Factory from Firestore document
  factory AuditLogModel.fromMap(Map<String, dynamic> map) {
    return AuditLogModel(
      logId: map['log_id'] as String? ?? '',
      officerId: map['officer_id'] as String? ?? '',
      officerName: map['officer_name'] as String? ?? '',
      action: map['action'] as String? ?? '',
      applicationId: map['application_id'] as String? ?? '',
      details: map['details'] as String? ?? '',
      ipAddress: map['ip_address'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'log_id': logId,
      'officer_id': officerId,
      'officer_name': officerName,
      'action': action,
      'application_id': applicationId,
      'details': details,
      'ip_address': ipAddress,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Convenience getter for Firestore withConverter
  Map<String, dynamic> get asMap => toMap();

  /// Empty instance
  static AuditLogModel get empty => AuditLogModel(
    logId: '',
    officerId: '',
    officerName: '',
    action: '',
    timestamp: DateTime.now(),
  );
}
