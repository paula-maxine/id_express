import '../../../app_exporter.dart';

/// Screen showing all the user's applications with filter chips
class ApplicationsScreen extends ConsumerWidget {
  /// Creates the applications screen
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredApplicationsProvider);
    final activeFilter = ref.watch(applicationStatusFilterProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('My Applications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(newApplicationPath),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Application'),
      ),
      body: Column(
        children: [
          _FilterBar(activeFilter: activeFilter),
          Expanded(
            child: filtered.when(
              data: (applications) {
                if (applications.isEmpty) {
                  return EmptyState(
                    message: activeFilter == null
                        ? 'No applications yet.\nTap + to create one.'
                        : 'No applications with this status.',
                    icon: Icons.folder_open_rounded,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    spacing16,
                    spacing12,
                    spacing16,
                    spacing80,
                  ),
                  itemCount: applications.length,
                  separatorBuilder: (_, _) => const SizedBox(height: spacing12),
                  itemBuilder: (_, i) =>
                      ApplicationListItem(application: applications[i]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.activeFilter});

  final ApplicationStatus? activeFilter;

  static const _filters = [
    (label: 'All', value: null),
    (label: 'In Progress', value: ApplicationStatus.underReview),
    (label: 'Approved', value: ApplicationStatus.approved),
    (label: 'Completed', value: ApplicationStatus.completed),
    (label: 'Rejected', value: ApplicationStatus.rejected),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: horizontalPadding16,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: spacing8),
        itemBuilder: (_, i) {
          final filter = _filters[i];
          final isSelected = activeFilter == filter.value;

          return FilterChip(
            label: Text(filter.label),
            selected: isSelected,
            onSelected: (_) => ref
                .read(applicationStatusFilterProvider.notifier)
                .set(filter.value),
          );
        },
      ),
    );
  }
}
