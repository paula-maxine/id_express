import 'enums.dart';

/// Application model for national ID registration
class ApplicationModel {
  /// Creates an application model
  const ApplicationModel({
    required this.applicationId,
    required this.applicantId,
    required this.applicationType,
    required this.status,
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.dateOfBirth,
    this.gender,
    this.placeOfBirth = '',
    this.nationality = 'Uganda',
    this.maritalStatus,
    this.occupation = '',
    this.motherName = '',
    this.fatherName = '',
    this.currentAddress = '',
    this.permanentAddress = '',
    this.districtOfOrigin = '',
    this.villageOfOrigin = '',
    this.previousNin = '',
    this.reasonForApplication = '',
    this.officerNotes = '',
    this.rejectionReason = '',
    this.approvedBy = '',
    this.reviewedBy = '',
    this.nin = '',
    this.createdAt,
    this.updatedAt,
    this.submittedAt,
    this.approvedAt,
  });

  /// Application ID
  final String applicationId;

  /// Applicant user ID
  final String applicantId;

  /// Application type
  final ApplicationType applicationType;

  /// Application status
  final ApplicationStatus status;

  /// Demographic details
  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String placeOfBirth;
  final String nationality;
  final MaritalStatus? maritalStatus;
  final String occupation;

  /// Family details
  final String motherName;
  final String fatherName;

  /// Address details
  final String currentAddress;
  final String permanentAddress;
  final String districtOfOrigin;
  final String villageOfOrigin;

  /// Previous ID details (for renewal/replacement)
  final String previousNin;

  /// Application metadata
  final String reasonForApplication;
  final String officerNotes;
  final String rejectionReason;
  final String approvedBy;
  final String reviewedBy;

  /// Generated NIN (after approval)
  final String nin;

  /// Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? submittedAt;
  final DateTime? approvedAt;

  /// Factory from Firestore document
  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      applicationId: map['application_id'] as String? ?? '',
      applicantId: map['applicant_id'] as String? ?? '',
      applicationType: _applicationTypeFromString(
        map['application_type'] as String? ?? 'new_registration',
      ),
      status: _statusFromString(map['status'] as String? ?? 'draft'),
      firstName: map['first_name'] as String? ?? '',
      middleName: map['middle_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.parse(map['date_of_birth'] as String)
          : null,
      gender: map['gender'] != null
          ? _genderFromString(map['gender'] as String)
          : null,
      placeOfBirth: map['place_of_birth'] as String? ?? '',
      nationality: map['nationality'] as String? ?? 'Uganda',
      maritalStatus: map['marital_status'] != null
          ? _maritalStatusFromString(map['marital_status'] as String)
          : null,
      occupation: map['occupation'] as String? ?? '',
      motherName: map['mother_name'] as String? ?? '',
      fatherName: map['father_name'] as String? ?? '',
      currentAddress: map['current_address'] as String? ?? '',
      permanentAddress: map['permanent_address'] as String? ?? '',
      districtOfOrigin: map['district_of_origin'] as String? ?? '',
      villageOfOrigin: map['village_of_origin'] as String? ?? '',
      previousNin: map['previous_nin'] as String? ?? '',
      reasonForApplication: map['reason_for_application'] as String? ?? '',
      officerNotes: map['officer_notes'] as String? ?? '',
      rejectionReason: map['rejection_reason'] as String? ?? '',
      approvedBy: map['approved_by'] as String? ?? '',
      reviewedBy: map['reviewed_by'] as String? ?? '',
      nin: map['nin'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      submittedAt: map['submitted_at'] != null
          ? DateTime.parse(map['submitted_at'] as String)
          : null,
      approvedAt: map['approved_at'] != null
          ? DateTime.parse(map['approved_at'] as String)
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'application_id': applicationId,
      'applicant_id': applicantId,
      'application_type': applicationType.name,
      'status': status.name,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender?.name,
      'place_of_birth': placeOfBirth,
      'nationality': nationality,
      'marital_status': maritalStatus?.name,
      'occupation': occupation,
      'mother_name': motherName,
      'father_name': fatherName,
      'current_address': currentAddress,
      'permanent_address': permanentAddress,
      'district_of_origin': districtOfOrigin,
      'village_of_origin': villageOfOrigin,
      'previous_nin': previousNin,
      'reason_for_application': reasonForApplication,
      'officer_notes': officerNotes,
      'rejection_reason': rejectionReason,
      'approved_by': approvedBy,
      'reviewed_by': reviewedBy,
      'nin': nin,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'submitted_at': submittedAt?.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
    };
  }

