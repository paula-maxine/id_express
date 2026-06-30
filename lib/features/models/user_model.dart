import 'enums.dart';

/// User model
class UserModel {
  /// Creates a user model
  const UserModel({
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.displayName = '',
    this.photoUrl = '',
    this.nin = '',
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  /// User ID
  final String userId;

  /// Email address
  final String email;

  /// Phone number
  final String phoneNumber;

  /// User role
  final UserRole role;

  /// Display name
  final String displayName;

  /// Profile photo URL
  final String photoUrl;

  /// National Identification Number
  final String nin;

  /// Whether email is verified
  final bool isEmailVerified;

  /// Whether phone is verified
  final bool isPhoneVerified;

  /// Created at timestamp
  final DateTime? createdAt;

  /// Updated at timestamp
  final DateTime? updatedAt;

  /// Factory from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      role: _roleFromString(map['role'] as String? ?? 'applicant'),
      displayName: map['display_name'] as String? ?? '',
      photoUrl: map['photo_url'] as String? ?? '',
      nin: map['nin'] as String? ?? '',
      isEmailVerified: map['is_email_verified'] as bool? ?? false,
      isPhoneVerified: map['is_phone_verified'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'phone_number': phoneNumber,
      'role': role.name,
      'display_name': displayName,
      'photo_url': photoUrl,
      'nin': nin,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Convenience getter for Firestore withConverter
  Map<String, dynamic> get asMap => toMap();

  /// Immutable copy
  UserModel copyWith({
    String? userId,
    String? email,
    String? phoneNumber,
    UserRole? role,
    String? displayName,
    String? photoUrl,
    String? nin,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      nin: nin ?? this.nin,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty instance
  static UserModel get empty => UserModel(
    userId: '',
    email: '',
    phoneNumber: '',
    role: UserRole.applicant,
  );

  /// Check if user is applicant
  bool get isApplicant => role == UserRole.applicant;

  /// Check if user is officer
  bool get isOfficer =>
      role == UserRole.officer ||
      role == UserRole.supervisor ||
      role == UserRole.admin;

  /// Convert role string to enum
  static UserRole _roleFromString(String value) {
    switch (value.toLowerCase()) {
      case 'officer':
        return UserRole.officer;
      case 'supervisor':
        return UserRole.supervisor;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.applicant;
    }
  }
}
