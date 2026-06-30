import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'applications_providers.g.dart';

/// Stream of all applications for the current user
@riverpod
Stream<List<ApplicationModel>> allUserApplications(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null || uid.isEmpty) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('applications')
      .where('applicant_id', isEqualTo: uid)
      .orderBy('created_at', descending: true)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => ApplicationModel.fromMap(d.data())).toList(),
      );
}

/// Filtered applications by status
@riverpod
class ApplicationStatusFilter extends _$ApplicationStatusFilter {
  @override
  ApplicationStatus? build() => null;

  /// Set the active filter
  void set(ApplicationStatus? status) => state = status;
}

/// Returns applications filtered by the active filter
@riverpod
AsyncValue<List<ApplicationModel>> filteredApplications(Ref ref) {
  final all = ref.watch(allUserApplicationsProvider);
  final filter = ref.watch(applicationStatusFilterProvider);

  return all.whenData(
    (applications) => filter == null
        ? applications
        : applications.where((a) => a.status == filter).toList(),
  );
}

/// Stream of a single application by ID
@riverpod
Stream<ApplicationModel?> applicationDetail(Ref ref, String applicationId) {
  return FirebaseFirestore.instance
      .collection('applications')
      .doc(applicationId)
      .snapshots()
      .map(
        (doc) => doc.exists ? ApplicationModel.fromMap(doc.data() ?? {}) : null,
      );
}
