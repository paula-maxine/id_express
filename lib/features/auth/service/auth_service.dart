import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'auth_service.g.dart';

/// Provides auth service
@Riverpod(keepAlive: true)
AuthService authService(Ref ref) => AuthService(ref);

/// Auth service for Firebase authentication
class AuthService {
  /// Creates auth service
  const AuthService(this.ref);

  /// Riverpod ref
  final Ref ref;

  /// Firebase Auth instance
  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Firestore instance
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  /// Sign in with email and password.
  ///
  /// Authenticates against Firebase Auth, then simply *reads* the user's
  /// profile from Firestore (looked up by their auth uid) and returns it.
  /// Login is read-only: an existing profile is never overwritten. A profile
  /// document is only created for a brand-new user that has no record yet.
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = userCredential.user;
      if (authUser == null) return null;

      // Look the user up by their auth uid (the document id).
      final userDoc = await _firestore
          .collection('users')
          .doc(authUser.uid)
          .get();

      if (userDoc.exists) {
        // Found — return their stored info as-is. Do NOT write anything.
        return UserModel.fromMap(userDoc.data() ?? {});
      }

      // Genuinely new user with no profile yet — create one once.
      final user = UserModel(
        userId: authUser.uid,
        email: authUser.email ?? email,
        phoneNumber: authUser.phoneNumber ?? '',
        displayName: authUser.displayName ?? '',
        role: UserRole.applicant,
        isEmailVerified: authUser.emailVerified,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(user.userId).set(user.toMap());
      return user;
    } on FirebaseAuthException catch (e, s) {
      Printer.error(
        'Sign in error',
        tag: 'AuthService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    } catch (e, s) {
      Printer.error(
        'Unexpected sign in error',
        tag: 'AuthService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Register with email and password
  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String phoneNumber,
    required String displayName,
    UserRole role = UserRole.applicant,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = userCredential.user;
      if (authUser == null) return null;

      // Create user document in Firestore
      final user = UserModel(
        userId: authUser.uid,
        email: email,
        phoneNumber: phoneNumber,
        displayName: displayName,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await _firestore
            .collection('users')
            .doc(user.userId)
            .set(user.toMap());
      } catch (e, s) {
        // The auth account was created but we could not persist the profile.
        // Roll it back so we don't leave an orphaned account that can log in
        // but has no profile document.
        Printer.error(
          'Failed to write user profile; rolling back auth account',
          tag: 'AuthService',
          error: e,
          stackTrace: s,
        );
        try {
          await authUser.delete();
        } catch (_) {
          // Best-effort cleanup; ignore if it fails.
        }
        rethrow;
      }

      return user;
    } on FirebaseAuthException catch (e, s) {
      Printer.error('Register error', tag: 'AuthService', error: e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      Printer.error(
        'Unexpected register error',
        tag: 'AuthService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, s) {
      Printer.error('Sign out error', tag: 'AuthService', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e, s) {
      Printer.error(
        'Password reset email error',
        tag: 'AuthService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.userId)
          .update(user.toMap());
    } catch (e, s) {
      Printer.error(
        'Update user profile error',
        tag: 'AuthService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
