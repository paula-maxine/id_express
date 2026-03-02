import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

@JsonSerializable()
class AppointmentModel {
  final String id;
  @JsonKey(name: 'application_id')
  final String applicationId;
  @JsonKey(name: 'applicant_uid')
  final String applicantUid;
  @JsonKey(name: 'service_centre_id')
  final String serviceCentreId;
  @JsonKey(name: 'date_time')
  final DateTime dateTime;
  @JsonKey(name: 'queue_token')
  final String queueToken;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  AppointmentModel({
    required this.id,
    required this.applicationId,
    required this.applicantUid,
    required this.serviceCentreId,
    required this.dateTime,
    required this.queueToken,
    required this.status,
    required this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);

  AppointmentModel copyWith({
    String? id,
    String? applicationId,
    String? applicantUid,
    String? serviceCentreId,
    DateTime? dateTime,
    String? queueToken,
    String? status,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      applicantUid: applicantUid ?? this.applicantUid,
      serviceCentreId: serviceCentreId ?? this.serviceCentreId,
      dateTime: dateTime ?? this.dateTime,
      queueToken: queueToken ?? this.queueToken,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
