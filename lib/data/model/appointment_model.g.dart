// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: json['id'] as String,
      applicationId: json['application_id'] as String,
      applicantUid: json['applicant_uid'] as String,
      serviceCentreId: json['service_centre_id'] as String,
      dateTime: DateTime.parse(json['date_time'] as String),
      queueToken: json['queue_token'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_id': instance.applicationId,
      'applicant_uid': instance.applicantUid,
      'service_centre_id': instance.serviceCentreId,
      'date_time': instance.dateTime.toIso8601String(),
      'queue_token': instance.queueToken,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
    };
