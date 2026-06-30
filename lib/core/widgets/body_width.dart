import 'package:flutter/material.dart';

/// Widget that constrains its child to a maximum width
class BodyWidth extends StatelessWidget {
  /// Creates a body width widget
  const BodyWidth({required this.child, this.maxWidth = 600, super.key});

  /// The child widget
  final Widget child;

  /// Maximum width
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
