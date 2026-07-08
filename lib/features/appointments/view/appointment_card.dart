import '../../../app_exporter.dart';

/// Card for a single appointment
class AppointmentCard extends StatelessWidget {
  /// Creates an appointment card
  const AppointmentCard({
    required this.appointment,
    required this.onCancel,
    this.onReschedule,
    super.key,
  });

  /// The appointment to display
  final AppointmentModel appointment;

  /// Callback for cancel action
  final VoidCallback onCancel;

  /// Callback to schedule a new appointment (shown when overdue)
  final VoidCallback? onReschedule;

  @override
  Widget build(BuildContext context) {
    final status = appointment.effectiveStatus;
    final isUpcoming = appointment.isUpcoming;
    final isToday = appointment.isToday && isUpcoming;
    final color = switch (status) {
      AppointmentStatus.cancelled => mediumGrey,
      AppointmentStatus.overdue => errorRed,
      AppointmentStatus.completed => successGreen,
      AppointmentStatus.confirmed => isToday ? warningOrange : facebookBlue,
    };

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
          _InfoChip(
            icon: Icons.assignment_outlined,
            label: appointment.serviceType.serviceLabel,
          ),
          const SizedBox(height: spacing8),
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
          if (isUpcoming) ...[
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
          if (status == AppointmentStatus.overdue && onReschedule != null) ...[
            const SizedBox(height: spacing12),
            Text(
              'This appointment has passed. Schedule a new one to continue.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: errorRed),
            ),
            const SizedBox(height: spacing8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onReschedule,
                icon: const Icon(Icons.event_repeat_rounded),
                label: const Text('Schedule New Appointment'),
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
    final status = appointment.effectiveStatus;
    final String label;
    final Color color;

    switch (status) {
      case AppointmentStatus.cancelled:
        label = 'Cancelled';
        color = mediumGrey;
      case AppointmentStatus.completed:
        label = 'Completed';
        color = successGreen;
      case AppointmentStatus.overdue:
        label = 'Overdue';
        color = errorRed;
      case AppointmentStatus.confirmed:
        if (appointment.isToday) {
          label = 'Today';
          color = warningOrange;
        } else {
          label = 'Confirmed';
          color = facebookBlue;
        }
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
