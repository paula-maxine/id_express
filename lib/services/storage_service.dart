import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload document image
  Future<String> uploadDocumentImage({
    required String uid,
    required String documentType,
    required File imageFile,
  }) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      String path = 'users/$uid/documents/$documentType/$fileName';

      Reference ref = _storage.ref().child(path);
      await ref.putFile(imageFile);

      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw 'Error uploading image: $e';
    }
  }

  // Delete document image
  Future<void> deleteDocumentImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw 'Error deleting image: $e';
    }
  }
}
