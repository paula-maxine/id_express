import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../constants/spacing.dart';

/// Widget that displays an empty state
class EmptyState extends StatelessWidget {
  /// Creates an empty state widget
  const EmptyState({
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
    super.key,
  });

  /// Message to display
  final String message;

  /// Icon to display
  final IconData icon;

  /// Action button text
  final String? actionText;

  /// Action callback
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: mediumGrey),
            const SizedBox(height: spacing16),
            Text(
              message,
              style: bodyMedium.copyWith(color: mediumGrey),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: spacing24),
              ElevatedButton(onPressed: onAction, child: Text(actionText!)),
            ],
          ],
        ),
      ),
    );
  }
}
