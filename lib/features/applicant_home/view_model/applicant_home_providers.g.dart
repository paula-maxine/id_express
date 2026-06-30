// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the static list of available services

@ProviderFor(availableServices)
final availableServicesProvider = AvailableServicesProvider._();

/// Provides the static list of available services

final class AvailableServicesProvider
    extends
        $FunctionalProvider<
          List<ServiceType>,
          List<ServiceType>,
          List<ServiceType>
        >
    with $Provider<List<ServiceType>> {
  /// Provides the static list of available services
  AvailableServicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableServicesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableServicesHash();

  @$internal
  @override
  $ProviderElement<List<ServiceType>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ServiceType> create(Ref ref) {
    return availableServices(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ServiceType> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ServiceType>>(value),
    );
  }
}

String _$availableServicesHash() => r'716361fff2fc95159b08a4d7e3365e7b94b5e02d';

/// Stream of the current user's applications (most recent 5)

@ProviderFor(userApplications)
final userApplicationsProvider = UserApplicationsProvider._();

/// Stream of the current user's applications (most recent 5)

final class UserApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationModel>>,
          List<ApplicationModel>,
          Stream<List<ApplicationModel>>
        >
    with
        $FutureModifier<List<ApplicationModel>>,
        $StreamProvider<List<ApplicationModel>> {
  /// Stream of the current user's applications (most recent 5)
  UserApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userApplicationsHash();

  @$internal
  @override
  $StreamProviderElement<List<ApplicationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ApplicationModel>> create(Ref ref) {
    return userApplications(ref);
  }
}

String _$userApplicationsHash() => r'22bacfbdfc9d10e6c7be11f7b317af25aa0f5c0f';

/// Count of in-progress applications

@ProviderFor(pendingApplicationsCount)
final pendingApplicationsCountProvider = PendingApplicationsCountProvider._();

/// Count of in-progress applications

final class PendingApplicationsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Count of in-progress applications
  PendingApplicationsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingApplicationsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingApplicationsCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return pendingApplicationsCount(ref);
  }
}

String _$pendingApplicationsCountHash() =>
    r'f2039aeb599a543f2cb77dbf56ca8b974a99d276';

/// Count of upcoming confirmed appointments

@ProviderFor(upcomingAppointmentsCount)
final upcomingAppointmentsCountProvider = UpcomingAppointmentsCountProvider._();

/// Count of upcoming confirmed appointments

final class UpcomingAppointmentsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Count of upcoming confirmed appointments
  UpcomingAppointmentsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingAppointmentsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingAppointmentsCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return upcomingAppointmentsCount(ref);
  }
}

String _$upcomingAppointmentsCountHash() =>
    r'a3495571eaac4760e10258af4bf4b4645a091287';
