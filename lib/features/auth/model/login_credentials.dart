/// Login credentials model
class LoginCredentials {
  /// Creates login credentials
  const LoginCredentials({required this.email, required this.password});

  /// Email address
  final String email;

  /// Password
  final String password;

  /// Empty instance
  static LoginCredentials get empty =>
      const LoginCredentials(email: '', password: '');
}

/// Register credentials model
class RegisterCredentials {
  /// Creates register credentials
  const RegisterCredentials({
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.displayName,
  });

  /// Email address
  final String email;

  /// Password
  final String password;

  /// Phone number
  final String phoneNumber;

  /// Display name
  final String displayName;

  /// Empty instance
  static RegisterCredentials get empty => const RegisterCredentials(
    email: '',
    password: '',
    phoneNumber: '',
    displayName: '',
  );
}
