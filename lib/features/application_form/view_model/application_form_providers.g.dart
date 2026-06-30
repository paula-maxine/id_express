// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_form_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current form step (0-indexed, 0..3)

@ProviderFor(FormStep)
final formStepProvider = FormStepProvider._();

/// Current form step (0-indexed, 0..3)
final class FormStepProvider extends $NotifierProvider<FormStep, int> {
  /// Current form step (0-indexed, 0..3)
  FormStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formStepProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formStepHash();

  @$internal
  @override
  FormStep create() => FormStep();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$formStepHash() => r'1dbc0bbfb43f35cdb3873d4d1f126564aff38dcb';

/// Current form step (0-indexed, 0..3)

abstract class _$FormStep extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Selected application type for the new form

@ProviderFor(SelectedApplicationType)
final selectedApplicationTypeProvider = SelectedApplicationTypeProvider._();

/// Selected application type for the new form
final class SelectedApplicationTypeProvider
    extends $NotifierProvider<SelectedApplicationType, ApplicationType> {
  /// Selected application type for the new form
  SelectedApplicationTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedApplicationTypeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedApplicationTypeHash();

  @$internal
  @override
  SelectedApplicationType create() => SelectedApplicationType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApplicationType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApplicationType>(value),
    );
  }
}

String _$selectedApplicationTypeHash() =>
    r'7caf374a1a441877cd66ad2dc4f68a1e0a4beeef';

/// Selected application type for the new form

abstract class _$SelectedApplicationType extends $Notifier<ApplicationType> {
  ApplicationType build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ApplicationType, ApplicationType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ApplicationType, ApplicationType>,
              ApplicationType,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// First name input

@ProviderFor(FirstName)
final firstNameProvider = FirstNameProvider._();

/// First name input
final class FirstNameProvider extends $NotifierProvider<FirstName, String> {
  /// First name input
  FirstNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstNameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstNameHash();

  @$internal
  @override
  FirstName create() => FirstName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$firstNameHash() => r'b4e2fb2db2b19baefd98d0d0e081978c84426195';

/// First name input

abstract class _$FirstName extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Middle name input

@ProviderFor(MiddleName)
final middleNameProvider = MiddleNameProvider._();

/// Middle name input
final class MiddleNameProvider extends $NotifierProvider<MiddleName, String> {
  /// Middle name input
  MiddleNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'middleNameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$middleNameHash();

  @$internal
  @override
  MiddleName create() => MiddleName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$middleNameHash() => r'7ba624fecc5dd8b3baf1dc9c04af2a5f918a8606';

/// Middle name input

abstract class _$MiddleName extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Last name input

@ProviderFor(LastName)
final lastNameProvider = LastNameProvider._();

/// Last name input
final class LastNameProvider extends $NotifierProvider<LastName, String> {
  /// Last name input
  LastNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastNameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastNameHash();

  @$internal
  @override
  LastName create() => LastName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$lastNameHash() => r'3732d8581b981a9fa7250410c946510b3be19aad';

/// Last name input

abstract class _$LastName extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Date of birth input

@ProviderFor(DateOfBirth)
final dateOfBirthProvider = DateOfBirthProvider._();

/// Date of birth input
final class DateOfBirthProvider
    extends $NotifierProvider<DateOfBirth, DateTime?> {
  /// Date of birth input
  DateOfBirthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateOfBirthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateOfBirthHash();

  @$internal
  @override
  DateOfBirth create() => DateOfBirth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$dateOfBirthHash() => r'2de70eb7cd3236fbb7c81dd7868162fb78c53901';

/// Date of birth input

abstract class _$DateOfBirth extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Gender input

@ProviderFor(SelectedGender)
final selectedGenderProvider = SelectedGenderProvider._();

/// Gender input
final class SelectedGenderProvider
    extends $NotifierProvider<SelectedGender, Gender?> {
  /// Gender input
  SelectedGenderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedGenderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedGenderHash();

  @$internal
  @override
  SelectedGender create() => SelectedGender();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Gender? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Gender?>(value),
    );
  }
}

String _$selectedGenderHash() => r'042f44bf948e710210d24a0051f2aea1bed523e2';

/// Gender input

abstract class _$SelectedGender extends $Notifier<Gender?> {
  Gender? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Gender?, Gender?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Gender?, Gender?>,
              Gender?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Place of birth input

@ProviderFor(PlaceOfBirth)
final placeOfBirthProvider = PlaceOfBirthProvider._();

/// Place of birth input
final class PlaceOfBirthProvider
    extends $NotifierProvider<PlaceOfBirth, String> {
  /// Place of birth input
  PlaceOfBirthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeOfBirthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeOfBirthHash();

  @$internal
  @override
  PlaceOfBirth create() => PlaceOfBirth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$placeOfBirthHash() => r'2b3cedc60583c42c336d09196060b6efed3b3120';

/// Place of birth input

abstract class _$PlaceOfBirth extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Marital status input

@ProviderFor(SelectedMaritalStatus)
final selectedMaritalStatusProvider = SelectedMaritalStatusProvider._();

/// Marital status input
final class SelectedMaritalStatusProvider
    extends $NotifierProvider<SelectedMaritalStatus, MaritalStatus?> {
  /// Marital status input
  SelectedMaritalStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedMaritalStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedMaritalStatusHash();

  @$internal
  @override
  SelectedMaritalStatus create() => SelectedMaritalStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaritalStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaritalStatus?>(value),
    );
  }
}

String _$selectedMaritalStatusHash() =>
    r'620638654b1f8a6dff08afc90f128e0fa54d79cb';

/// Marital status input

abstract class _$SelectedMaritalStatus extends $Notifier<MaritalStatus?> {
  MaritalStatus? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MaritalStatus?, MaritalStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MaritalStatus?, MaritalStatus?>,
              MaritalStatus?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Occupation input

@ProviderFor(Occupation)
final occupationProvider = OccupationProvider._();

/// Occupation input
final class OccupationProvider extends $NotifierProvider<Occupation, String> {
  /// Occupation input
  OccupationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'occupationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$occupationHash();

