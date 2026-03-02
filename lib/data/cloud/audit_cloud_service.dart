import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/audit_log_model.dart';
import 'app_exception.dart';

class AuditCloudService {
  final FirebaseFirestore _firestore;

  AuditCloudService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Log an action to audit trail
  Future<void> logAction(AuditLogModel log) async {
    try {
      await _firestore.collection('audit_logs').doc().set(log.toJson());
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to log action: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to log action: $e',
        originalException: e,
      );
    }
  }

  /// Get audit logs with optional filters
  Future<List<AuditLogModel>> getAuditLogs({
    String? userId,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    try {
      var query = _firestore.collection('audit_logs') as Query;

      if (userId != null) {
        query = query.where('user_id', isEqualTo: userId);
      }

      if (action != null) {
        query = query.where('action', isEqualTo: action);
      }

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      final result = await query
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return result.docs
          .map((doc) => AuditLogModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch audit logs: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch audit logs: $e',
        originalException: e,
      );
    }
  }

  /// Get audit logs by user
  Future<List<AuditLogModel>> getAuditLogsByUser(String userId,
      {int limit = 50}) async {
    try {
      final result = await _firestore
          .collection('audit_logs')
          .where('user_id', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return result.docs
          .map((doc) => AuditLogModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch user audit logs: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch user audit logs: $e',
        originalException: e,
      );
    }
  }
}
