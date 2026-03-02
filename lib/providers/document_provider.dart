import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/document_model.dart';
import 'service_providers.dart';

// Documents for an application
final documentsProvider =
    FutureProvider.family<List<DocumentModel>, String>((ref, appId) async {
  final docService = ref.watch(documentCloudServiceProvider);
  return docService.getDocumentsByApplication(appId);
});

// Stream documents for an application
final documentsStreamProvider =
    StreamProvider.family<List<DocumentModel>, String>((ref, appId) {
  final docService = ref.watch(documentCloudServiceProvider);
  return docService.streamDocumentsByApplication(appId);
});
