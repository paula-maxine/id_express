/// Validators for form inputs
class AppValidators {
  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[0-9+\-\s()]{9,20}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain a lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a digit';
    }
    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate national ID number (NIN)
  static String? validateNIN(String? value) {
    if (value == null || value.isEmpty) {
      return 'National ID is required';
    }
    if (value.length < 10) {
      return 'Please enter a valid National ID number';
    }
    return null;
  }

  /// Validate file size
  static String? validateFileSize(int bytes, int maxBytes) {
    if (bytes > maxBytes) {
      final maxMB = (maxBytes / (1024 * 1024)).toStringAsFixed(1);
      return 'File size must be less than ${maxMB}MB';
    }
    return null;
  }

  /// Validate date of birth
  static String? validateDateOfBirth(DateTime? value) {
    if (value == null) {
      return 'Date of birth is required';
    }
    final now = DateTime.now();
    final age = now.year - value.year;
    if (age < 16) {
      return 'You must be at least 16 years old';
    }
    if (age > 120) {
      return 'Please enter a valid date of birth';
    }
    return null;
  }
}
