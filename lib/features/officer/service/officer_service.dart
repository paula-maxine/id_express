import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';
import '../../../data/cloud/audit_cloud_service.dart';
import '../../../data/model/audit_log_model.dart' as legacy;

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
  }) async {
    await ref
        .read(applicationServiceProvider)
        .updateStatus(
          applicationId: applicationId,
          status: ApplicationStatus.approved,
          officerNotes: notes.isEmpty ? null : notes,
        );
    await _logAction(
      action: 'application_approved',
      applicationId: applicationId,
      details: {'notes': notes},
    );
  }

  /// Rejects an application with a reason
  Future<void> reject({
    required String applicationId,
    required String reason,
  }) async {
    await ref
        .read(applicationServiceProvider)
        .updateStatus(
          applicationId: applicationId,
          status: ApplicationStatus.rejected,
          rejectionReason: reason,
        );
    await _logAction(
      action: 'application_rejected',
      applicationId: applicationId,
      details: {'reason': reason},
    );
  }

  /// Marks biometrics as captured
  Future<void> markBiometricsCaptured(String applicationId) async {
    await ref
        .read(applicationServiceProvider)
        .updateStatus(
          applicationId: applicationId,
          status: ApplicationStatus.biometricCaptured,
        );
    await _logAction(
      action: 'biometrics_captured',
      applicationId: applicationId,
    );
  }

  /// Writes an audit trail entry for an officer review action
  Future<void> _logAction({
    required String action,
    required String applicationId,
    Map<String, dynamic>? details,
  }) async {
    final officer = ref.read(currentUserProvider).value;
    try {
      await AuditCloudService().logAction(
        legacy.AuditLogModel(
          id: const Uuid().v4(),
          userId: officer?.userId ?? '',
          userRole: officer?.role.name ?? '',
          action: action,
          targetCollection: 'applications',
          targetDocId: applicationId,
          details: details,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e, s) {
      // Audit logging is best-effort and must not block the review action,
      // but log the failure so it is visible in the debug console.
      Printer.error(
        'Failed to write "$action" audit log',
        tag: 'OfficerReviewService',
        error: e,
        stackTrace: s,
      );
    }
  }
}

/// Provides the [OfficerReviewService]
@Riverpod(keepAlive: true)
OfficerReviewService officerReviewService(Ref ref) => OfficerReviewService(ref);
