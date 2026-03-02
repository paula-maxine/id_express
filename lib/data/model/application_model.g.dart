// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    ApplicationModel(
      id: json['id'] as String,
      applicantUid: json['applicant_uid'] as String,
      trackingRef: json['tracking_ref'] as String,
      fullName: json['full_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String,
      nationality: json['nationality'] as String,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      parentGuardianName: json['parent_guardian_name'] as String?,
      parentGuardianId: json['parent_guardian_id'] as String?,
      status: json['status'] as String,
      officerUid: json['officer_uid'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      documentIds:
          (json['document_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ApplicationModelToJson(ApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'applicant_uid': instance.applicantUid,
      'tracking_ref': instance.trackingRef,
      'full_name': instance.fullName,
      'date_of_birth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'nationality': instance.nationality,
      'address': instance.address,
      'parent_guardian_name': instance.parentGuardianName,
      'parent_guardian_id': instance.parentGuardianId,
      'status': instance.status,
      'officer_uid': instance.officerUid,
      'rejection_reason': instance.rejectionReason,
      'document_ids': instance.documentIds,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
