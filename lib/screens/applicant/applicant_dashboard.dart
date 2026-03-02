import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global/widgets/app_button.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import 'appointments/appointment_details_screen.dart';
import 'appointments/book_appointment_screen.dart';

class ApplicantDashboard extends ConsumerWidget {
  const ApplicantDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.displayName ?? 'Applicant'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Appointments',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Consumer(builder: (context, ref, _) {
                final apps = ref.watch(appointmentStreamProvider);
                return apps.when(
                  data: (list) {
                    if (list.isEmpty) {
                      return const Center(child: Text('No appointments yet'));
                    }
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final appt = list[index];
                        return ListTile(
                          title: Text(appt.queueToken),
                          subtitle: Text(appt.dateTime.toLocal().toString()),
                          onTap: () async {
                            final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AppointmentDetailsScreen(appointment: appt),
                              ),
                            );
                            if (res == true) {
                              // refresh automatically via stream
                            }
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                );
              }),
            ),
            AppButton(
              label: 'Book Appointment',
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => BookAppointmentScreen(applicationId: user?.uid ?? '')),
                );
                if (result == true) {
                  // nothing
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