  @$internal
  @override
  Occupation create() => Occupation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$occupationHash() => r'6d9d05befe633933c15d144922d4c610ceedeaff';

/// Occupation input

abstract class _$Occupation extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Mother's full name

@ProviderFor(MotherName)
final motherNameProvider = MotherNameProvider._();

/// Mother's full name
final class MotherNameProvider extends $NotifierProvider<MotherName, String> {
  /// Mother's full name
  MotherNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'motherNameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$motherNameHash();

  @$internal
  @override
  MotherName create() => MotherName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$motherNameHash() => r'10644d7e1903d16f5cfac46c70eeef67db2ad64c';

/// Mother's full name

abstract class _$MotherName extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Father's full name

@ProviderFor(FatherName)
final fatherNameProvider = FatherNameProvider._();

/// Father's full name
final class FatherNameProvider extends $NotifierProvider<FatherName, String> {
  /// Father's full name
  FatherNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fatherNameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fatherNameHash();

  @$internal
  @override
  FatherName create() => FatherName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$fatherNameHash() => r'dcd7adf9bca582189b5597b867481685e7775d8b';

/// Father's full name

abstract class _$FatherName extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Current address

@ProviderFor(CurrentAddress)
final currentAddressProvider = CurrentAddressProvider._();

/// Current address
final class CurrentAddressProvider
    extends $NotifierProvider<CurrentAddress, String> {
  /// Current address
  CurrentAddressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAddressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAddressHash();

  @$internal
  @override
  CurrentAddress create() => CurrentAddress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentAddressHash() => r'4a788cb740f3ec989795d6c9e9065826211af7a2';

/// Current address

abstract class _$CurrentAddress extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Permanent address

@ProviderFor(PermanentAddress)
final permanentAddressProvider = PermanentAddressProvider._();

/// Permanent address
final class PermanentAddressProvider
    extends $NotifierProvider<PermanentAddress, String> {
  /// Permanent address
  PermanentAddressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permanentAddressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permanentAddressHash();

  @$internal
  @override
  PermanentAddress create() => PermanentAddress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$permanentAddressHash() => r'8532e67ee13fb8f403744f04891368b2ff4310c8';

/// Permanent address

abstract class _$PermanentAddress extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// District of origin

@ProviderFor(DistrictOfOrigin)
final districtOfOriginProvider = DistrictOfOriginProvider._();

/// District of origin
final class DistrictOfOriginProvider
    extends $NotifierProvider<DistrictOfOrigin, String> {
  /// District of origin
  DistrictOfOriginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'districtOfOriginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$districtOfOriginHash();

  @$internal
  @override
  DistrictOfOrigin create() => DistrictOfOrigin();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$districtOfOriginHash() => r'9193736ad9ca084cedbbc2fc88edfa4c534bc84f';

/// District of origin

abstract class _$DistrictOfOrigin extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Village of origin

@ProviderFor(VillageOfOrigin)
final villageOfOriginProvider = VillageOfOriginProvider._();

/// Village of origin
final class VillageOfOriginProvider
    extends $NotifierProvider<VillageOfOrigin, String> {
  /// Village of origin
  VillageOfOriginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'villageOfOriginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$villageOfOriginHash();

  @$internal
  @override
  VillageOfOrigin create() => VillageOfOrigin();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$villageOfOriginHash() => r'71a8d3dba5e27270bf1e7603b0505b5b571c67d0';

/// Village of origin

abstract class _$VillageOfOrigin extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Previous NIN (for renewal/replacement)

@ProviderFor(PreviousNin)
final previousNinProvider = PreviousNinProvider._();

/// Previous NIN (for renewal/replacement)
final class PreviousNinProvider extends $NotifierProvider<PreviousNin, String> {
  /// Previous NIN (for renewal/replacement)
  PreviousNinProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'previousNinProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$previousNinHash();

  @$internal
  @override
  PreviousNin create() => PreviousNin();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$previousNinHash() => r'28f21bd3a44e9d755164f3f7171ac402606f84be';

/// Previous NIN (for renewal/replacement)

abstract class _$PreviousNin extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether a form submission is in progress

@ProviderFor(FormSubmitting)
final formSubmittingProvider = FormSubmittingProvider._();

/// Whether a form submission is in progress
final class FormSubmittingProvider
    extends $NotifierProvider<FormSubmitting, bool> {
  /// Whether a form submission is in progress
  FormSubmittingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formSubmittingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formSubmittingHash();

  @$internal
  @override
  FormSubmitting create() => FormSubmitting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$formSubmittingHash() => r'cffdde3cfdf0142cb62ef8e0fcea0e420bde63dc';

/// Whether a form submission is in progress

abstract class _$FormSubmitting extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Form submission error message

@ProviderFor(FormError)
final formErrorProvider = FormErrorProvider._();

/// Form submission error message
final class FormErrorProvider extends $NotifierProvider<FormError, String> {
  /// Form submission error message
  FormErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formErrorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formErrorHash();

  @$internal
  @override
  FormError create() => FormError();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$formErrorHash() => r'6a8da81f966a8b1380991ea96611856bf460f511';

/// Form submission error message

abstract class _$FormError extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
