import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/audit_log_model.dart';
import '../model/document_model.dart';
import 'app_exception.dart';
import 'audit_cloud_service.dart';

class DocumentCloudService {
  final FirebaseFirestore _firestore;

  DocumentCloudService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get documents by application ID
  Future<List<DocumentModel>> getDocumentsByApplication(
      String applicationId) async {
    try {
      final query = await _firestore
          .collection('documents')
          .where('application_id', isEqualTo: applicationId)
          .get();
      return query.docs
          .map((doc) => DocumentModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch documents: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch documents: $e',
        originalException: e,
      );
    }
  }

  /// Stream documents for an application
  Stream<List<DocumentModel>> streamDocumentsByApplication(
      String applicationId) {
    try {
      return _firestore
          .collection('documents')
          .where('application_id', isEqualTo: applicationId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => DocumentModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to stream documents: $e',
        originalException: e,
      );
    }
  }

  /// Create document record
  Future<DocumentModel> createDocumentRecord(DocumentModel document) async {
    try {
      final docRef = _firestore.collection('documents').doc();
      final docWithId = document.copyWith(id: docRef.id);
      await docRef.set(docWithId.toJson());
      return docWithId;
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to create document record: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to create document record: $e',
        originalException: e,
      );
    }
  }

  /// Verify document
  Future<void> verifyDocument(String docId, String officerUid) async {
    try {
      await _firestore.collection('documents').doc(docId).update({
        'is_verified': true,
        'verified_by_uid': officerUid,
        'verified_at': FieldValue.serverTimestamp(),
      });
      // Audit log
      try {
        final auditSvc = AuditCloudService(firestore: _firestore);
        final audit = AuditLogModel(
          id: const Uuid().v4(),
          userId: officerUid,
          userRole: 'officer',
          action: 'document_verified',
          targetCollection: 'documents',
          targetDocId: docId,
          details: null,
          timestamp: DateTime.now(),
        );
        await auditSvc.logAction(audit);
      } catch (_) {}
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to verify document: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to verify document: $e',
        originalException: e,
      );
    }
  }

  /// Flag document for review
  Future<void> flagDocument(String docId, String reason) async {
    try {
      await _firestore.collection('documents').doc(docId).update({
        'flag_reason': reason,
        'is_verified': false,
      });
      // Audit log for flagging
      try {
        final auditSvc = AuditCloudService(firestore: _firestore);
        final audit = AuditLogModel(
          id: const Uuid().v4(),
          userId: 'system',
          userRole: 'system',
          action: 'document_flagged',
          targetCollection: 'documents',
          targetDocId: docId,
          details: {'reason': reason},
          timestamp: DateTime.now(),
        );
        await auditSvc.logAction(audit);
      } catch (_) {}
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to flag document: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to flag document: $e',
        originalException: e,
      );
    }
  }

  /// Delete document
  Future<void> deleteDocument(String docId) async {
    try {
      await _firestore.collection('documents').doc(docId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to delete document: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to delete document: $e',
        originalException: e,
      );
    }
  }
}
