// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of all users in the system (admin only)

@ProviderFor(allUsers)
final allUsersProvider = AllUsersProvider._();

/// Stream of all users in the system (admin only)

final class AllUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserModel>>,
          List<UserModel>,
          Stream<List<UserModel>>
        >
    with $FutureModifier<List<UserModel>>, $StreamProvider<List<UserModel>> {
  /// Stream of all users in the system (admin only)
  AllUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allUsersHash();

  @$internal
  @override
  $StreamProviderElement<List<UserModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<UserModel>> create(Ref ref) {
    return allUsers(ref);
  }
}

String _$allUsersHash() => r'1ddf442ef9dc5c93116e0763cdfc1e420c2664b0';

/// Provides the [AdminService]

@ProviderFor(adminService)
final adminServiceProvider = AdminServiceProvider._();

/// Provides the [AdminService]

final class AdminServiceProvider
    extends $FunctionalProvider<AdminService, AdminService, AdminService>
    with $Provider<AdminService> {
  /// Provides the [AdminService]
  AdminServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminServiceHash();

  @$internal
  @override
  $ProviderElement<AdminService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminService create(Ref ref) {
    return adminService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminService>(value),
    );
  }
}

String _$adminServiceHash() => r'e8b2544964b5c2973d34121cd4d676429bef0b0a';
