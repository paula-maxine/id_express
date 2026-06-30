import '../../../app_exporter.dart';

/// User profile screen with account details and sign-out
class ProfileScreen extends ConsumerWidget {
  /// Creates the profile screen
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: currentUser.when(
        data: (user) {
          if (user == null) {
            return const EmptyState(
              message: 'User not found.',
              icon: Icons.person_off_outlined,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(spacing16),
            child: Column(
              children: [
                _ProfileAvatar(user: user),
                const SizedBox(height: spacing24),
                _ProfileInfoCard(user: user),
                const SizedBox(height: spacing24),
                _AccountActions(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: facebookBlue.withValues(alpha: 0.1),
          child: user.photoUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    user.photoUrl,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                )
              : Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: facebookBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: spacing12),
        Text(
          user.displayName,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: spacing4),
        Text(
          user.email,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: mediumGrey),
        ),
        const SizedBox(height: spacing8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing12,
            vertical: spacing6,
          ),
          decoration: BoxDecoration(
            color: facebookBlue.withValues(alpha: 0.1),
            borderRadius: borderRadius4,
          ),
          child: Text(
            user.role.name[0].toUpperCase() + user.role.name.substring(1),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: facebookBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding16,
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: borderRadius8,
        border: Border.all(color: borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: mediumGrey,
            ),
          ),
          const SizedBox(height: spacing12),
          _InfoRow(label: 'Full Name', value: user.displayName),
          const SizedBox(height: spacing8),
          _InfoRow(label: 'Email', value: user.email),
          if (user.phoneNumber.isNotEmpty) ...[
            const SizedBox(height: spacing8),
            _InfoRow(label: 'Phone', value: user.phoneNumber),
          ],
          if (user.nin.isNotEmpty) ...[
            const SizedBox(height: spacing8),
            _InfoRow(label: 'NIN', value: user.nin),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: mediumGrey),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _AccountActions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _ActionTile(
          icon: Icons.lock_outline_rounded,
          label: 'Change Password',
          onTap: () {
            // Navigate to change password
          },
        ),
        const SizedBox(height: spacing8),
        _ActionTile(
          icon: Icons.logout_rounded,
          label: 'Sign Out',
          color: errorRed,
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Sign Out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(backgroundColor: errorRed),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            );

            if (confirmed == true && context.mounted) {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.go(welcomePath);
            }
          },
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? textPrimary;

    return Material(
      color: surfaceWhite,
      borderRadius: borderRadius8,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius8,
        child: Container(
          padding: padding16,
          decoration: BoxDecoration(
            border: Border.all(color: borderLight),
            borderRadius: borderRadius8,
          ),
          child: Row(
            children: [
              Icon(icon, color: tileColor, size: iconSizeMedium),
              const SizedBox(width: spacing12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: tileColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: mediumGrey),
            ],
          ),
        ),
      ),
    );
  }
}
