import '../../../app_exporter.dart';

/// Screen listing all appointments for the current user
class AppointmentsScreen extends ConsumerWidget {
  /// Creates the appointments screen
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('My Appointments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: appointmentsAsync.when(
        data: (appointments) {
          if (appointments.isEmpty) {
            return const EmptyState(
              message: 'No appointments yet.\nBook one from your application.',
              icon: Icons.event_busy_rounded,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(spacing16),
            itemCount: appointments.length,
            separatorBuilder: (_, _) => const SizedBox(height: spacing12),
            itemBuilder: (_, i) => AppointmentCard(
              appointment: appointments[i],
              onCancel: () =>
                  _confirmCancel(context, ref, appointments[i].appointmentId),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    String appointmentId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: errorRed),
            child: const Text('Cancel Appointment'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(appointmentServiceProvider)
          .cancelAppointment(appointmentId);
    }
  }
}
