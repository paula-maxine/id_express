
class AppDimens {
  // Icon sizes
  static const double iconXSmall = 16;
  static const double iconSmall = 20;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;

  // Avatar sizes
  static const double avatarSmall = 32;
  static const double avatarMedium = 48;
  static const double avatarLarge = 64;

  // Image dimensions
  static const double imageSmall = 80;
  static const double imageMedium = 120;
  static const double imageLarge = 160;
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class AppPadding {
  static const double screenHorizontal = 16;
  static const double screenVertical = 16;
  static const double cardPadding = 16;
  static const double buttonPadding = 12;
}

class AppBorderRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double pill = 100;
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

class AppStrings {
  static const String appName = 'ID Express';
  static const String appFullName = 'NIRA National ID Registration System';
  static const String appTagline = 'Fast. Secure. Reliable.';
  
  // Error messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorValidation = 'Please check your input and try again.';
  static const String errorAuth = 'Authentication failed. Please try again.';
}
