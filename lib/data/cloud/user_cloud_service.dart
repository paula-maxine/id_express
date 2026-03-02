import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
import 'app_exception.dart';

class UserCloudService {
  final FirebaseFirestore _firestore;

  UserCloudService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create a new user in Firestore
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to create user: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to create user: $e',
        originalException: e,
      );
    }
  }

  /// Get user by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch user: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch user: $e',
        originalException: e,
      );
    }
  }

  /// Update user fields
  Future<void> updateUser(String uid, Map<String, dynamic> fields) async {
    try {
      await _firestore.collection('users').doc(uid).update(fields);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to update user: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update user: $e',
        originalException: e,
      );
    }
  }

  /// Get users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('role', isEqualTo: role)
          .get();
      return query.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch users: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch users: $e',
        originalException: e,
      );
    }
  }

  /// Deactivate user
  Future<void> deactivateUser(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'is_active': false});
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to deactivate user: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to deactivate user: $e',
        originalException: e,
      );
    }
  }

  /// Assign role to user
  Future<void> assignRole(String uid, String role) async {
    try {
      await _firestore.collection('users').doc(uid).update({'role': role});
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to assign role: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to assign role: $e',
        originalException: e,
      );
    }
  }

  /// Update user FCM token
  Future<void> updateFcmToken(String uid, String token) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'fcm_token': token});
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to update FCM token: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update FCM token: $e',
        originalException: e,
      );
    }
  }
}
