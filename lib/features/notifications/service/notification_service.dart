import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'notification_service.g.dart';

/// Provides notification service
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService(ref);

/// Service for opting in to push notifications
class NotificationService {
  /// Creates the notification service
  const NotificationService(this.ref);

  /// Riverpod ref
  final Ref ref;

  /// Requests push notification permission and, if granted, saves the FCM
  /// token to the current user's Firestore document.
  ///
  /// Returns true if permission was granted.
  Future<bool> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!granted) return false;

    final uid = ref.read(userIdProvider);
    if (uid == null || uid.isEmpty) return true;

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return true;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcm_token': token,
      });
    } catch (e, s) {
      Printer.error(
        'Failed to save FCM token',
        tag: 'NotificationService',
        error: e,
        stackTrace: s,
      );
    }

    return true;
  }
}
