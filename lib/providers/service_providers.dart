import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cloud/application_cloud_service.dart';
import '../data/cloud/appointment_cloud_service.dart';
import '../data/cloud/audit_cloud_service.dart';
import '../data/cloud/auth_cloud_service.dart';
import '../data/cloud/document_cloud_service.dart';
import '../data/cloud/service_centre_cloud_service.dart';
import '../data/cloud/user_cloud_service.dart';
import '../data/local/sync_service.dart';
import '../data/repository/application_repository.dart';
import '../data/repository/document_repository.dart';
import '../services/storage_service.dart';

// Cloud Service Providers for dependency injection
final authCloudServiceProvider = Provider((ref) {
  return AuthCloudService();
});

final userCloudServiceProvider = Provider((ref) {
  return UserCloudService();
});

final applicationCloudServiceProvider = Provider((ref) {
  return ApplicationCloudService();
});

final documentCloudServiceProvider = Provider((ref) {
  return DocumentCloudService();
});

final appointmentCloudServiceProvider = Provider((ref) {
  return AppointmentCloudService();
});

final auditCloudServiceProvider = Provider((ref) {
  return AuditCloudService();
});

final serviceCentreCloudServiceProvider = Provider((ref) {
  return ServiceCentreCloudService();
});

// Local sync service provider
final syncServiceProvider = Provider((ref) {
  return SyncService();
});

final applicationRepositoryProvider = Provider((ref) {
  final repo = ApplicationRepository(
    cloud: ref.watch(applicationCloudServiceProvider),
    sync: ref.watch(syncServiceProvider),
  );
  // initialize sync service
  repo.init();
  return repo;
});

// Document repository for uploads
final documentRepositoryProvider = Provider((ref) {
  final repo = DocumentRepository(
    cloud: ref.watch(documentCloudServiceProvider),
    sync: ref.watch(syncServiceProvider),
    storage: StorageService(),
  );
  repo.init();
  return repo;
});
