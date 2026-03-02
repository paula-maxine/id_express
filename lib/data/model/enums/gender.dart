enum Gender {
  male,
  female,
}

extension GenderExtension on Gender {
  String get displayName {
    return switch (this) {
      Gender.male => 'Male',
      Gender.female => 'Female',
    };
  }

  static Gender? fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'male' => Gender.male,
      'female' => Gender.female,
      _ => null,
    };
  }

  String toJson() => name;
}
