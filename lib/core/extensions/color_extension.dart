import 'package:flutter/material.dart';

/// Extension on Color
extension ColorX on Color {
  /// Returns color with opacity
  Color withOpacityValue(double opacity) => withValues(alpha: opacity);

  /// Returns hex code of color
  String get asHexCode =>
      '#${toARGB32().toRadixString(16).substring(2).toUpperCase()}';
}
