import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:uuid/uuid.dart';

import '../../services/storage_service.dart';
import '../cloud/application_cloud_service.dart';
import '../cloud/document_cloud_service.dart';
import '../model/application_model.dart';
import '../model/document_model.dart';

class SyncService {
  final ApplicationCloudService _cloudService;
  late final Database _db;
  final _appStore = stringMapStoreFactory.store('pending_applications');
  final _docStore = stringMapStoreFactory.store('pending_documents');
  final _uuid = const Uuid();

  SyncService({ApplicationCloudService? cloudService})
      : _cloudService = cloudService ?? ApplicationCloudService();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _db = await databaseFactoryIo.openDatabase('${dir.path}/id_express.db');
    // start listening to connectivity to auto-sync
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        syncPendingApplications();
      }
    });
  }

  Future<String> queueApplication(ApplicationModel app) async {
    final key = _uuid.v4();
    final record = {
      'local_id': key,
      'application': app.toJson(),
      'queued_at': DateTime.now().toIso8601String(),
    };
    await _appStore.record(key).put(_db, record);
    return key;
  }

  /// Queue a document along with its local image path to upload later.
  Future<String> queueDocument(Map<String, dynamic> documentJson, String filePath) async {
    final key = _uuid.v4();
    final record = {
      'local_id': key,
      'document': documentJson,
      'file_path': filePath,
      'queued_at': DateTime.now().toIso8601String(),
    };
    await _docStore.record(key).put(_db, record);
    return key;
  }

  Future<List<Map<String, dynamic>>> getPendingApplications() async {
    final records = await _appStore.find(_db);
    return records.map((r) => r.value..['record_key'] = r.key).toList();
  }

  Future<List<Map<String, dynamic>>> getPendingDocuments() async {
    final records = await _docStore.find(_db);
    return records.map((r) => r.value..['record_key'] = r.key).toList();
  }

  Future<void> removePendingApplication(String localKey) async {
    await _appStore.record(localKey).delete(_db);
  }

  Future<void> removePendingDocument(String localKey) async {
    await _docStore.record(localKey).delete(_db);
  }

  Future<void> syncPendingApplications() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;

    final pendingApps = await getPendingApplications();
    for (final item in pendingApps) {
      try {
        final json = Map<String, dynamic>.from(item['application']);
        final app = ApplicationModel.fromJson(json);
        // create application in cloud
        await _cloudService.createApplication(app);
        // on success remove local pending
        final key = item['local_id'] as String;
        await removePendingApplication(key);
      } catch (e) {
        // ignore and continue; will retry later
        continue;
      }
    }

    // also sync documents if any
    final pendingDocs = await getPendingDocuments();
    for (final item in pendingDocs) {
      try {
        final docJson = Map<String, dynamic>.from(item['document']);
        final filePath = item['file_path'] as String;
        final document = DocumentModel.fromJson(docJson);
        final file = File(filePath);
        // upload image
        final storage = StorageService();
        final imageUrl = await storage.uploadDocumentImage(
          uid: document.applicationId,
          documentType: document.type,
          imageFile: file,
        );
        final updatedDoc = document.copyWith(
          imageUrl: imageUrl,
          uploadedAt: DateTime.now(),
        );
        final docSvc = DocumentCloudService();
        await docSvc.createDocumentRecord(updatedDoc);
        final key = item['local_id'] as String;
        await removePendingDocument(key);
      } catch (e) {
        continue;
      }
    }
  }
}
