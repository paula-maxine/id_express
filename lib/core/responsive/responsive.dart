import 'package:flutter/material.dart';

/// Responsive utility class
class AppResponsive {
  /// Check if device is mobile (width < 600)
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  /// Check if device is tablet (600 <= width < 1024)
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600 &&
      MediaQuery.sizeOf(context).width < 1024;

  /// Check if device is desktop (width >= 1024)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  /// Get screen width
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  /// Get screen height
  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;
}
