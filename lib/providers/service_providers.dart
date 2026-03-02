import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cloud/auth_cloud_service.dart';
import '../data/cloud/user_cloud_service.dart';
import '../data/cloud/application_cloud_service.dart';
import '../data/cloud/document_cloud_service.dart';
import '../data/cloud/appointment_cloud_service.dart';
import '../data/cloud/audit_cloud_service.dart';
import '../data/cloud/service_centre_cloud_service.dart';

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
