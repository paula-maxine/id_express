import '../../../app_exporter.dart';

/// A single application list item tile
class ApplicationListItem extends StatelessWidget {
  /// Creates an application list item
  const ApplicationListItem({required this.application, super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _typeLabel(application.applicationType),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusChip(status: application.status),
                ],
              ),
              const SizedBox(height: spacing8),
              Row(
                children: [
                  Icon(Icons.tag_rounded, size: 14, color: mediumGrey),
                  const SizedBox(width: spacing4),
                  Text(
                    'Ref: ${application.applicationId.substring(0, 8).toUpperCase()}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: mediumGrey,
                  ),
                  const SizedBox(width: spacing4),
                  Text(
                    _formatDate(application.createdAt ?? DateTime.now()),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                  ),
                ],
              ),
              if (application.status == ApplicationStatus.rejected &&
                  application.rejectionReason.isNotEmpty) ...[
                const SizedBox(height: spacing8),
                Container(
                  padding: const EdgeInsets.all(spacing8),
                  decoration: BoxDecoration(
                    color: errorRed.withValues(alpha: 0.07),
                    borderRadius: borderRadius4,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 14, color: errorRed),
                      const SizedBox(width: spacing4),
                      Expanded(
                        child: Text(
                          application.rejectionReason,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: errorRed),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: spacing8),
              LinearProgressIndicator(
                value: _progressValue(application.status),
                backgroundColor: lightGrey,
                color: statusColor,
                minHeight: 3,
                borderRadius: borderRadius4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(ApplicationType type) {
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

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

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

  double _progressValue(ApplicationStatus status) {
    final orderedStatuses = [
      ApplicationStatus.submitted,
      ApplicationStatus.underReview,
      ApplicationStatus.approved,
      ApplicationStatus.biometricCaptured,
      ApplicationStatus.idReady,
      ApplicationStatus.completed,
    ];
    final index = orderedStatuses.indexOf(status);
    if (index < 0) return 0;
    return (index + 1) / orderedStatuses.length;
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final label = _label();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: spacing8,
        vertical: spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: borderRadius4,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _color() {
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

  String _label() {
    switch (status) {
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.underReview:
        return 'In Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.biometricCaptured:
        return 'Biometrics';
      case ApplicationStatus.idReady:
        return 'ID Ready';
      case ApplicationStatus.completed:
        return 'Completed';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.cancelled:
        return 'Cancelled';
    }
  }
}
