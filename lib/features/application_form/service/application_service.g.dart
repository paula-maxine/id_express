// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ApplicationService]

@ProviderFor(applicationService)
final applicationServiceProvider = ApplicationServiceProvider._();

/// Provides the [ApplicationService]

final class ApplicationServiceProvider
    extends
        $FunctionalProvider<
          ApplicationService,
          ApplicationService,
          ApplicationService
        >
    with $Provider<ApplicationService> {
  /// Provides the [ApplicationService]
  ApplicationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationServiceHash();

  @$internal
  @override
  $ProviderElement<ApplicationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApplicationService create(Ref ref) {
    return applicationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApplicationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApplicationService>(value),
    );
  }
}

String _$applicationServiceHash() =>
    r'5064cdff8f249cf102de9d4914a1391aab621d3e';
