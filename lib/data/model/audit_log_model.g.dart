// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLogModel _$AuditLogModelFromJson(Map<String, dynamic> json) =>
    AuditLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userRole: json['user_role'] as String,
      action: json['action'] as String,
      targetCollection: json['target_collection'] as String?,
      targetDocId: json['target_doc_id'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$AuditLogModelToJson(AuditLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user_role': instance.userRole,
      'action': instance.action,
      'target_collection': instance.targetCollection,
      'target_doc_id': instance.targetDocId,
      'details': instance.details,
      'timestamp': instance.timestamp.toIso8601String(),
    };
