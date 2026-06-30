import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'officer_service.g.dart';

/// Stream of documents for an application (used in officer review)
@riverpod
Stream<List<DocumentModel>> reviewDocuments(Ref ref, String applicationId) {
  return FirebaseFirestore.instance
      .collection('documents')
      .where('application_id', isEqualTo: applicationId)
      .snapshots()
      .map((s) => s.docs.map((d) => DocumentModel.fromMap(d.data())).toList());
}

/// Officer review service — wraps [ApplicationService] for review operations
class OfficerReviewService {
  /// Creates the officer review service
  const OfficerReviewService(this.ref);

  /// Riverpod ref
  final Ref ref;

  /// Approves an application
  Future<void> approve({
    required String applicationId,
    required String notes,
  }) => ref
      .read(applicationServiceProvider)
      .updateStatus(
        applicationId: applicationId,
        status: ApplicationStatus.approved,
        officerComment: notes.isEmpty ? null : notes,
      );

  /// Rejects an application with a reason
  Future<void> reject({
    required String applicationId,
    required String reason,
  }) => ref
      .read(applicationServiceProvider)
      .updateStatus(
        applicationId: applicationId,
        status: ApplicationStatus.rejected,
        officerComment: reason,
      );

  /// Marks biometrics as captured
  Future<void> markBiometricsCaptured(String applicationId) => ref
      .read(applicationServiceProvider)
      .updateStatus(
        applicationId: applicationId,
        status: ApplicationStatus.biometricCaptured,
      );
}

/// Provides the [OfficerReviewService]
@Riverpod(keepAlive: true)
OfficerReviewService officerReviewService(Ref ref) => OfficerReviewService(ref);
