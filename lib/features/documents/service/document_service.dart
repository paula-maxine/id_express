import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'document_service.g.dart';

/// Service for uploading and managing application documents
class DocumentService {
  /// Creates the document service
  const DocumentService(this.ref);

  /// Riverpod ref
  final Ref ref;

  /// Uploads a file and creates a document record in Firestore
  Future<DocumentModel> uploadDocument({
    required String applicationId,
    required DocumentType documentType,
    required String filePath,
    required String fileName,
  }) async {
    final uid = ref.read(userIdProvider);
    if (uid == null || uid.isEmpty) {
      throw Exception('User not authenticated');
    }

    final docId = const Uuid().v4();
    final storagePath = 'documents/$uid/$applicationId/$docId-$fileName';

    final fileRef = FirebaseStorage.instance.ref(storagePath);
    final task = fileRef.putFile(File(filePath));

    task.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      ref.read(uploadProgressProvider.notifier).set(progress);
    });

    await task;
    final downloadUrl = await fileRef.getDownloadURL();

    ref.read(uploadProgressProvider.notifier).clear();

    final document = DocumentModel(
      documentId: docId,
      applicationId: applicationId,
      applicantId: uid,
      documentType: documentType,
      fileUrl: downloadUrl,
      fileName: fileName,
      uploadedAt: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('documents')
        .doc(docId)
        .set(document.toMap());

    return document;
  }

  /// Deletes a document record from Firestore (and attempts Storage deletion)
  Future<void> deleteDocument(DocumentModel document) async {
    // Best-effort deletion from storage using the fileUrl
    try {
      await FirebaseStorage.instance.refFromURL(document.fileUrl).delete();
    } catch (_) {
      // Storage deletion is best-effort; proceed to Firestore delete
    }

    await FirebaseFirestore.instance
        .collection('documents')
        .doc(document.documentId)
        .delete();
  }
}

/// Provides the [DocumentService]
@Riverpod(keepAlive: true)
DocumentService documentService(Ref ref) => DocumentService(ref);

/// Stream of documents for a given application
@riverpod
Stream<List<DocumentModel>> applicationDocuments(
  Ref ref,
  String applicationId,
) {
  return FirebaseFirestore.instance
      .collection('documents')
      .where('application_id', isEqualTo: applicationId)
      .snapshots()
      .map((s) => s.docs.map((d) => DocumentModel.fromMap(d.data())).toList());
}

/// Upload progress state (0.0 to 1.0, or null when idle)
@Riverpod(keepAlive: true)
class UploadProgress extends _$UploadProgress {
  @override
  double? build() => null;

  /// Sets the current upload progress
  void set(double v) => state = v;

  /// Clears the upload progress
  void clear() => state = null;
}
