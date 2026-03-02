// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  uid: json['uid'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  role: json['role'] as String,
  phone: json['phone'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  isActive: json['is_active'] as bool? ?? true,
  lastLogin: json['last_login'] == null
      ? null
      : DateTime.parse(json['last_login'] as String),
  fcmToken: json['fcm_token'] as String?,
  consentGiven: json['consent_given'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'full_name': instance.fullName,
  'role': instance.role,
  'phone': instance.phone,
  'created_at': instance.createdAt.toIso8601String(),
  'is_active': instance.isActive,
  'last_login': instance.lastLogin?.toIso8601String(),
  'fcm_token': instance.fcmToken,
  'consent_given': instance.consentGiven,
};
