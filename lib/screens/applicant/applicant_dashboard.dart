import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../global/widgets/app_button.dart';

class ApplicantDashboard extends ConsumerWidget {
  const ApplicantDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Dashboard'),
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
              'Welcome, ${user?.displayName ?? 'Applicant'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Applications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Expanded(
              child: Center(child: Text('You have no active applications.')),
            ),
            AppButton(
              label: 'Start New Application',
              onPressed: () {
                // Navigate to pre-registration
              },
            ),
          ],
        ),
      ),
    );
  }
}
