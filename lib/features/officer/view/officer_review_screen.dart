import '../../../app_exporter.dart';

/// Full application review screen for officers
class OfficerReviewScreen extends ConsumerWidget {
  /// Creates the officer review screen
  const OfficerReviewScreen({required this.applicationId, super.key});

  /// The ID of the application to review
  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync = ref.watch(
      applicationDetailProvider(applicationId),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Review Application'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: applicationAsync.when(
        data: (application) {
          if (application == null) {
            return const EmptyState(
              message: 'Application not found.',
              icon: Icons.search_off_rounded,
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ApplicationHeader(application: application),
                      const SizedBox(height: spacing16),
                      _NotesField(),
                      const SizedBox(height: spacing16),
                      ReviewDetailSection(application: application),
                      const SizedBox(height: spacing16),
                    ],
                  ),
                ),
              ),
              ReviewActionBar(application: application),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ApplicationHeader extends StatelessWidget {
  const _ApplicationHeader({required this.application});

  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding16,
      decoration: BoxDecoration(
        color: facebookBlue.withValues(alpha: 0.05),
        borderRadius: borderRadius8,
        border: Border.all(color: facebookBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${application.firstName} ${application.lastName}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: spacing4),
                Text(
                  'Ref: ${application.applicationId.substring(0, 8).toUpperCase()}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: spacing12,
              vertical: spacing8,
            ),
            decoration: BoxDecoration(
              color: facebookBlue.withValues(alpha: 0.1),
              borderRadius: borderRadius8,
            ),
            child: Text(
              _typeLabel(application.applicationType),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: facebookBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(ApplicationType type) {
    switch (type) {
      case ApplicationType.newRegistration:
        return 'New Registration';
      case ApplicationType.renewal:
        return 'Renewal';
      case ApplicationType.replacement:
        return 'Replacement';
      case ApplicationType.changeOfParticulars:
        return 'Change of Particulars';
    }
  }
}

class _NotesField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      onChanged: (v) => ref.read(officerNotesProvider.notifier).update(v),
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: 'Officer Notes (optional)',
        hintText: 'Add internal notes...',
      ),
    );
  }
}
