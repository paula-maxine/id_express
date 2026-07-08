import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'applicant_home_providers.g.dart';

/// Provides the static list of available services
@Riverpod(keepAlive: true)
List<ServiceType> availableServices(Ref ref) => ServiceType.allServices;

/// Stream of the current user's applications (most recent 5)
@riverpod
Stream<List<ApplicationModel>> userApplications(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null || uid.isEmpty) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('applications')
      .where('applicant_id', isEqualTo: uid)
      .orderBy('created_at', descending: true)
      .limit(5)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => ApplicationModel.fromMap(d.data())).toList(),
      );
}

/// Count of in-progress applications
@riverpod
Stream<int> pendingApplicationsCount(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null || uid.isEmpty) return Stream.value(0);

  return FirebaseFirestore.instance
      .collection('applications')
      .where('applicant_id', isEqualTo: uid)
      .where(
        'status',
        whereIn: [
          ApplicationStatus.submitted.name,
          ApplicationStatus.underReview.name,
          ApplicationStatus.approved.name,
        ],
      )
      .snapshots()
      .map((s) => s.docs.length);
}

/// Count of upcoming confirmed appointments.
///
/// Computed in memory from the appointment models so that the local overdue
/// logic ([AppointmentModel.isUpcoming]) applies — a confirmed appointment
/// whose date has passed is not counted as upcoming.
@riverpod
Stream<int> upcomingAppointmentsCount(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null || uid.isEmpty) return Stream.value(0);

  return FirebaseFirestore.instance
      .collection('appointments')
      .where('applicant_id', isEqualTo: uid)
      .snapshots()
      .map(
        (s) => s.docs
            .map((d) => AppointmentModel.fromMap(d.data()))
            .where((a) => a.isUpcoming)
            .length,
      );
}
