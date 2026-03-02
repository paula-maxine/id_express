import 'package:flutter/material.dart';
import '../theme/colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final String? displayText;

  const StatusBadge({super.key, required this.status, this.displayText});

  @override
  Widget build(BuildContext context) {
    final color = AppStatusColors.getStatusColor(status);
    final text = displayText ?? _getStatusDisplayName(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  String _getStatusDisplayName(String status) {
    return switch (status) {
      'submitted' => 'Submitted',
      'underReview' => 'Under Review',
      'approved' => 'Approved',
      'biometricPending' => 'Biometric Pending',
      'cardReady' => 'Card Ready',
      'rejected' => 'Rejected',
      _ => status,
    };
  }
}
