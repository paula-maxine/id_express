import 'package:json_annotation/json_annotation.dart';

import 'address_model.dart';

part 'application_model.g.dart';

@JsonSerializable()
class ApplicationModel {
  final String id;
  @JsonKey(name: 'applicant_uid')
  final String applicantUid;
  @JsonKey(name: 'tracking_ref')
  final String trackingRef;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'date_of_birth')
  final DateTime dateOfBirth;
  final String gender;
  final String nationality;
  final AddressModel address;
  @JsonKey(name: 'parent_guardian_name')
  final String? parentGuardianName;
  @JsonKey(name: 'parent_guardian_id')
  final String? parentGuardianId;
  final String status;
  @JsonKey(name: 'officer_uid')
  final String? officerUid;
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @JsonKey(name: 'document_ids')
  final List<String> documentIds;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ApplicationModel({
    required this.id,
    required this.applicantUid,
    required this.trackingRef,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.address,
    this.parentGuardianName,
    this.parentGuardianId,
    required this.status,
    this.officerUid,
    this.rejectionReason,
    this.documentIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationModelToJson(this);

  ApplicationModel copyWith({
    String? id,
    String? applicantUid,
    String? trackingRef,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? nationality,
    AddressModel? address,
    String? parentGuardianName,
    String? parentGuardianId,
    String? status,
    String? officerUid,
    String? rejectionReason,
    List<String>? documentIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      applicantUid: applicantUid ?? this.applicantUid,
      trackingRef: trackingRef ?? this.trackingRef,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      address: address ?? this.address,
      parentGuardianName: parentGuardianName ?? this.parentGuardianName,
      parentGuardianId: parentGuardianId ?? this.parentGuardianId,
      status: status ?? this.status,
      officerUid: officerUid ?? this.officerUid,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      documentIds: documentIds ?? this.documentIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
