import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'application_service.g.dart';

/// Service for managing applications in Firestore
class ApplicationService {
  /// Creates the application service
  const ApplicationService(this.ref);

  /// Riverpod ref for provider access
  final Ref ref;

  /// Creates a new application document in Firestore
  Future<String?> createApplication({
    required ApplicationType applicationType,
    required String firstName,
    required String middleName,
    required String lastName,
    required DateTime? dateOfBirth,
    required Gender? gender,
    required String placeOfBirth,
    required MaritalStatus? maritalStatus,
    required String occupation,
    required String motherName,
    required String fatherName,
    required String currentAddress,
    required String permanentAddress,
    required String districtOfOrigin,
    required String villageOfOrigin,
    required String previousNin,
  }) async {
    final uid = ref.read(userIdProvider);
    if (uid == null || uid.isEmpty) return null;

    final applicationId = const Uuid().v4();
    final now = DateTime.now();

    final application = ApplicationModel(
      applicationId: applicationId,
      applicantId: uid,
      applicationType: applicationType,
      status: ApplicationStatus.submitted,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      dateOfBirth: dateOfBirth ?? DateTime(2000),
      gender: gender ?? Gender.male,
      placeOfBirth: placeOfBirth,
      maritalStatus: maritalStatus ?? MaritalStatus.single,
      occupation: occupation,
      motherName: motherName,
      fatherName: fatherName,
      currentAddress: currentAddress,
      permanentAddress: permanentAddress.isEmpty
          ? currentAddress
          : permanentAddress,
      districtOfOrigin: districtOfOrigin,
      villageOfOrigin: villageOfOrigin,
      previousNin: previousNin,
      createdAt: now,
      updatedAt: now,
    );

    await FirebaseFirestore.instance
        .collection('applications')
        .doc(applicationId)
        .set(application.toMap());

    return applicationId;
  }

  /// Updates the status of an application (officer action)
  Future<void> updateStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? officerComment,
  }) async {
    final uid = ref.read(userIdProvider);

    await FirebaseFirestore.instance
        .collection('applications')
        .doc(applicationId)
        .update({
          'status': status.name,
          'officer_comment': officerComment,
          'updated_at': DateTime.now().toIso8601String(),
          'reviewed_by': uid,
        });
  }
}

/// Provides the [ApplicationService]
@Riverpod(keepAlive: true)
ApplicationService applicationService(Ref ref) => ApplicationService(ref);
