import 'package:flutter/material.dart';

/// Widget that provides consistent spacing
class Spacing extends StatelessWidget {
  /// Creates a spacing widget
  const Spacing({required this.of, super.key});

  /// Spacing value
  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: of, width: of);
  }
}

/// Horizontal spacing widget
class HorizontalSpacing extends StatelessWidget {
  /// Creates a horizontal spacing widget
  const HorizontalSpacing({required this.of, super.key});

  /// Spacing value
  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: of);
  }
}

/// Vertical spacing widget
class VerticalSpacing extends StatelessWidget {
  /// Creates a vertical spacing widget
  const VerticalSpacing({required this.of, super.key});

  /// Spacing value
  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: of);
  }
}
