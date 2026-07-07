// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current Firebase user provider

@ProviderFor(firebaseAuthUser)
final firebaseAuthUserProvider = FirebaseAuthUserProvider._();

/// Current Firebase user provider

final class FirebaseAuthUserProvider
    extends $FunctionalProvider<AsyncValue<User?>, User?, Stream<User?>>
    with $FutureModifier<User?>, $StreamProvider<User?> {
  /// Current Firebase user provider
  FirebaseAuthUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAuthUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthUserHash();

  @$internal
  @override
  $StreamProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<User?> create(Ref ref) {
    return firebaseAuthUser(ref);
  }
}

String _$firebaseAuthUserHash() => r'3b73c75c789be9615006c29fd7cd94f8280dc785';

/// Current app user provider (with full user data)

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Current app user provider (with full user data)

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel?>,
          UserModel?,
          Stream<UserModel?>
        >
    with $FutureModifier<UserModel?>, $StreamProvider<UserModel?> {
  /// Current app user provider (with full user data)
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $StreamProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<UserModel?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'586ec737808605d4e3b4ca7713600aae2a7afc88';

/// User ID provider

@ProviderFor(userId)
final userIdProvider = UserIdProvider._();

/// User ID provider

final class UserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// User ID provider
  UserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return userId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$userIdHash() => r'5ffd2440d67ce7a9edff136ce756418dc1593a11';

/// Email input provider (for login/register)

@ProviderFor(Email)
final emailProvider = EmailProvider._();

/// Email input provider (for login/register)
final class EmailProvider extends $NotifierProvider<Email, String> {
  /// Email input provider (for login/register)
  EmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailHash();

  @$internal
  @override
  Email create() => Email();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$emailHash() => r'c486e511647a5a845f126f9ed1b2cd020254403d';

/// Email input provider (for login/register)

abstract class _$Email extends $Notifier<String> {
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

/// Password input provider (for login/register)

@ProviderFor(Password)
final passwordProvider = PasswordProvider._();

/// Password input provider (for login/register)
final class PasswordProvider extends $NotifierProvider<Password, String> {
  /// Password input provider (for login/register)
  PasswordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordHash();

  @$internal
  @override
  Password create() => Password();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$passwordHash() => r'89eabd5748fc0ea2c0f71d045572da7766473b74';

/// Password input provider (for login/register)

abstract class _$Password extends $Notifier<String> {
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

/// Phone number input provider (for register)

@ProviderFor(PhoneNumber)
final phoneNumberProvider = PhoneNumberProvider._();

/// Phone number input provider (for register)
final class PhoneNumberProvider extends $NotifierProvider<PhoneNumber, String> {
  /// Phone number input provider (for register)
  PhoneNumberProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneNumberProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneNumberHash();

  @$internal
  @override
  PhoneNumber create() => PhoneNumber();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$phoneNumberHash() => r'08d088c6697fe0d753413b0c10cfd7ebdac66c72';

/// Phone number input provider (for register)

abstract class _$PhoneNumber extends $Notifier<String> {
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

/// Display name input provider (for register)

@ProviderFor(DisplayName)
final displayNameProvider = DisplayNameProvider._();

/// Display name input provider (for register)
final class DisplayNameProvider extends $NotifierProvider<DisplayName, String> {
  /// Display name input provider (for register)
  DisplayNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'displayNameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$displayNameHash();

  @$internal
  @override
  DisplayName create() => DisplayName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$displayNameHash() => r'0e762aa1ac12fcbb57dca36093c062b565db0d20';

/// Display name input provider (for register)

abstract class _$DisplayName extends $Notifier<String> {
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

/// OTP code input provider

@ProviderFor(OtpCode)
final otpCodeProvider = OtpCodeProvider._();

/// OTP code input provider
final class OtpCodeProvider extends $NotifierProvider<OtpCode, String> {
  /// OTP code input provider
  OtpCodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpCodeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpCodeHash();

  @$internal
  @override
  OtpCode create() => OtpCode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$otpCodeHash() => r'9bd4f3359f84b867e172d88ee9a23fd35cb3fe2f';

/// OTP code input provider

abstract class _$OtpCode extends $Notifier<String> {
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

/// Auth loading state provider

@ProviderFor(AuthLoading)
final authLoadingProvider = AuthLoadingProvider._();

/// Auth loading state provider
final class AuthLoadingProvider extends $NotifierProvider<AuthLoading, bool> {
  /// Auth loading state provider
  AuthLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLoadingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLoadingHash();

  @$internal
  @override
  AuthLoading create() => AuthLoading();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$authLoadingHash() => r'9d23695801cb92fdab4ee15e7f6324faa5725aed';

/// Auth loading state provider

abstract class _$AuthLoading extends $Notifier<bool> {
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

/// Auth error message provider

@ProviderFor(AuthError)
final authErrorProvider = AuthErrorProvider._();

/// Auth error message provider
final class AuthErrorProvider extends $NotifierProvider<AuthError, String> {
  /// Auth error message provider
  AuthErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authErrorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authErrorHash();

  @$internal
  @override
  AuthError create() => AuthError();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$authErrorHash() => r'505ca310989a489b137130354e42810d97430a1d';

/// Auth error message provider

abstract class _$AuthError extends $Notifier<String> {
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
