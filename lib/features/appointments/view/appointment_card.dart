import '../../../app_exporter.dart';

/// Card for a single appointment
class AppointmentCard extends StatelessWidget {
  /// Creates an appointment card
  const AppointmentCard({
    required this.appointment,
    required this.onCancel,
    super.key,
  });

  /// The appointment to display
  final AppointmentModel appointment;

  /// Callback for cancel action
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = appointment.isUpcoming;
    final isToday = appointment.isToday;
    final color = appointment.isCancelled
        ? mediumGrey
        : isToday
        ? warningOrange
        : isUpcoming
        ? facebookBlue
        : successGreen;

    return Container(
      padding: padding16,
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: borderRadius8,
        border: Border.all(color: borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(spacing8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: borderRadius8,
                ),
                child: Icon(
                  Icons.event_rounded,
                  color: color,
                  size: iconSizeMedium,
                ),
              ),
              const SizedBox(width: spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.centerName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: spacing2),
                    Text(
                      appointment.centerAddress,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _StatusBadge(appointment: appointment),
            ],
          ),
          const SizedBox(height: spacing12),
          const Divider(height: 1),
          const SizedBox(height: spacing12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.calendar_today_outlined,
                label: _formatDate(appointment.appointmentDate),
              ),
              const SizedBox(width: spacing12),
              _InfoChip(
                icon: Icons.access_time_rounded,
                label: appointment.timeSlot,
              ),
            ],
          ),
          if (appointment.queueNumber.isNotEmpty) ...[
            const SizedBox(height: spacing8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: spacing12,
                vertical: spacing8,
              ),
              decoration: BoxDecoration(
                color: facebookBlue.withValues(alpha: 0.07),
                borderRadius: borderRadius8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 16,
                    color: facebookBlue,
                  ),
                  const SizedBox(width: spacing8),
                  Text(
                    'Queue: ${appointment.queueNumber}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: facebookBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isUpcoming && !appointment.isCancelled) ...[
            const SizedBox(height: spacing12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: errorRed,
                  side: const BorderSide(color: errorRed),
                ),
                child: const Text('Cancel Appointment'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;

    if (appointment.isCancelled) {
      label = 'Cancelled';
      color = mediumGrey;
    } else if (appointment.isCompleted) {
      label = 'Completed';
      color = successGreen;
    } else if (appointment.isToday) {
      label = 'Today';
      color = warningOrange;
    } else if (appointment.isUpcoming) {
      label = 'Confirmed';
      color = facebookBlue;
    } else {
      label = 'Past';
      color = mediumGrey;
    }

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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: mediumGrey),
        const SizedBox(width: spacing4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: mediumGrey),
        ),
      ],
    );
  }
}
