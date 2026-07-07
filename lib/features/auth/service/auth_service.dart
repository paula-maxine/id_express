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

  /// Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      // Fetch user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        final authUser = userCredential.user!;
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

        await _firestore
            .collection('users')
            .doc(user.userId)
            .set(user.toMap());

        return user;
      }

      // Doc exists — but self-heal if it is malformed. A doc missing its
      // `user_id` (or with a mismatched one) makes every ownership rule
      // (`applicant_id == request.auth.uid`) and role lookup fail, locking
      // the user out under the deployed security rules. Repair the identity
      // fields in place without ever escalating the role.
      final data = userDoc.data() ?? {};
      final storedUid = data['user_id'] as String?;
      if (storedUid == null || storedUid != userCredential.user!.uid) {
        final authUser = userCredential.user!;
        final repair = <String, dynamic>{
          'user_id': authUser.uid,
          'email': (data['email'] as String?)?.isNotEmpty == true
              ? data['email']
              : authUser.email ?? email,
          'updated_at': DateTime.now().toIso8601String(),
        };
        // Preserve an existing valid role; only default when absent/empty.
        if ((data['role'] as String?)?.isNotEmpty != true) {
          repair['role'] = UserRole.applicant.name;
        }
        await _firestore
            .collection('users')
            .doc(authUser.uid)
            .set(repair, SetOptions(merge: true));

        Printer.info(
          'Repaired malformed user doc for ${authUser.uid}',
          tag: 'AuthService',
        );

        return UserModel.fromMap({...data, ...repair});
      }

      return UserModel.fromMap(data);
    } on FirebaseAuthException catch (e, s) {
      Printer.error('Sign in error', tag: 'AuthService', error: e, stackTrace: s);
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

      if (userCredential.user == null) return null;

      // Create user document in Firestore
      final user = UserModel(
        userId: userCredential.user!.uid,
        email: email,
        phoneNumber: phoneNumber,
        displayName: displayName,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.userId).set(user.toMap());

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
