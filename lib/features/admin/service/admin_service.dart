import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';
import '../../../data/cloud/audit_cloud_service.dart';
import '../../../data/model/audit_log_model.dart' as legacy;

part 'admin_service.g.dart';

/// Stream of all users in the system (admin only)
@riverpod
Stream<List<UserModel>> allUsers(Ref ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .orderBy('display_name')
      .snapshots()
      .map((s) => s.docs.map((d) => UserModel.fromMap(d.data())).toList());
}

/// Admin service — manages user roles
class AdminService {
  /// Creates the admin service
  const AdminService(this.ref);

  /// Riverpod ref
  final Ref ref;

  /// Assigns a new role to a user and records an audit log entry
  Future<void> assignRole({
    required String userId,
    required UserRole role,
  }) async {
    // Capture the acting admin before the async gap so the audit entry reflects
    // who initiated the change, and to avoid reading the provider afterwards.
    final admin = ref.read(currentUserProvider).value;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'role': role.name,
      'updated_at': DateTime.now().toIso8601String(),
    });

    try {
      await AuditCloudService().logAction(
        legacy.AuditLogModel(
          id: const Uuid().v4(),
          userId: admin?.userId ?? '',
          userRole: admin?.role.name ?? '',
          action: 'role_assigned',
          targetCollection: 'users',
          targetDocId: userId,
          details: {'new_role': role.name},
          timestamp: DateTime.now(),
        ),
      );
    } catch (e, s) {
      // Audit logging is best-effort and must not block the role change,
      // but log the failure so it is visible in the debug console.
      Printer.error(
        'Failed to write role_assigned audit log',
        tag: 'AdminService',
        error: e,
        stackTrace: s,
      );
    }
  }
}

/// Provides the [AdminService]
@Riverpod(keepAlive: true)
AdminService adminService(Ref ref) => AdminService(ref);
