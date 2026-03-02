import 'package:firebase_auth/firebase_auth.dart';
import 'app_exception.dart';

class AuthCloudService {
  final FirebaseAuth _firebaseAuth;

  AuthCloudService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await userCredential.user?.updateProfile(displayName: fullName);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getErrorMessage(e.code),
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AuthException(
        message: 'Sign up failed: $e',
        originalException: e,
      );
    }
  }

  /// Login with email and password
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getErrorMessage(e.code),
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AuthException(
        message: 'Login failed: $e',
        originalException: e,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(
        message: 'Logout failed: $e',
        originalException: e,
      );
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getErrorMessage(e.code),
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AuthException(
        message: 'Password reset failed: $e',
        originalException: e,
      );
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getErrorMessage(e.code),
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AuthException(
        message: 'Password update failed: $e',
        originalException: e,
      );
    }
  }

  /// Get current user
  User? getCurrentUser() => _firebaseAuth.currentUser;

  /// Listen to auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Verify email
  Future<void> verifyEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw AuthException(
        message: 'Email verification failed: $e',
        originalException: e,
      );
    }
  }

  String _getErrorMessage(String code) {
    return switch (code) {
      'user-not-found' => 'User not found',
      'wrong-password' => 'Wrong password',
      'email-already-in-use' => 'Email already in use',
      'invalid-email' => 'Invalid email',
      'weak-password' => 'Password is too weak',
      'operation-not-allowed' => 'Operation not allowed',
      'user-disabled' => 'User account is disabled',
      _ => 'Authentication error: $code',
    };
  }
}
