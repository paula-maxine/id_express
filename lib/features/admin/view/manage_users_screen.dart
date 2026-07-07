import '../../../app_exporter.dart';

/// Admin screen listing all users with role management
class ManageUsersScreen extends ConsumerWidget {
  /// Creates the manage users screen
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);
    final loadingUserId = ref.watch(roleAssignmentLoadingProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Manage Users'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const EmptyState(
              message: 'No users found.',
              icon: Icons.people_outline_rounded,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(spacing16),
            itemCount: users.length,
            separatorBuilder: (_, _) => const SizedBox(height: spacing12),
            itemBuilder: (_, i) {
              final user = users[i];
              return _UserTile(
                user: user,
                isLoading: loadingUserId == user.userId,
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

class _UserTile extends ConsumerWidget {
  const _UserTile({required this.user, required this.isLoading});

  final UserModel user;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: padding16,
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: borderRadius8,
        border: Border.all(color: borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: facebookBlue.withValues(alpha: 0.1),
            child: Text(
              user.displayName.isNotEmpty
                  ? user.displayName[0].toUpperCase()
                  : '?',
              style: TextStyle(color: facebookBlue, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName.isEmpty ? user.email : user.displayName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: spacing4),
                Text(
                  user.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: spacing12),
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            PopupMenuButton<UserRole>(
              initialValue: user.role,
              onSelected: (role) => _confirmAndAssign(context, ref, role),
              itemBuilder: (_) => UserRole.values
                  .map(
                    (role) => PopupMenuItem(
                      value: role,
                      child: Text(_roleLabel(role)),
                    ),
                  )
                  .toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing12,
                  vertical: spacing6,
                ),
                decoration: BoxDecoration(
                  color: facebookBlue.withValues(alpha: 0.1),
                  borderRadius: borderRadius4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _roleLabel(user.role),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: facebookBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: spacing4),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: facebookBlue,
                      size: iconSizeSmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmAndAssign(
    BuildContext context,
    WidgetRef ref,
    UserRole role,
  ) async {
    if (role == user.role) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Role'),
        content: Text(
          'Change ${user.displayName.isEmpty ? user.email : user.displayName} '
          "'s role to ${_roleLabel(role)}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Capture notifier and service before the async gap so they remain usable
    // even if this widget is unmounted (e.g. an admin changing their own role
    // triggers a rebuild/redirect).
    final loadingNotifier = ref.read(roleAssignmentLoadingProvider.notifier);
    final adminService = ref.read(adminServiceProvider);
    final messenger = ScaffoldMessenger.of(context);

    loadingNotifier.set(user.userId);
    try {
      await adminService.assignRole(userId: user.userId, role: role);
    } catch (e, s) {
      Printer.error(
        'Failed to update user role',
        tag: 'ManageUsers',
        error: e,
        stackTrace: s,
      );
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to update role: $e')),
      );
    } finally {
      loadingNotifier.set(null);
    }
  }

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.applicant:
        return 'Applicant';
      case UserRole.officer:
        return 'Officer';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.admin:
        return 'Admin';
    }
  }
}
