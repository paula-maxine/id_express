import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/application_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_providers.dart';

class PendingApplicationsScreen extends ConsumerWidget {
  const PendingApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingVerificationsProvider);
    final user = ref.watch(authStateProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Applications')),
      body: pendingAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('No pending applications'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final app = list[i];
              return ListTile(
                title: Text(app.fullName),
                subtitle: Text('Status: ${app.status}'),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await ref
                              .read(applicationCloudServiceProvider)
                              .updateApplicationStatus(app.id, 'underReview',
                                  officerUid: user?.uid ?? '');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          final reasonController = TextEditingController();
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Reject application'),
                              content: TextField(
                                controller: reasonController,
                                decoration:
                                    const InputDecoration(hintText: 'Reason'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx, true);
                                  },
                                  child: const Text('Reject'),
                                ),
                              ],
                            ),
                          );
                          if (reasonController.text.isNotEmpty) {
                            await ref
                                .read(applicationCloudServiceProvider)
                                .updateApplicationStatus(app.id, 'rejected',
                                    officerUid: user?.uid ?? '',
                                    rejectionReason: reasonController.text);
                          }
                        },
                      ),
                    ]),
                onTap: () {
                  // maybe open details/edit screen
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
