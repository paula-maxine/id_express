import 'package:flutter/material.dart';

class NiraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const NiraAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NiraDrawer extends StatelessWidget {
  final String userName;
  final String userRole;
  final VoidCallback onLogout;
  final List<DrawerItem> menuItems;

  const NiraDrawer({
    super.key,
    required this.userName,
    required this.userRole,
    required this.onLogout,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.person),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  userRole,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  onTap: item.onTap,
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class DrawerItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  DrawerItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
