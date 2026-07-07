import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'officer_providers.g.dart';

/// All submitted applications (for officers to review)
@riverpod
Stream<List<ApplicationModel>> pendingApplications(Ref ref) {
  return FirebaseFirestore.instance
      .collection('applications')
      .where(
        'status',
        whereIn: [
          ApplicationStatus.submitted.name,
          ApplicationStatus.underReview.name,
        ],
      )
      .orderBy('created_at', descending: false)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => ApplicationModel.fromMap(d.data())).toList(),
      );
}

/// Approved applications (for officer/admin visibility)
@riverpod
Stream<List<ApplicationModel>> approvedApplications(Ref ref) {
  return FirebaseFirestore.instance
      .collection('applications')
      .where('status', isEqualTo: ApplicationStatus.approved.name)
      .orderBy('updated_at', descending: true)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => ApplicationModel.fromMap(d.data())).toList(),
      );
}

/// Applications assigned to / reviewed by the current officer
@riverpod
Stream<List<ApplicationModel>> officerApplications(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null || uid.isEmpty) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('applications')
      .where('reviewed_by', isEqualTo: uid)
      .orderBy('updated_at', descending: true)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => ApplicationModel.fromMap(d.data())).toList(),
      );
}

/// Active status filter for officer dashboard
@riverpod
class OfficerStatusFilter extends _$OfficerStatusFilter {
  @override
  ApplicationStatus? build() => null;

  /// Sets the active filter
  void set(ApplicationStatus? status) => state = status;
}

/// Officer review action — approve or reject
@riverpod
class ReviewActionLoading extends _$ReviewActionLoading {
  @override
  bool build() => false;

  void set(bool v) => state = v;
}

/// Officer review error
@riverpod
class ReviewActionError extends _$ReviewActionError {
  @override
  String build() => '';

  void set(String v) => state = v;
  void clear() => state = '';
}

/// Officer rejection reason input
@riverpod
class RejectionReason extends _$RejectionReason {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Officer notes input
@riverpod
class OfficerNotes extends _$OfficerNotes {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}
