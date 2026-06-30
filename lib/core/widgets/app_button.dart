import 'package:flutter/material.dart';

/// Primary action button
class AppButton extends StatelessWidget {
  /// Creates an app button
  const AppButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isFullWidth = true,
    super.key,
  });

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button text
  final String text;

  /// Whether button is loading
  final bool isLoading;

  /// Whether button should take full width
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(text),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Secondary action button
class AppOutlinedButton extends StatelessWidget {
  /// Creates an outlined button
  const AppOutlinedButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isFullWidth = true,
    super.key,
  });

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button text
  final String text;

  /// Whether button is loading
  final bool isLoading;

  /// Whether button should take full width
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(text),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
