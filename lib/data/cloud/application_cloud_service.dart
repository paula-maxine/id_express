import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/application_model.dart';
import '../model/audit_log_model.dart';
import 'app_exception.dart';
import 'audit_cloud_service.dart';

class ApplicationCloudService {
  final FirebaseFirestore _firestore;

  ApplicationCloudService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create a new application
  Future<ApplicationModel> createApplication(ApplicationModel application) async {
    try {
      final docRef = _firestore.collection('applications').doc();
      final appWithId = application.copyWith(id: docRef.id);
      await docRef.set(appWithId.toJson());
      // Audit log
      try {
        final auditSvc = AuditCloudService(firestore: _firestore);
        final audit = AuditLogModel(
          id: const Uuid().v4(),
          userId: appWithId.applicantUid,
          userRole: 'applicant',
          action: 'application_created',
          targetCollection: 'applications',
          targetDocId: appWithId.id,
          details: {'tracking_ref': appWithId.trackingRef},
          timestamp: DateTime.now(),
        );
        await auditSvc.logAction(audit);
      } catch (_) {}
      return appWithId;
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to create application: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to create application: $e',
        originalException: e,
      );
    }
  }

  /// Get application by ID
  Future<ApplicationModel?> getApplication(String id) async {
    try {
      final doc = await _firestore.collection('applications').doc(id).get();
      if (!doc.exists) return null;
      return ApplicationModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch application: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch application: $e',
        originalException: e,
      );
    }
  }

  /// Get applications by applicant UID (streaming)
  Stream<List<ApplicationModel>> getApplicationsByApplicant(String uid) {
    try {
      return _firestore
          .collection('applications')
          .where('applicant_uid', isEqualTo: uid)
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ApplicationModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to stream applications: $e',
        originalException: e,
      );
    }
  }

  /// Get applications by status (streaming)
  Stream<List<ApplicationModel>> getApplicationsByStatus(String status) {
    try {
      return _firestore
          .collection('applications')
          .where('status', isEqualTo: status)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ApplicationModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to stream applications by status: $e',
        originalException: e,
      );
    }
  }

  /// Get pending applications for officer (streaming)
  Stream<List<ApplicationModel>> getPendingApplicationsForOfficer() {
    try {
      return _firestore
          .collection('applications')
          .where('status', whereIn: ['submitted', 'underReview'])
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ApplicationModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to stream pending applications: $e',
        originalException: e,
      );
    }
  }

  /// Update application status
  Future<void> updateApplicationStatus(
    String id,
    String newStatus, {
    required String officerUid,
    String? rejectionReason,
  }) async {
    try {
      final updates = {
        'status': newStatus,
        'officer_uid': officerUid,
        'updated_at': FieldValue.serverTimestamp(),
      };

      if (rejectionReason != null) {
        updates['rejection_reason'] = rejectionReason;
      }

      await _firestore.collection('applications').doc(id).update(updates);
      // Audit log for status update
      try {
        final auditSvc = AuditCloudService(firestore: _firestore);
        final audit = AuditLogModel(
          id: const Uuid().v4(),
          userId: officerUid,
          userRole: 'officer',
          action: 'application_status_updated',
          targetCollection: 'applications',
          targetDocId: id,
          details: {'new_status': newStatus, 'rejection_reason': rejectionReason},
          timestamp: DateTime.now(),
        );
        await auditSvc.logAction(audit);
      } catch (_) {}
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to update application status: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update application status: $e',
        originalException: e,
      );
    }
  }

  /// Update application fields
  Future<void> updateApplication(String id, Map<String, dynamic> fields) async {
    try {
      fields['updated_at'] = FieldValue.serverTimestamp();
      await _firestore.collection('applications').doc(id).update(fields);
      // Audit log for application update
      try {
        final auditSvc = AuditCloudService(firestore: _firestore);
        final audit = AuditLogModel(
          id: const Uuid().v4(),
          userId: fields['updated_by'] ?? 'system',
          userRole: 'officer',
          action: 'application_updated',
          targetCollection: 'applications',
          targetDocId: id,
          details: fields,
          timestamp: DateTime.now(),
        );
        await auditSvc.logAction(audit);
      } catch (_) {}
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to update application: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update application: $e',
        originalException: e,
      );
    }
  }
}
