import 'package:json_annotation/json_annotation.dart';

part 'audit_log_model.g.dart';

@JsonSerializable()
class AuditLogModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'user_role')
  final String userRole;
  final String action;
  @JsonKey(name: 'target_collection')
  final String? targetCollection;
  @JsonKey(name: 'target_doc_id')
  final String? targetDocId;
  final Map<String, dynamic>? details;
  final DateTime timestamp;

  AuditLogModel({
    required this.id,
    required this.userId,
    required this.userRole,
    required this.action,
    this.targetCollection,
    this.targetDocId,
    this.details,
    required this.timestamp,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AuditLogModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuditLogModelToJson(this);

  AuditLogModel copyWith({
    String? id,
    String? userId,
    String? userRole,
    String? action,
    String? targetCollection,
    String? targetDocId,
    Map<String, dynamic>? details,
    DateTime? timestamp,
  }) {
    return AuditLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      action: action ?? this.action,
      targetCollection: targetCollection ?? this.targetCollection,
      targetDocId: targetDocId ?? this.targetDocId,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
