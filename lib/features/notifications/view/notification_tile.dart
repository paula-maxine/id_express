import '../../../app_exporter.dart';

/// A single notification tile
class NotificationTile extends StatelessWidget {
  /// Creates a notification tile
  const NotificationTile({
    required this.notification,
    required this.onTap,
    super.key,
  });

  /// The notification to display
  final NotificationModel notification;

  /// Callback when tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;

    return Material(
      color: isRead ? surfaceWhite : facebookBlue.withValues(alpha: 0.04),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding16,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: borderLight)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(spacing10),
                decoration: BoxDecoration(
                  color: _iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _iconColor, size: iconSizeMedium),
              ),
              const SizedBox(width: spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: isRead
                                      ? FontWeight.normal
                                      : FontWeight.w600,
                                ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: facebookBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: spacing4),
                    Text(
                      notification.message,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (notification.createdAt != null) ...[
                      const SizedBox(height: spacing4),
                      Text(
                        _timeAgo(notification.createdAt!),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: lightGrey),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.applicationStatus:
        return Icons.description_rounded;
      case NotificationType.appointmentReminder:
        return Icons.alarm_rounded;
      case NotificationType.biometricAppointment:
        return Icons.fingerprint_rounded;
      case NotificationType.idReady:
        return Icons.credit_card_rounded;
      case NotificationType.announcement:
        return Icons.campaign_rounded;
      case NotificationType.system:
        return Icons.notifications_rounded;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.applicationStatus:
        return facebookBlue;
      case NotificationType.appointmentReminder:
      case NotificationType.biometricAppointment:
        return warningOrange;
      case NotificationType.idReady:
        return successGreen;
      case NotificationType.announcement:
        return facebookBlue;
      case NotificationType.system:
        return mediumGrey;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
