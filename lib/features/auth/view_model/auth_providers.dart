import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'auth_providers.g.dart';

/// Current Firebase user provider
@Riverpod(keepAlive: true)
Stream<User?> firebaseAuthUser(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

/// Current app user provider (with full user data)
@Riverpod(keepAlive: true)
Stream<UserModel?> currentUser(Ref ref) {
  final firebaseUser = ref.watch(firebaseAuthUserProvider);

  return firebaseUser.when(
    data: (user) {
      if (user == null) {
        return Stream.value(null);
      }

      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((snapshot) {
            if (!snapshot.exists) return null;
            return UserModel.fromMap(snapshot.data() ?? {});
          });
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
}

/// User ID provider
@Riverpod(keepAlive: true)
String? userId(Ref ref) {
  final firebaseUser = ref.watch(firebaseAuthUserProvider);
  return firebaseUser.value?.uid;
}

/// Email input provider (for login/register)
@Riverpod(keepAlive: true)
class Email extends _$Email {
  @override
  String build() => '';

  /// Update email
  void update(String value) => state = value;

  /// Clear email
  void clear() => state = '';
}

/// Password input provider (for login/register)
@Riverpod(keepAlive: true)
class Password extends _$Password {
  @override
  String build() => '';

  /// Update password
  void update(String value) => state = value;

  /// Clear password
  void clear() => state = '';
}

/// Phone number input provider (for register)
@Riverpod(keepAlive: true)
class PhoneNumber extends _$PhoneNumber {
  @override
  String build() => '';

  /// Update phone number
  void update(String value) => state = value;

  /// Clear phone number
  void clear() => state = '';
}

/// Display name input provider (for register)
@Riverpod(keepAlive: true)
class DisplayName extends _$DisplayName {
  @override
  String build() => '';

  /// Update display name
  void update(String value) => state = value;

  /// Clear display name
  void clear() => state = '';
}

/// OTP code input provider
@Riverpod(keepAlive: true)
class OtpCode extends _$OtpCode {
  @override
  String build() => '';

  /// Update OTP code
  void update(String value) => state = value;

  /// Clear OTP code
  void clear() => state = '';
}

/// Auth loading state provider
@Riverpod(keepAlive: true)
class AuthLoading extends _$AuthLoading {
  @override
  bool build() => false;

  /// Set loading state
  void set(bool value) => state = value;
}

/// Auth error message provider
@Riverpod(keepAlive: true)
class AuthError extends _$AuthError {
  @override
  String build() => '';

  /// Set error message
  void set(String value) => state = value;

  /// Clear error message
  void clear() => state = '';
}
