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
      // Validate file size (max 5 MB) and type
      final int maxBytes = 5 * 1024 * 1024;
      final int fileSize = await imageFile.length();
      if (fileSize > maxBytes) {
        throw 'File too large. Maximum allowed size is 5 MB.';
      }

      final allowedExt = ['jpg', 'jpeg', 'png'];
      final ext = imageFile.path.split('.').last.toLowerCase();
      if (!allowedExt.contains(ext)) {
        throw 'Unsupported file type. Allowed: JPG, JPEG, PNG.';
      }

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
