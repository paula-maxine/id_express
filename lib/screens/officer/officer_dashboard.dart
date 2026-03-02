import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../global/widgets/app_button.dart';

class OfficerDashboard extends ConsumerWidget {
  const OfficerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Officer Dashboard'),
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
              'Welcome, Enrollment Officer',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            const Text(
              'Pending Verifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Expanded(
              child: Center(child: Text('No pending applications for review.')),
            ),
            AppButton(
              label: 'View All Applications',
              onPressed: () {
                // Navigate to applications list
              },
            ),
          ],
        ),
      ),
    );
  }
}
