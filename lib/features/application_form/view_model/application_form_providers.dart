import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'application_form_providers.g.dart';

/// Current form step (0-indexed, 0..3)
@Riverpod(keepAlive: true)
class FormStep extends _$FormStep {
  @override
  int build() => 0;

  /// Advance to the next step
  void next() => state = (state + 1).clamp(0, 3);

  /// Go back to the previous step
  void previous() => state = (state - 1).clamp(0, 3);

  /// Reset to first step
  void reset() => state = 0;
}

/// Selected application type for the new form
@Riverpod(keepAlive: true)
class SelectedApplicationType extends _$SelectedApplicationType {
  @override
  ApplicationType build() => ApplicationType.newRegistration;

  /// Update the selected type
  void update(ApplicationType type) => state = type;
}

// ── Personal Info ──────────────────────────────────────────────────────────

/// First name input
@Riverpod(keepAlive: true)
class FirstName extends _$FirstName {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Middle name input
@Riverpod(keepAlive: true)
class MiddleName extends _$MiddleName {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Last name input
@Riverpod(keepAlive: true)
class LastName extends _$LastName {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Date of birth input
@Riverpod(keepAlive: true)
class DateOfBirth extends _$DateOfBirth {
  @override
  DateTime? build() => null;

  void update(DateTime v) => state = v;
  void clear() => state = null;
}

/// Gender input
@Riverpod(keepAlive: true)
class SelectedGender extends _$SelectedGender {
  @override
  Gender? build() => null;

  void update(Gender v) => state = v;
  void clear() => state = null;
}

/// Place of birth input
@Riverpod(keepAlive: true)
class PlaceOfBirth extends _$PlaceOfBirth {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Marital status input
@Riverpod(keepAlive: true)
class SelectedMaritalStatus extends _$SelectedMaritalStatus {
  @override
  MaritalStatus? build() => null;

  void update(MaritalStatus v) => state = v;
  void clear() => state = null;
}

/// Occupation input
@Riverpod(keepAlive: true)
class Occupation extends _$Occupation {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

// ── Family Info ────────────────────────────────────────────────────────────

/// Mother's full name
@Riverpod(keepAlive: true)
class MotherName extends _$MotherName {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Father's full name
@Riverpod(keepAlive: true)
class FatherName extends _$FatherName {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

// ── Address Info ───────────────────────────────────────────────────────────

/// Current address
@Riverpod(keepAlive: true)
class CurrentAddress extends _$CurrentAddress {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Permanent address
@Riverpod(keepAlive: true)
class PermanentAddress extends _$PermanentAddress {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// District of origin
@Riverpod(keepAlive: true)
class DistrictOfOrigin extends _$DistrictOfOrigin {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Village of origin
@Riverpod(keepAlive: true)
class VillageOfOrigin extends _$VillageOfOrigin {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

/// Previous NIN (for renewal/replacement)
@Riverpod(keepAlive: true)
class PreviousNin extends _$PreviousNin {
  @override
  String build() => '';

  void update(String v) => state = v;
  void clear() => state = '';
}

// ── Submission ─────────────────────────────────────────────────────────────

/// Whether a form submission is in progress
@Riverpod(keepAlive: true)
class FormSubmitting extends _$FormSubmitting {
  @override
  bool build() => false;

  void set(bool v) => state = v;
}

/// Form submission error message
@Riverpod(keepAlive: true)
class FormError extends _$FormError {
  @override
  String build() => '';

  void set(String v) => state = v;
  void clear() => state = '';
}

/// Clears all form input providers and resets the step
void clearApplicationForm(WidgetRef ref) {
  ref.read(formStepProvider.notifier).reset();
  ref.read(firstNameProvider.notifier).clear();
  ref.read(middleNameProvider.notifier).clear();
  ref.read(lastNameProvider.notifier).clear();
  ref.read(dateOfBirthProvider.notifier).clear();
  ref.read(selectedGenderProvider.notifier).clear();
  ref.read(placeOfBirthProvider.notifier).clear();
  ref.read(selectedMaritalStatusProvider.notifier).clear();
  ref.read(occupationProvider.notifier).clear();
  ref.read(motherNameProvider.notifier).clear();
  ref.read(fatherNameProvider.notifier).clear();
  ref.read(currentAddressProvider.notifier).clear();
  ref.read(permanentAddressProvider.notifier).clear();
  ref.read(districtOfOriginProvider.notifier).clear();
  ref.read(villageOfOriginProvider.notifier).clear();
  ref.read(previousNinProvider.notifier).clear();
  ref.read(formErrorProvider.notifier).clear();
}
