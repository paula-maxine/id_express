import '../../../app_exporter.dart';

/// A single application tile for the officer dashboard
class OfficerApplicationTile extends StatelessWidget {
  /// Creates an officer application tile
  const OfficerApplicationTile({required this.application, super.key});

  /// The application to display
  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    final isNew = application.status == ApplicationStatus.submitted;

    return Material(
      color: surfaceWhite,
      borderRadius: borderRadius8,
      child: InkWell(
        onTap: () =>
            context.push('/officer/review/${application.applicationId}'),
        borderRadius: borderRadius8,
        child: Container(
          padding: padding16,
          decoration: BoxDecoration(
            border: Border.all(color: borderLight),
            borderRadius: borderRadius8,
          ),
          child: Row(
            children: [
              if (isNew)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: spacing8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: facebookBlue,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${application.firstName} ${application.lastName}',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        _StatusChip(status: application.status),
                      ],
                    ),
                    const SizedBox(height: spacing4),
                    Row(
                      children: [
                        Text(
                          _typeLabel(application.applicationType),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                        ),
                        const Spacer(),
                        if (application.createdAt != null)
                          Text(
                            _timeAgo(application.createdAt!),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: spacing8),
              const Icon(Icons.chevron_right_rounded, color: mediumGrey),
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

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      ApplicationStatus.submitted => (facebookBlue, 'New'),
      ApplicationStatus.approved => (successGreen, 'Approved'),
      _ => (warningOrange, 'In Review'),
    };

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
}
