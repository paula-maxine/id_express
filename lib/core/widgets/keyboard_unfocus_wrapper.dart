import 'package:flutter/material.dart';

/// Widget that dismisses keyboard when tapped outside
class KeyboardUnfocusWrapper extends StatelessWidget {
  /// Creates a keyboard unfocus wrapper
  const KeyboardUnfocusWrapper({required this.child, super.key});

  /// The child widget
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
