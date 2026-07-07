// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [AppointmentService]

@ProviderFor(appointmentService)
final appointmentServiceProvider = AppointmentServiceProvider._();

/// Provides the [AppointmentService]

final class AppointmentServiceProvider
    extends
        $FunctionalProvider<
          AppointmentService,
          AppointmentService,
          AppointmentService
        >
    with $Provider<AppointmentService> {
  /// Provides the [AppointmentService]
  AppointmentServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentServiceHash();

  @$internal
  @override
  $ProviderElement<AppointmentService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppointmentService create(Ref ref) {
    return appointmentService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppointmentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppointmentService>(value),
    );
  }
}

String _$appointmentServiceHash() =>
    r'166f24cb5815caaca3eae21714d5735bf0eeabcc';

/// Stream of appointments for the current user

@ProviderFor(userAppointments)
final userAppointmentsProvider = UserAppointmentsProvider._();

/// Stream of appointments for the current user

final class UserAppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentModel>>,
          List<AppointmentModel>,
          Stream<List<AppointmentModel>>
        >
    with
        $FutureModifier<List<AppointmentModel>>,
        $StreamProvider<List<AppointmentModel>> {
  /// Stream of appointments for the current user
  UserAppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userAppointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userAppointmentsHash();

  @$internal
  @override
  $StreamProviderElement<List<AppointmentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AppointmentModel>> create(Ref ref) {
    return userAppointments(ref);
  }
}

String _$userAppointmentsHash() => r'321d23f2db2f64cfb1d9b370a36d3729313cd78e';

/// Selected appointment center

@ProviderFor(SelectedCenter)
final selectedCenterProvider = SelectedCenterProvider._();

/// Selected appointment center
final class SelectedCenterProvider
    extends
        $NotifierProvider<
          SelectedCenter,
          ({String address, String id, String name})?
        > {
  /// Selected appointment center
  SelectedCenterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCenterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCenterHash();

  @$internal
  @override
  SelectedCenter create() => SelectedCenter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ({String address, String id, String name})? value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<({String address, String id, String name})?>(
            value,
          ),
    );
  }
}

String _$selectedCenterHash() => r'f71aa9f19b62c4d32eb94c68ab14cc346803861f';

/// Selected appointment center

abstract class _$SelectedCenter
    extends $Notifier<({String address, String id, String name})?> {
  ({String address, String id, String name})? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              ({String address, String id, String name})?,
              ({String address, String id, String name})?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({String address, String id, String name})?,
                ({String address, String id, String name})?
              >,
              ({String address, String id, String name})?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Selected appointment date

@ProviderFor(AppointmentDate)
final appointmentDateProvider = AppointmentDateProvider._();

/// Selected appointment date
final class AppointmentDateProvider
    extends $NotifierProvider<AppointmentDate, DateTime?> {
  /// Selected appointment date
  AppointmentDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentDateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentDateHash();

  @$internal
  @override
  AppointmentDate create() => AppointmentDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$appointmentDateHash() => r'117d6acd673b2e9e1111dddfc869a8750967ada3';

/// Selected appointment date

abstract class _$AppointmentDate extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Selected time slot

@ProviderFor(SelectedTimeSlot)
final selectedTimeSlotProvider = SelectedTimeSlotProvider._();

/// Selected time slot
final class SelectedTimeSlotProvider
    extends $NotifierProvider<SelectedTimeSlot, String> {
  /// Selected time slot
  SelectedTimeSlotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTimeSlotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTimeSlotHash();

  @$internal
  @override
  SelectedTimeSlot create() => SelectedTimeSlot();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedTimeSlotHash() => r'17165e566b4c35167aa104c3abc0213d023cd649';

/// Selected time slot

abstract class _$SelectedTimeSlot extends $Notifier<String> {
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

/// Whether booking is in progress

@ProviderFor(BookingLoading)
final bookingLoadingProvider = BookingLoadingProvider._();

/// Whether booking is in progress
final class BookingLoadingProvider
    extends $NotifierProvider<BookingLoading, bool> {
  /// Whether booking is in progress
  BookingLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingLoadingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingLoadingHash();

  @$internal
  @override
  BookingLoading create() => BookingLoading();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$bookingLoadingHash() => r'6deaa25947cfb49bf77272550a17366059f5d7f1';

/// Whether booking is in progress

abstract class _$BookingLoading extends $Notifier<bool> {
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

/// Booking error message

@ProviderFor(BookingError)
final bookingErrorProvider = BookingErrorProvider._();

/// Booking error message
final class BookingErrorProvider
    extends $NotifierProvider<BookingError, String> {
  /// Booking error message
  BookingErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingErrorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingErrorHash();

  @$internal
  @override
  BookingError create() => BookingError();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$bookingErrorHash() => r'ec2b0504a3b9796d06235948dfffd67f43591f37';

/// Booking error message

abstract class _$BookingError extends $Notifier<String> {
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
