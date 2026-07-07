import '../../../app_exporter.dart';

/// Registration centers list
const _centers = [
  (
    id: 'nakasero',
    name: 'Nakasero Registration Centre',
    address: 'Plot 15, Nakasero Road, Kampala',
  ),
  (
    id: 'kireka',
    name: 'Kireka Registration Centre',
    address: 'Kireka Road, Kampala',
  ),
  (
    id: 'entebbe',
    name: 'Entebbe Registration Centre',
    address: 'Station Road, Entebbe',
  ),
  (
    id: 'jinja',
    name: 'Jinja Registration Centre',
    address: 'Main Street, Jinja',
  ),
  (
    id: 'mbarara',
    name: 'Mbarara Registration Centre',
    address: 'High Street, Mbarara',
  ),
  (id: 'gulu', name: 'Gulu Registration Centre', address: 'Gulu City Centre'),
];

const _timeSlots = [
  '8:00 AM - 9:00 AM',
  '9:00 AM - 10:00 AM',
  '10:00 AM - 11:00 AM',
  '11:00 AM - 12:00 PM',
  '1:00 PM - 2:00 PM',
  '2:00 PM - 3:00 PM',
  '3:00 PM - 4:00 PM',
];

/// Screen for booking a biometric capture appointment
class BookAppointmentScreen extends ConsumerWidget {
  /// Creates the book appointment screen
  const BookAppointmentScreen({required this.applicationId, super.key});

  /// The application this appointment is for
  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final center = ref.watch(selectedCenterProvider);
    final date = ref.watch(appointmentDateProvider);
    final slot = ref.watch(selectedTimeSlotProvider);
    final isLoading = ref.watch(bookingLoadingProvider);
    final error = ref.watch(bookingErrorProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Book Appointment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Registration Centre',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: spacing12),
            ..._centers.map(
              (c) => _CenterTile(
                id: c.id,
                name: c.name,
                address: c.address,
                isSelected: center?.id == c.id,
                onTap: () => ref
                    .read(selectedCenterProvider.notifier)
                    .set(c.id, c.name, c.address),
              ),
            ),
            const SizedBox(height: spacing24),
            Text(
              'Select Date',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: spacing12),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  selectableDayPredicate: (day) =>
                      day.weekday != DateTime.saturday &&
                      day.weekday != DateTime.sunday,
                );
                if (picked != null) {
                  ref.read(appointmentDateProvider.notifier).set(picked);
                }
              },
              child: Container(
                padding: padding16,
                decoration: BoxDecoration(
                  color: surfaceWhite,
                  borderRadius: borderRadius8,
                  border: Border.all(
                    color: date != null ? facebookBlue : borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: date != null ? facebookBlue : mediumGrey,
                    ),
                    const SizedBox(width: spacing12),
                    Text(
                      date != null
                          ? '${date.day}/${date.month}/${date.year}'
                          : 'Choose a date (Mon-Fri)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: date != null ? textPrimary : mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (date != null) ...[
              const SizedBox(height: spacing24),
              Text(
                'Select Time Slot',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: spacing12),
              Wrap(
                spacing: spacing8,
                runSpacing: spacing8,
                children: _timeSlots
                    .map(
                      (t) => ChoiceChip(
                        label: Text(t),
                        selected: slot == t,
                        onSelected: (_) => ref
                            .read(selectedTimeSlotProvider.notifier)
                            .update(t),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (error.isNotEmpty) ...[
              const SizedBox(height: spacing16),
              Container(
                padding: padding16,
                decoration: BoxDecoration(
                  color: errorRed.withValues(alpha: 0.1),
                  borderRadius: borderRadius8,
                ),
                child: Text(error, style: TextStyle(color: errorRed)),
              ),
            ],
            const SizedBox(height: spacing32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    (center != null &&
                        date != null &&
                        slot.isNotEmpty &&
                        !isLoading)
                    ? () => _book(context, ref, center, date, slot)
                    : null,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: whiteColor,
                        ),
                      )
                    : const Text('Confirm Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _book(
    BuildContext context,
    WidgetRef ref,
    ({String id, String name, String address}) center,
    DateTime date,
    String slot,
  ) async {
    // Capture notifiers and messenger before the async gap so they remain
    // usable even if this widget is unmounted after popping on success.
    final loadingNotifier = ref.read(bookingLoadingProvider.notifier);
    final errorNotifier = ref.read(bookingErrorProvider.notifier);
    final appointmentService = ref.read(appointmentServiceProvider);
    final messenger = ScaffoldMessenger.of(context);

    loadingNotifier.set(true);
    errorNotifier.clear();

    try {
      await appointmentService.bookAppointment(
        applicationId: applicationId,
        centerId: center.id,
        centerName: center.name,
        centerAddress: center.address,
        appointmentDate: date,
        timeSlot: slot,
      );

      if (context.mounted) {
        context.pop();
      }
      messenger.showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully!')),
      );
    } catch (e, s) {
      Printer.error(
        'Appointment booking failed',
        tag: 'BookAppointment',
        error: e,
        stackTrace: s,
      );
      errorNotifier.set('Booking failed. Please try again.');
    } finally {
      loadingNotifier.set(false);
    }
  }
}

class _CenterTile extends StatelessWidget {
  const _CenterTile({
    required this.id,
    required this.name,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  final String id;
  final String name;
  final String address;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: spacing8),
      child: Material(
        color: isSelected ? facebookBlue.withValues(alpha: 0.07) : surfaceWhite,
        borderRadius: borderRadius8,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius8,
          child: Container(
            padding: padding16,
            decoration: BoxDecoration(
              borderRadius: borderRadius8,
              border: Border.all(
                color: isSelected ? facebookBlue : borderLight,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: spacing2),
                      Text(
                        address,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: facebookBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
