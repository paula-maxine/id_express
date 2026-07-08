import '../../../app_exporter.dart';

/// Staff-facing screen to manage all appointments.
///
/// Officers, supervisors and admins can view every appointment, mark one as
/// done, and the screen sweeps confirmed-but-passed appointments to overdue
/// when it is opened.
class ManageAppointmentsScreen extends ConsumerStatefulWidget {
  /// Creates the manage appointments screen
  const ManageAppointmentsScreen({super.key});

  @override
  ConsumerState<ManageAppointmentsScreen> createState() =>
      _ManageAppointmentsScreenState();
}

class _ManageAppointmentsScreenState
    extends ConsumerState<ManageAppointmentsScreen> {
  bool _sweptOnce = false;
  AppointmentStatus? _filter;

  static const _filters = [
    (label: 'All', value: null),
    (label: 'Confirmed', value: AppointmentStatus.confirmed),
    (label: 'Overdue', value: AppointmentStatus.overdue),
    (label: 'Completed', value: AppointmentStatus.completed),
    (label: 'Cancelled', value: AppointmentStatus.cancelled),
  ];

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(allAppointmentsProvider);

    appointmentsAsync.whenData((appointments) {
      if (!_sweptOnce) {
        _sweptOnce = true;
        ref.read(appointmentServiceProvider).sweepOverdue(appointments);
      }
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Manage Appointments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: horizontalPadding16,
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: spacing8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                return Center(
                  child: FilterChip(
                    label: Text(f.label),
                    selected: _filter == f.value,
                    onSelected: (_) => setState(() => _filter = f.value),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: appointmentsAsync.when(
              data: (appointments) {
                final filtered = _filter == null
                    ? appointments
                    : appointments
                          .where((a) => a.effectiveStatus == _filter)
                          .toList();

                if (filtered.isEmpty) {
                  return const EmptyState(
                    message: 'No appointments found.',
                    icon: Icons.event_note_outlined,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(allAppointmentsProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(spacing16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: spacing12),
                    itemBuilder: (_, i) => _AdminAppointmentTile(
                      appointment: filtered[i],
                      onMarkDone: () => _markDone(filtered[i].appointmentId),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markDone(String appointmentId) async {
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(appointmentServiceProvider).markAsDone(appointmentId);
    messenger.showSnackBar(
      const SnackBar(content: Text('Appointment marked as done.')),
    );
  }
}

class _AdminAppointmentTile extends StatelessWidget {
  const _AdminAppointmentTile({
    required this.appointment,
    required this.onMarkDone,
  });

  final AppointmentModel appointment;
  final VoidCallback onMarkDone;

  @override
  Widget build(BuildContext context) {
    final status = appointment.effectiveStatus;
    final color = switch (status) {
      AppointmentStatus.cancelled => mediumGrey,
      AppointmentStatus.overdue => errorRed,
      AppointmentStatus.completed => successGreen,
      AppointmentStatus.confirmed => facebookBlue,
    };

    // Staff may mark confirmed or overdue appointments as done.
    final canMarkDone =
        status == AppointmentStatus.confirmed ||
        status == AppointmentStatus.overdue;

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
              Expanded(
                child: Text(
                  appointment.centerName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing8,
                  vertical: spacing4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: borderRadius4,
                ),
                child: Text(
                  status.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: spacing8),
          _row('Service', appointment.serviceType.serviceLabel),
          _row('Application', appointment.applicationId.toUpperCase()),
          _row(
            'Date',
            '${appointment.appointmentDate.day}/'
                '${appointment.appointmentDate.month}/'
                '${appointment.appointmentDate.year}',
          ),
          _row('Time', appointment.timeSlot),
          if (appointment.queueNumber.isNotEmpty)
            _row('Queue', appointment.queueNumber),
          if (canMarkDone) ...[
            const SizedBox(height: spacing12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onMarkDone,
                icon: const Icon(Icons.done_all_rounded, size: 18),
                label: const Text('Mark as Done'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: spacing4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Builder(
              builder: (context) => Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: mediumGrey),
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) => Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
