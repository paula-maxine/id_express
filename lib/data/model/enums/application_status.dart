enum ApplicationStatus {
  submitted,
  underReview,
  approved,
  biometricPending,
  cardReady,
  rejected,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    return switch (this) {
      ApplicationStatus.submitted => 'Submitted',
      ApplicationStatus.underReview => 'Under Review',
      ApplicationStatus.approved => 'Approved',
      ApplicationStatus.biometricPending => 'Biometric Pending',
      ApplicationStatus.cardReady => 'Card Ready',
      ApplicationStatus.rejected => 'Rejected',
    };
  }

  static ApplicationStatus? fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'submitted' => ApplicationStatus.submitted,
      'underreview' => ApplicationStatus.underReview,
      'approved' => ApplicationStatus.approved,
      'biometricpending' => ApplicationStatus.biometricPending,
      'cardready' => ApplicationStatus.cardReady,
      'rejected' => ApplicationStatus.rejected,
      _ => null,
    };
  }

  String toJson() => name;
}
