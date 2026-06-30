import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'notifications_providers.g.dart';

/// Stream of notifications for the current user
@riverpod
Stream<List<NotificationModel>> userNotifications(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null || uid.isEmpty) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('notifications')
      .where('user_id', isEqualTo: uid)
      .orderBy('created_at', descending: true)
      .limit(50)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => NotificationModel.fromMap(d.data())).toList(),
      );
}

/// Count of unread notifications
@riverpod
Stream<int> unreadNotificationsCount(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null || uid.isEmpty) return Stream.value(0);

  return FirebaseFirestore.instance
      .collection('notifications')
      .where('user_id', isEqualTo: uid)
      .where('is_read', isEqualTo: false)
      .snapshots()
      .map((s) => s.docs.length);
}

/// Marks a notification as read
Future<void> markNotificationRead(String notificationId) => FirebaseFirestore
    .instance
    .collection('notifications')
    .doc(notificationId)
    .update({'is_read': true});
