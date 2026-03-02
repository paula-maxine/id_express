import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/application_model.dart';
import 'auth_provider.dart';
import 'service_providers.dart';

// Applications list provider for current applicant
final applicationListProvider = StreamProvider<List<ApplicationModel>>((ref) {
  return ref.watch(authStateProvider).when(
    data: (user) {
      if (user == null) return const Stream.empty();
      final appService = ref.watch(applicationCloudServiceProvider);
      return appService.getApplicationsByApplicant(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, _) => const Stream.empty(),
  );
});

// Pending verifications for officer
final pendingVerificationsProvider =
    StreamProvider<List<ApplicationModel>>((ref) {
  final appService = ref.watch(applicationCloudServiceProvider);
  return appService.getPendingApplicationsForOfficer();
});

// Single application provider
final applicationProvider = FutureProvider.family<ApplicationModel?, String>(
  (ref, applicationId) async {
    final appService = ref.watch(applicationCloudServiceProvider);
    return appService.getApplication(applicationId);
  },
);

// Applications by status provider
final applicationsByStatusProvider =
    StreamProvider.family<List<ApplicationModel>, String>((ref, status) {
  final appService = ref.watch(applicationCloudServiceProvider);
  return appService.getApplicationsByStatus(status);
});
