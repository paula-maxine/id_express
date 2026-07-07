// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applications_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of all applications for the current user

@ProviderFor(allUserApplications)
final allUserApplicationsProvider = AllUserApplicationsProvider._();

/// Stream of all applications for the current user

final class AllUserApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationModel>>,
          List<ApplicationModel>,
          Stream<List<ApplicationModel>>
        >
    with
        $FutureModifier<List<ApplicationModel>>,
        $StreamProvider<List<ApplicationModel>> {
  /// Stream of all applications for the current user
  AllUserApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allUserApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allUserApplicationsHash();

  @$internal
  @override
  $StreamProviderElement<List<ApplicationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ApplicationModel>> create(Ref ref) {
    return allUserApplications(ref);
  }
}

String _$allUserApplicationsHash() =>
    r'60cd00645d31b89c2868d423a303a0176fa17da2';

/// Filtered applications by status

@ProviderFor(ApplicationStatusFilter)
final applicationStatusFilterProvider = ApplicationStatusFilterProvider._();

/// Filtered applications by status
final class ApplicationStatusFilterProvider
    extends $NotifierProvider<ApplicationStatusFilter, ApplicationStatus?> {
  /// Filtered applications by status
  ApplicationStatusFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationStatusFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationStatusFilterHash();

  @$internal
  @override
  ApplicationStatusFilter create() => ApplicationStatusFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApplicationStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApplicationStatus?>(value),
    );
  }
}

String _$applicationStatusFilterHash() =>
    r'12079fcf01b36ec6e1c2c9c6162ec658bcf8efb8';

/// Filtered applications by status

abstract class _$ApplicationStatusFilter extends $Notifier<ApplicationStatus?> {
  ApplicationStatus? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ApplicationStatus?, ApplicationStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ApplicationStatus?, ApplicationStatus?>,
              ApplicationStatus?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Returns applications filtered by the active filter

@ProviderFor(filteredApplications)
final filteredApplicationsProvider = FilteredApplicationsProvider._();

/// Returns applications filtered by the active filter

final class FilteredApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationModel>>,
          AsyncValue<List<ApplicationModel>>,
          AsyncValue<List<ApplicationModel>>
        >
    with $Provider<AsyncValue<List<ApplicationModel>>> {
  /// Returns applications filtered by the active filter
  FilteredApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredApplicationsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<ApplicationModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<ApplicationModel>> create(Ref ref) {
    return filteredApplications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ApplicationModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<ApplicationModel>>>(
        value,
      ),
    );
  }
}

String _$filteredApplicationsHash() =>
    r'02461a6720307964d24cfa3f7b66d1c72886e4f0';

/// Stream of a single application by ID

@ProviderFor(applicationDetail)
final applicationDetailProvider = ApplicationDetailFamily._();

/// Stream of a single application by ID

final class ApplicationDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApplicationModel?>,
          ApplicationModel?,
          Stream<ApplicationModel?>
        >
    with
        $FutureModifier<ApplicationModel?>,
        $StreamProvider<ApplicationModel?> {
  /// Stream of a single application by ID
  ApplicationDetailProvider._({
    required ApplicationDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'applicationDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$applicationDetailHash();

  @override
  String toString() {
    return r'applicationDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ApplicationModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ApplicationModel?> create(Ref ref) {
    final argument = this.argument as String;
    return applicationDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicationDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$applicationDetailHash() => r'33e19d7b4a760952dd0e31e203eab6e1598b71a5';

/// Stream of a single application by ID

final class ApplicationDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ApplicationModel?>, String> {
  ApplicationDetailFamily._()
    : super(
        retry: null,
        name: r'applicationDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Stream of a single application by ID

  ApplicationDetailProvider call(String applicationId) =>
      ApplicationDetailProvider._(argument: applicationId, from: this);

  @override
  String toString() => r'applicationDetailProvider';
}
