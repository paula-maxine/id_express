import '../../../app_exporter.dart';

/// Card showing quick stats: pending applications and upcoming appointments
class QuickStatsCard extends ConsumerWidget {
  /// Creates a quick stats card
  const QuickStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingApplicationsCountProvider);
    final appointmentsCount = ref.watch(upcomingAppointmentsCountProvider);

    return Container(
      padding: padding16,
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: borderRadius12,
        border: Border.all(color: borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.description_outlined,
              label: 'In Progress',
              valueAsync: pendingCount,
              color: warningOrange,
              onTap: () => context.push(applicationsListPath),
            ),
          ),
          Container(width: 1, height: 44, color: borderLight),
          Expanded(
            child: _StatItem(
              icon: Icons.event_outlined,
              label: 'Appointments',
              valueAsync: appointmentsCount,
              color: facebookBlue,
              onTap: () => context.push(appointmentsPath),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.valueAsync,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final AsyncValue<int> valueAsync;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: spacing8),
        child: Column(
          children: [
            Icon(icon, color: color, size: iconSizeMedium),
            const SizedBox(height: spacing8),
            valueAsync.when(
              data: (n) => Text(
                '$n',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              loading: () => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, _) =>
                  Text('-', style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: spacing4),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: mediumGrey),
            ),
          ],
        ),
      ),
    );
  }
}
