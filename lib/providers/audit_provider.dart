import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/audit_log_model.dart';
import 'service_providers.dart';

// Audit logs provider
final auditLogProvider = FutureProvider<List<AuditLogModel>>((ref) async {
  final auditService = ref.watch(auditCloudServiceProvider);
  return auditService.getAuditLogs(limit: 100);
});

// Audit logs by user provider
final auditLogsByUserProvider =
    FutureProvider.family<List<AuditLogModel>, String>((ref, userId) async {
  final auditService = ref.watch(auditCloudServiceProvider);
  return auditService.getAuditLogsByUser(userId);
});
