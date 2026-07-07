// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether profile is being saved

@ProviderFor(ProfileSaving)
final profileSavingProvider = ProfileSavingProvider._();

/// Whether profile is being saved
final class ProfileSavingProvider
    extends $NotifierProvider<ProfileSaving, bool> {
  /// Whether profile is being saved
  ProfileSavingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSavingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSavingHash();

  @$internal
  @override
  ProfileSaving create() => ProfileSaving();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$profileSavingHash() => r'b4b7dbd2237ccd82a31f0db56d473987831101bd';

/// Whether profile is being saved

abstract class _$ProfileSaving extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Profile save error

@ProviderFor(ProfileError)
final profileErrorProvider = ProfileErrorProvider._();

/// Profile save error
final class ProfileErrorProvider
    extends $NotifierProvider<ProfileError, String> {
  /// Profile save error
  ProfileErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileErrorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileErrorHash();

  @$internal
  @override
  ProfileError create() => ProfileError();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$profileErrorHash() => r'50214fd6a87224cd08810d565943c0c6e8cd0a13';

/// Profile save error

abstract class _$ProfileError extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
