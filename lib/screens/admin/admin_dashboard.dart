import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../global/widgets/app_button.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Administrator',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            const Text(
              'System Overview',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Expanded(child: Center(child: Text('No critical alerts.'))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AppButton(label: 'Manage Users', onPressed: () {}),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AppButton(label: 'View System Logs', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
