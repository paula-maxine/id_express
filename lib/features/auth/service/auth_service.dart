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

      if (!userDoc.exists) return null;

      return UserModel.fromMap(userDoc.data() ?? {});
    } on FirebaseAuthException catch (e) {
      Printer.error('Sign in error', error: e);
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
    } on FirebaseAuthException catch (e) {
      Printer.error('Register error', error: e);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.userId).update(user.toMap());
  }
}
