import '../../../app_exporter.dart';

/// Stats summary card for the officer dashboard
class OfficerStatsCard extends ConsumerWidget {
  /// Creates the officer stats card
  const OfficerStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingApplicationsProvider);
    final officerAsync = ref.watch(officerApplicationsProvider);

    final pendingCount = pendingAsync.when(
      data: (l) => l.length,
      loading: () => null,
      error: (_, _) => 0,
    );
    final reviewedCount = officerAsync.when(
      data: (l) =>
          l.where((a) => a.status == ApplicationStatus.approved).length,
      loading: () => null,
      error: (_, _) => 0,
    );
    final rejectedCount = officerAsync.when(
      data: (l) =>
          l.where((a) => a.status == ApplicationStatus.rejected).length,
      loading: () => null,
      error: (_, _) => 0,
    );

    return Container(
      padding: padding16,
      decoration: BoxDecoration(
        color: facebookBlue,
        borderRadius: borderRadius12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: 'Pending',
                  value: pendingCount,
                  icon: Icons.pending_actions_rounded,
                  color: whiteColor,
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: whiteColor.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _Stat(
                  label: 'Approved',
                  value: reviewedCount,
                  icon: Icons.check_circle_outline,
                  color: whiteColor,
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: whiteColor.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _Stat(
                  label: 'Rejected',
                  value: rejectedCount,
                  icon: Icons.cancel_outlined,
                  color: whiteColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final int? value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: iconSizeMedium),
        const SizedBox(height: spacing8),
        value != null
            ? Text(
                '$value',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              )
            : const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: whiteColor,
                ),
              ),
        const SizedBox(height: spacing4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: color.withValues(alpha: 0.8)),
        ),
      ],
    );
  }
}