  /// Convenience getter for Firestore withConverter
  Map<String, dynamic> get asMap => toMap();

  /// Immutable copy
  ApplicationModel copyWith({
    String? applicationId,
    String? applicantId,
    ApplicationType? applicationType,
    ApplicationStatus? status,
    String? firstName,
    String? middleName,
    String? lastName,
    DateTime? dateOfBirth,
    Gender? gender,
    String? placeOfBirth,
    String? nationality,
    MaritalStatus? maritalStatus,
    String? occupation,
    String? motherName,
    String? fatherName,
    String? currentAddress,
    String? permanentAddress,
    String? districtOfOrigin,
    String? villageOfOrigin,
    String? previousNin,
    String? reasonForApplication,
    String? officerNotes,
    String? rejectionReason,
    String? approvedBy,
    String? reviewedBy,
    String? nin,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? submittedAt,
    DateTime? approvedAt,
  }) {
    return ApplicationModel(
      applicationId: applicationId ?? this.applicationId,
      applicantId: applicantId ?? this.applicantId,
      applicationType: applicationType ?? this.applicationType,
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      nationality: nationality ?? this.nationality,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      occupation: occupation ?? this.occupation,
      motherName: motherName ?? this.motherName,
      fatherName: fatherName ?? this.fatherName,
      currentAddress: currentAddress ?? this.currentAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      districtOfOrigin: districtOfOrigin ?? this.districtOfOrigin,
      villageOfOrigin: villageOfOrigin ?? this.villageOfOrigin,
      previousNin: previousNin ?? this.previousNin,
      reasonForApplication: reasonForApplication ?? this.reasonForApplication,
      officerNotes: officerNotes ?? this.officerNotes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      approvedBy: approvedBy ?? this.approvedBy,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      nin: nin ?? this.nin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      submittedAt: submittedAt ?? this.submittedAt,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }

  /// Empty instance
  static ApplicationModel get empty => ApplicationModel(
    applicationId: '',
    applicantId: '',
    applicationType: ApplicationType.newRegistration,
    status: ApplicationStatus.draft,
  );

  /// Full name
  String get fullName => '$firstName $middleName $lastName'.trim();

  /// Helper methods to convert enum from strings
  static ApplicationType _applicationTypeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'renewal':
        return ApplicationType.renewal;
      case 'replacement':
        return ApplicationType.replacement;
      case 'change_of_particulars':
        return ApplicationType.changeOfParticulars;
      default:
        return ApplicationType.newRegistration;
    }
  }

  static ApplicationStatus _statusFromString(String value) {
    switch (value.toLowerCase()) {
      case 'submitted':
        return ApplicationStatus.submitted;
      case 'under_review':
        return ApplicationStatus.underReview;
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'biometric_captured':
        return ApplicationStatus.biometricCaptured;
      case 'id_ready':
        return ApplicationStatus.idReady;
      case 'completed':
        return ApplicationStatus.completed;
      case 'cancelled':
        return ApplicationStatus.cancelled;
      default:
        return ApplicationStatus.draft;
    }
  }

  static Gender _genderFromString(String value) {
    return value.toLowerCase() == 'female' ? Gender.female : Gender.male;
  }

  static MaritalStatus _maritalStatusFromString(String value) {
    switch (value.toLowerCase()) {
      case 'married':
        return MaritalStatus.married;
      case 'divorced':
        return MaritalStatus.divorced;
      case 'widowed':
        return MaritalStatus.widowed;
      default:
        return MaritalStatus.single;
    }
  }
}
