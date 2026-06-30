import '../../../app_exporter.dart';

/// Compact card showing a single recent application
class RecentApplicationCard extends StatelessWidget {
  /// Creates a recent application card
  const RecentApplicationCard({required this.application, super.key});

  /// The application to display
  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(application.status);

    return Material(
      color: surfaceWhite,
      borderRadius: borderRadius8,
      child: InkWell(
        onTap: () => context.push('/application/${application.applicationId}'),
        borderRadius: borderRadius8,
        child: Container(
          padding: padding16,
          decoration: BoxDecoration(
            border: Border.all(color: borderLight),
            borderRadius: borderRadius8,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(spacing10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: borderRadius8,
                ),
                child: Icon(
                  _statusIcon(application.status),
                  color: statusColor,
                  size: iconSizeMedium,
                ),
              ),
              const SizedBox(width: spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _applicationTypeLabel(application.applicationType),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: spacing4),
                    Text(
                      'Ref: ${application.applicationId.substring(0, 8).toUpperCase()}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: spacing8),
              ApplicationStatusBadge(status: application.status),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.draft:
        return mediumGrey;
      case ApplicationStatus.submitted:
      case ApplicationStatus.underReview:
        return warningOrange;
      case ApplicationStatus.approved:
      case ApplicationStatus.biometricCaptured:
        return facebookBlue;
      case ApplicationStatus.idReady:
      case ApplicationStatus.completed:
        return successGreen;
      case ApplicationStatus.rejected:
        return errorRed;
      case ApplicationStatus.cancelled:
        return mediumGrey;
    }
  }

  IconData _statusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.draft:
        return Icons.edit_outlined;
      case ApplicationStatus.submitted:
        return Icons.schedule_outlined;
      case ApplicationStatus.underReview:
        return Icons.manage_search_outlined;
      case ApplicationStatus.approved:
        return Icons.check_circle_outline;
      case ApplicationStatus.biometricCaptured:
        return Icons.fingerprint_outlined;
      case ApplicationStatus.idReady:
        return Icons.credit_card_outlined;
      case ApplicationStatus.completed:
        return Icons.done_all_outlined;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
      case ApplicationStatus.cancelled:
        return Icons.block_outlined;
    }
  }

  String _applicationTypeLabel(ApplicationType type) {
    switch (type) {
      case ApplicationType.newRegistration:
        return 'New Registration';
      case ApplicationType.renewal:
        return 'Renewal';
      case ApplicationType.replacement:
        return 'Replacement';
      case ApplicationType.changeOfParticulars:
        return 'Change of Particulars';
    }
  }
}
