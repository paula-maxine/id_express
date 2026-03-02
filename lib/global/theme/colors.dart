import 'package:flutter/material.dart';

class AppColors {
  // NIRA brand colors
  static const Color primaryBlue = Color(0xFF0D47A1); // Deep blue
  static const Color accentAmber = Color(0xFFFFC107); // Amber (Uganda flag)
  
  // Semantic colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFF44336);
  static const Color dangerRed = Color(0xFFD32F2F);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
  
  // Light theme backgrounds
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFF5F5F5);
  
  // Dark theme backgrounds
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
}

class AppStatusColors {
  static const Map<String, Color> statusColors = {
    'submitted': Color(0xFF2196F3), // Blue
    'underReview': Color(0xFFFFC107), // Amber
    'approved': Color(0xFF4CAF50), // Green
    'biometricPending': Color(0xFFFF9800), // Orange
    'cardReady': Color(0xFF2196F3), // Blue
    'rejected': Color(0xFFD32F2F), // Red
  };

  static Color getStatusColor(String status) {
    return statusColors[status] ?? AppColors.textSecondary;
  }
}
