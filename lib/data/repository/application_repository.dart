import 'package:connectivity_plus/connectivity_plus.dart';

import '../cloud/application_cloud_service.dart';
import '../local/sync_service.dart';
import '../model/application_model.dart';

class ApplicationRepository {
  final ApplicationCloudService _cloud;
  final SyncService _sync;

  ApplicationRepository({ApplicationCloudService? cloud, SyncService? sync})
      : _cloud = cloud ?? ApplicationCloudService(),
        _sync = sync ?? SyncService();

  /// Initialize local sync service (call during app startup)
  Future<void> init() async {
    await _sync.init();
  }

  /// Create application: if offline queue locally, otherwise send to cloud
  Future<ApplicationModel> createApplication(ApplicationModel app) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      // queue locally and return the original model
      await _sync.queueApplication(app);
      return app;
    }

    // online: create directly in cloud
    return _cloud.createApplication(app);
  }

  /// Force a sync of pending items
  Future<void> syncPending() async {
    await _sync.syncPendingApplications();
  }
}
