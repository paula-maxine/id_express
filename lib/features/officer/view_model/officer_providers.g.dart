// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'officer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All submitted applications (for officers to review)

@ProviderFor(pendingApplications)
final pendingApplicationsProvider = PendingApplicationsProvider._();

/// All submitted applications (for officers to review)

final class PendingApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationModel>>,
          List<ApplicationModel>,
          Stream<List<ApplicationModel>>
        >
    with
        $FutureModifier<List<ApplicationModel>>,
        $StreamProvider<List<ApplicationModel>> {
  /// All submitted applications (for officers to review)
  PendingApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingApplicationsHash();

  @$internal
  @override
  $StreamProviderElement<List<ApplicationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ApplicationModel>> create(Ref ref) {
    return pendingApplications(ref);
  }
}

String _$pendingApplicationsHash() =>
    r'9b085c35dba41b63ec3be8dcf209f9e2981edea6';

/// Approved applications (for officer/admin visibility)

@ProviderFor(approvedApplications)
final approvedApplicationsProvider = ApprovedApplicationsProvider._();

/// Approved applications (for officer/admin visibility)

final class ApprovedApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationModel>>,
          List<ApplicationModel>,
          Stream<List<ApplicationModel>>
        >
    with
        $FutureModifier<List<ApplicationModel>>,
        $StreamProvider<List<ApplicationModel>> {
  /// Approved applications (for officer/admin visibility)
  ApprovedApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvedApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approvedApplicationsHash();

  @$internal
  @override
  $StreamProviderElement<List<ApplicationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ApplicationModel>> create(Ref ref) {
    return approvedApplications(ref);
  }
}

String _$approvedApplicationsHash() =>
    r'ff2526a59f99cb07c84b3d5f91fa56c621fb878d';

/// Applications assigned to / reviewed by the current officer

@ProviderFor(officerApplications)
final officerApplicationsProvider = OfficerApplicationsProvider._();

/// Applications assigned to / reviewed by the current officer

final class OfficerApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationModel>>,
          List<ApplicationModel>,
          Stream<List<ApplicationModel>>
        >
    with
        $FutureModifier<List<ApplicationModel>>,
        $StreamProvider<List<ApplicationModel>> {
  /// Applications assigned to / reviewed by the current officer
  OfficerApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'officerApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$officerApplicationsHash();

  @$internal
  @override
  $StreamProviderElement<List<ApplicationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ApplicationModel>> create(Ref ref) {
    return officerApplications(ref);
  }
}

String _$officerApplicationsHash() =>
    r'e55e1ab454fe8b8dde5ae7c291b4f1b33aa498f9';

/// Active status filter for officer dashboard

@ProviderFor(OfficerStatusFilter)
final officerStatusFilterProvider = OfficerStatusFilterProvider._();

/// Active status filter for officer dashboard
final class OfficerStatusFilterProvider
    extends $NotifierProvider<OfficerStatusFilter, ApplicationStatus?> {
  /// Active status filter for officer dashboard
  OfficerStatusFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'officerStatusFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$officerStatusFilterHash();

  @$internal
  @override
  OfficerStatusFilter create() => OfficerStatusFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApplicationStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApplicationStatus?>(value),
    );
  }
}

String _$officerStatusFilterHash() =>
    r'aa844484fdb81eb3d935cb8420eb1b37b2c65d21';

/// Active status filter for officer dashboard

abstract class _$OfficerStatusFilter extends $Notifier<ApplicationStatus?> {
  ApplicationStatus? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ApplicationStatus?, ApplicationStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ApplicationStatus?, ApplicationStatus?>,
              ApplicationStatus?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Officer review action — approve or reject

@ProviderFor(ReviewActionLoading)
final reviewActionLoadingProvider = ReviewActionLoadingProvider._();

/// Officer review action — approve or reject
final class ReviewActionLoadingProvider
    extends $NotifierProvider<ReviewActionLoading, bool> {
  /// Officer review action — approve or reject
  ReviewActionLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewActionLoadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewActionLoadingHash();

  @$internal
  @override
  ReviewActionLoading create() => ReviewActionLoading();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reviewActionLoadingHash() =>
    r'b686792b95918bc3712bee8d174d1fcd85cd718c';

/// Officer review action — approve or reject

abstract class _$ReviewActionLoading extends $Notifier<bool> {
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

/// Officer review error

@ProviderFor(ReviewActionError)
final reviewActionErrorProvider = ReviewActionErrorProvider._();

/// Officer review error
final class ReviewActionErrorProvider
    extends $NotifierProvider<ReviewActionError, String> {
  /// Officer review error
  ReviewActionErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewActionErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewActionErrorHash();

  @$internal
  @override
  ReviewActionError create() => ReviewActionError();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$reviewActionErrorHash() => r'39817dd1f721ae072c772e2ed5995af19988b84e';

/// Officer review error

abstract class _$ReviewActionError extends $Notifier<String> {
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

/// Officer rejection reason input

@ProviderFor(RejectionReason)
final rejectionReasonProvider = RejectionReasonProvider._();

/// Officer rejection reason input
final class RejectionReasonProvider
    extends $NotifierProvider<RejectionReason, String> {
  /// Officer rejection reason input
  RejectionReasonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectionReasonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectionReasonHash();

  @$internal
  @override
  RejectionReason create() => RejectionReason();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$rejectionReasonHash() => r'aaedbceed635b82c74e632b37b9d661faaf24f10';

/// Officer rejection reason input

abstract class _$RejectionReason extends $Notifier<String> {
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

/// Officer notes input

@ProviderFor(OfficerNotes)
final officerNotesProvider = OfficerNotesProvider._();

/// Officer notes input
final class OfficerNotesProvider
    extends $NotifierProvider<OfficerNotes, String> {
  /// Officer notes input
  OfficerNotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'officerNotesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$officerNotesHash();

  @$internal
  @override
  OfficerNotes create() => OfficerNotes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$officerNotesHash() => r'3ac148c3baf2517747441682502769c476bc7ba5';

/// Officer notes input

abstract class _$OfficerNotes extends $Notifier<String> {
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
