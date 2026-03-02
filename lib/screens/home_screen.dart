import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/paths.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ID Express'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Continue as?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _RoleCard(
              title: 'Applicant',
              icon: Icons.person_outline,
              color: Colors.blue,
              onTap: () => context.push(RoutesPaths.applicantDashboard),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              title: 'Officer',
              icon: Icons.badge_outlined,
              color: Colors.green,
              onTap: () => context.push(RoutesPaths.officerDashboard),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              title: 'Admin',
              icon: Icons.admin_panel_settings_outlined,
              color: Colors.red,
              onTap: () => context.push(RoutesPaths.adminDashboard),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        leading: Icon(icon, size: 40, color: color),
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
