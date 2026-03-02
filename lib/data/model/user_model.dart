import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum UserRole {
  applicant,
  officer,
  supervisor,
  admin,
}

@JsonSerializable()
class UserModel {
  final String uid;
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String role;
  final String? phone;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;
  @JsonKey(name: 'consent_given')
  final bool consentGiven;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    this.phone,
    required this.createdAt,
    this.isActive = true,
    this.lastLogin,
    this.fcmToken,
    this.consentGiven = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? role,
    String? phone,
    DateTime? createdAt,
    bool? isActive,
    DateTime? lastLogin,
    String? fcmToken,
    bool? consentGiven,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      fcmToken: fcmToken ?? this.fcmToken,
      consentGiven: consentGiven ?? this.consentGiven,
    );
  }
}
