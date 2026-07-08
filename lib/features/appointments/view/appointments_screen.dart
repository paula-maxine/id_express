import '../../../app_exporter.dart';

/// Screen listing all appointments for the current user
class AppointmentsScreen extends ConsumerStatefulWidget {
  /// Creates the appointments screen
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  bool _sweptOnce = false;

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    // When the appointments page is visited, mark any confirmed-but-passed
    // appointments as overdue in the cloud. Runs once per screen visit.
    appointmentsAsync.whenData((appointments) {
      if (!_sweptOnce) {
        _sweptOnce = true;
        ref.read(appointmentServiceProvider).sweepOverdue(appointments);
      }
    });

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
            return const _EmptyAppointments();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(spacing16),
            itemCount: appointments.length,
            separatorBuilder: (_, _) => const SizedBox(height: spacing12),
            itemBuilder: (_, i) => AppointmentCard(
              appointment: appointments[i],
              onCancel: () =>
                  _confirmCancel(context, ref, appointments[i].appointmentId),
              onReschedule: () => _goToApplication(
                context,
                appointments[i].applicationId,
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _goToApplication(BuildContext context, String applicationId) {
    // Take the user to the application so they can schedule a new booking.
    context.push('/application/$applicationId');
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

/// Empty state directing the user to schedule from an approved application
class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 64,
              color: mediumGrey.withValues(alpha: 0.6),
            ),
            const SizedBox(height: spacing16),
            Text(
              'No appointments yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: spacing8),
            Text(
              'Open one of your approved applications and tap '
              '"Schedule Booking" to book an appointment.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: mediumGrey),
            ),
            const SizedBox(height: spacing24),
            FilledButton.icon(
              onPressed: () => context.push(applicationsListPath),
              icon: const Icon(Icons.folder_open_rounded),
              label: const Text('View My Applications'),
            ),
          ],
        ),
      ),
    );
  }
}
