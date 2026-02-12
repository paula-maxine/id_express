import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user profile
  Future<void> saveUserProfile({
    required String uid,
    required String email,
    required String fullName,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'fullName': fullName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error saving user profile: $e';
    }
  }

  // Save document record
  Future<void> saveDocumentRecord({
    required String uid,
    required String documentType,
    required String idNumber,
    required String fullName,
    required String imageUrl,
  }) async {
    try {
      await _firestore.collection('documents').add({
        'uid': uid,
        'documentType': documentType,
        'idNumber': idNumber,
        'fullName': fullName,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      throw 'Error saving document record: $e';
    }
  }

  // Get user documents
  Future<List<Map<String, dynamic>>> getUserDocuments(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('documents')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw 'Error fetching documents: $e';
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Error fetching user profile: $e';
    }
  }
}
