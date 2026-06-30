import '../../../app_exporter.dart';

/// Screen showing all user notifications
class NotificationsScreen extends ConsumerWidget {
  /// Creates the notifications screen
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyState(
              message: 'No notifications yet.',
              icon: Icons.notifications_none_rounded,
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (_, i) {
              final n = notifications[i];
              return NotificationTile(
                notification: n,
                onTap: () {
                  if (!n.isRead) markNotificationRead(n.notificationId);
                  if (n.applicationId.isNotEmpty && context.mounted) {
                    context.push('/application/${n.applicationId}');
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
