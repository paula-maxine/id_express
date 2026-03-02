import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../services/storage_service.dart';
import '../cloud/document_cloud_service.dart';
import '../local/sync_service.dart';
import '../model/document_model.dart';

class DocumentRepository {
  final DocumentCloudService _cloud;
  final SyncService _sync;
  final StorageService _storage;

  DocumentRepository({
    DocumentCloudService? cloud,
    SyncService? sync,
    StorageService? storage,
  })  : _cloud = cloud ?? DocumentCloudService(),
        _sync = sync ?? SyncService(),
        _storage = storage ?? StorageService();

  Future<void> init() async {
    await _sync.init();
  }

  /// Save document, uploading immediately if online or queueing if offline.
  Future<DocumentModel> saveDocument({
    required DocumentModel document,
    required String localFilePath,
  }) async {
    final conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) {
      await _sync.queueDocument(document.toJson(), localFilePath);
      return document;
    }

    // online path
    final file = File(localFilePath);
    final imageUrl = await _storage.uploadDocumentImage(
      uid: document.applicationId,
      documentType: document.type,
      imageFile: file,
    );
    final updatedDoc = document.copyWith(
      imageUrl: imageUrl,
      uploadedAt: DateTime.now(),
    );
    return _cloud.createDocumentRecord(updatedDoc);
  }

  Future<void> syncPending() async {
    await _sync.syncPendingApplications();
  }
}
