/// Extension on String
extension StringX on String {
  /// Convert to snake_case
  String get inSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String get inCamelCase {
    final parts = split('_');
    if (parts.isEmpty) return this;
    return parts.first +
        parts.skip(1).map((part) {
          if (part.isEmpty) return '';
          return part[0].toUpperCase() + part.substring(1).toLowerCase();
        }).join();
  }

  /// Convert to Title Case
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  /// Convert to Sentence case
  String get inSentenceCase {
    if (isEmpty) return this;
    // Handle camelCase/PascalCase by adding spaces
    final withSpaces = replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    return withSpaces[0].toUpperCase() + withSpaces.substring(1).toLowerCase();
  }

  /// Convert to lower case
  String get inLowerCase => toLowerCase();

  /// Convert to upper case
  String get inUpperCase => toUpperCase();

  /// Remove dashes
  String get withoutDashes => replaceAll('-', '');

  /// Remove spaces
  String get withoutSpaces => replaceAll(' ', '');

  /// Remove commas
  String get asNumber => replaceAll(',', '');

  /// Split into list of words
  List<String> get asList => split(' ');

  /// Capitalize first letter
  String get capitalized {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Check if string is empty or whitespace
  bool get isBlank => trim().isEmpty;

  /// Check if string is not empty
  bool get isNotBlank => !isBlank;

  /// Check if valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if valid phone (Uganda format: +256XXXXXXXXX or 07XXXXXXXX)
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^(\+256|0)[7][0-9]{8}$');
    return phoneRegex.hasMatch(this);
  }

  /// Format as phone number (add +256 if starts with 0)
  String get formatPhone {
    if (startsWith('0')) {
      return '+256${substring(1)}';
    }
    return this;
  }
}
