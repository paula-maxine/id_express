import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Show snackbar
void showSnackbar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? errorRed : successGreen,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

/// Show error snackbar
void showError(BuildContext context, String message) {
  showSnackbar(context, message, isError: true);
}

/// Show success snackbar
void showSuccess(BuildContext context, String message) {
  showSnackbar(context, message);
}

/// Show loading dialog
void showLoadingDialog(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(48),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (message != null) ...[
                  const SizedBox(height: 24),
                  Text(message, style: bodyMedium),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Hide loading dialog
void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

/// Show confirmation dialog
Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, style: semiBoldTextStyle.copyWith(fontSize: 18)),
      content: Text(message, style: bodyMedium),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Validate email
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  if (!emailRegex.hasMatch(value)) {
    return 'Invalid email address';
  }
  return null;
}

/// Validate phone number (Uganda format)
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }
  final phoneRegex = RegExp(r'^(\+256|0)[7][0-9]{8}$');
  if (!phoneRegex.hasMatch(value)) {
    return 'Invalid phone number (use +256XXXXXXXXX or 07XXXXXXXX)';
  }
  return null;
}

/// Validate password
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

/// Validate required field
String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

/// Validate NIN (National Identification Number - 14 characters)
String? validateNIN(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'NIN is required';
  }
  if (value.length != 14) {
    return 'NIN must be exactly 14 characters';
  }
  return null;
}
