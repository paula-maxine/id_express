enum DocumentType {
  birthCertificate,
  passportPhoto,
  supportingDocument,
  nationalId,
}

extension DocumentTypeExtension on DocumentType {
  String get displayName {
    return switch (this) {
      DocumentType.birthCertificate => 'Birth Certificate',
      DocumentType.passportPhoto => 'Passport Photo',
      DocumentType.supportingDocument => 'Supporting Document',
      DocumentType.nationalId => 'National ID',
    };
  }

  static DocumentType? fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'birthcertificate' => DocumentType.birthCertificate,
      'passportphoto' => DocumentType.passportPhoto,
      'supportingdocument' => DocumentType.supportingDocument,
      'nationalid' => DocumentType.nationalId,
      _ => null,
    };
  }

  String toJson() => name;
}
