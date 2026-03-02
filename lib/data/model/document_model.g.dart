// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      id: json['id'] as String,
      applicationId: json['application_id'] as String,
      type: json['type'] as String,
      fileName: json['file_name'] as String,
      imageUrl: json['image_url'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      isVerified: json['is_verified'] as bool? ?? false,
      verifiedByUid: json['verified_by_uid'] as String?,
      verifiedAt: json['verified_at'] == null
          ? null
          : DateTime.parse(json['verified_at'] as String),
      flagReason: json['flag_reason'] as String?,
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_id': instance.applicationId,
      'type': instance.type,
      'file_name': instance.fileName,
      'image_url': instance.imageUrl,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
      'is_verified': instance.isVerified,
      'verified_by_uid': instance.verifiedByUid,
      'verified_at': instance.verifiedAt?.toIso8601String(),
      'flag_reason': instance.flagReason,
    };
