enum UserRole {
  applicant,
  officer,
  supervisor,
  admin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    return switch (this) {
      UserRole.applicant => 'Applicant',
      UserRole.officer => 'Officer',
      UserRole.supervisor => 'Supervisor',
      UserRole.admin => 'Administrator',
    };
  }

  static UserRole? fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'applicant' => UserRole.applicant,
      'officer' => UserRole.officer,
      'supervisor' => UserRole.supervisor,
      'admin' => UserRole.admin,
      _ => null,
    };
  }

  String toJson() => name.toLowerCase();
}
