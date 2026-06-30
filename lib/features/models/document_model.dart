import 'enums.dart';

/// Document model for uploaded files
class DocumentModel {
  /// Creates a document model
  const DocumentModel({
    required this.documentId,
    required this.applicationId,
    required this.applicantId,
    required this.documentType,
    required this.fileUrl,
    this.fileName = '',
    this.fileSize = 0,
    this.mimeType = '',
    this.isVerified = false,
    this.uploadedAt,
  });

  /// Document ID
  final String documentId;

  /// Associated application ID
  final String applicationId;

  /// Applicant user ID
  final String applicantId;

  /// Document type
  final DocumentType documentType;

  /// File URL (Firebase Storage)
  final String fileUrl;

  /// File name
  final String fileName;

  /// File size in bytes
  final int fileSize;

  /// MIME type
  final String mimeType;

  /// Whether document is verified by officer
  final bool isVerified;

  /// Upload timestamp
  final DateTime? uploadedAt;

  /// Factory from Firestore document
  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      documentId: map['document_id'] as String? ?? '',
      applicationId: map['application_id'] as String? ?? '',
      applicantId: map['applicant_id'] as String? ?? '',
      documentType: _documentTypeFromString(
        map['document_type'] as String? ?? 'other',
      ),
      fileUrl: map['file_url'] as String? ?? '',
      fileName: map['file_name'] as String? ?? '',
      fileSize: map['file_size'] as int? ?? 0,
      mimeType: map['mime_type'] as String? ?? '',
      isVerified: map['is_verified'] as bool? ?? false,
      uploadedAt: map['uploaded_at'] != null
          ? DateTime.parse(map['uploaded_at'] as String)
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'document_id': documentId,
      'application_id': applicationId,
      'applicant_id': applicantId,
      'document_type': documentType.name,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'mime_type': mimeType,
      'is_verified': isVerified,
      'uploaded_at':
          uploadedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  /// Convenience getter for Firestore withConverter
  Map<String, dynamic> get asMap => toMap();

  /// Immutable copy
  DocumentModel copyWith({
    String? documentId,
    String? applicationId,
    String? applicantId,
    DocumentType? documentType,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    bool? isVerified,
    DateTime? uploadedAt,
  }) {
    return DocumentModel(
      documentId: documentId ?? this.documentId,
      applicationId: applicationId ?? this.applicationId,
      applicantId: applicantId ?? this.applicantId,
      documentType: documentType ?? this.documentType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      isVerified: isVerified ?? this.isVerified,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  /// Empty instance
  static DocumentModel get empty => DocumentModel(
    documentId: '',
    applicationId: '',
    applicantId: '',
    documentType: DocumentType.other,
    fileUrl: '',
  );

  /// Helper to convert enum from string
  static DocumentType _documentTypeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'passport_photo':
        return DocumentType.passportPhoto;
      case 'birth_certificate':
        return DocumentType.birthCertificate;
      case 'school_id':
        return DocumentType.schoolId;
      case 'previous_national_id':
        return DocumentType.previousNationalId;
      case 'marriage_certificate':
        return DocumentType.marriageCertificate;
      case 'recommendation_letter':
        return DocumentType.recommendationLetter;
      default:
        return DocumentType.other;
    }
  }
}
