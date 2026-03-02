import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/appointment_model.dart';
import '../../providers/service_providers.dart';

class DailyAppointmentsScreen extends ConsumerWidget {
  const DailyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // we could filter by centre? For simplicity, show all scheduled today
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Appointments')),
      body: FutureBuilder<List<AppointmentModel>>(
        future: ref
            .read(appointmentCloudServiceProvider)
            .getAppointmentsForDate(now),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('No appointments today'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final appt = list[i];
              return ListTile(
                title: Text(appt.queueToken),
                subtitle: Text(appt.dateTime.toLocal().toString()),
              );
            },
          );
        },
      ),
    );
  }
}
