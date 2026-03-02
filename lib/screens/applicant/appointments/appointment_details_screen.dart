import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/appointment_model.dart';
import '../../../providers/service_providers.dart';

class AppointmentDetailsScreen extends ConsumerWidget {
  const AppointmentDetailsScreen({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Centre: ${appointment.serviceCentreId}'),
            Text('Date: ${appointment.dateTime.toLocal()}'),
            Text('Queue token: ${appointment.queueToken}'),
            Text('Status: ${appointment.status}'),
            const SizedBox(height: 20),
            if (appointment.status == 'scheduled')
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(appointmentCloudServiceProvider)
                          .cancelAppointment(appointment.id);
                      Navigator.pop(context, true);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      // simple reschedule: pick new date then call service
                      final newDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: appointment.dateTime,
                        lastDate: DateTime.now().add(const Duration(days: 60)),
                      );
                      if (newDate != null) {
                        await ref
                            .read(appointmentCloudServiceProvider)
                            .rescheduleAppointment(appointment.id, newDate);
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Reschedule'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
