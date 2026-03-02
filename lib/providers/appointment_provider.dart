import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/appointment_model.dart';
import 'auth_provider.dart';
import 'service_providers.dart';

// User's appointments provider
final appointmentListProvider = FutureProvider<List<AppointmentModel>>((ref) {
  return ref.watch(authStateProvider).when(
    data: (user) async {
      if (user == null) return [];
      final appointmentService = ref.watch(appointmentCloudServiceProvider);
      return appointmentService.getAppointmentsByApplicant(user.uid);
    },
    loading: () => Future.value([]),
    error: (_, _) => Future.value([]),
  );
});

// Stream user appointments
final appointmentStreamProvider = StreamProvider<List<AppointmentModel>>((ref) {
  return ref.watch(authStateProvider).when(
    data: (user) {
      if (user == null) return const Stream.empty();
      final appointmentService = ref.watch(appointmentCloudServiceProvider);
      return appointmentService.streamAppointmentsByApplicant(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, _) => const Stream.empty(),
  );
});

// Appointments by date and centre
final appointmentsByDateProvider =
    FutureProvider.family<List<AppointmentModel>, (String, DateTime)>(
  (ref, params) async {
    final (centreId, date) = params;
    final appointmentService = ref.watch(appointmentCloudServiceProvider);
    return appointmentService.getAppointmentsByDate(centreId, date);
  },
);
