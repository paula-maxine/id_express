// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks which user row currently has a role change in flight

@ProviderFor(RoleAssignmentLoading)
final roleAssignmentLoadingProvider = RoleAssignmentLoadingProvider._();

/// Tracks which user row currently has a role change in flight
final class RoleAssignmentLoadingProvider
    extends $NotifierProvider<RoleAssignmentLoading, String?> {
  /// Tracks which user row currently has a role change in flight
  RoleAssignmentLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleAssignmentLoadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleAssignmentLoadingHash();

  @$internal
  @override
  RoleAssignmentLoading create() => RoleAssignmentLoading();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$roleAssignmentLoadingHash() =>
    r'435a371719b8e3b2d526f9d60738b7b6ceea2bc2';

/// Tracks which user row currently has a role change in flight

abstract class _$RoleAssignmentLoading extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
