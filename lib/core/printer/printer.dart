import 'dart:developer' as developer;

/// Custom logger utility
class Printer {
  /// Print info message
  static void info(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'INFO', time: DateTime.now());
  }

  /// Print error message
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'ERROR',
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }

  /// Print warning message
  static void warning(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'WARNING', time: DateTime.now());
  }

  /// Print debug message
  static void debug(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'DEBUG', time: DateTime.now());
  }
}
