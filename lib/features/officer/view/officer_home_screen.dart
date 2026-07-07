import '../../../app_exporter.dart';

/// Officer home/dashboard screen
class OfficerHomeScreen extends ConsumerWidget {
  /// Creates the officer home screen
  const OfficerHomeScreen({super.key});

  static const _filters = [
    (label: 'All Pending', value: null),
    (label: 'New', value: ApplicationStatus.submitted),
    (label: 'In Review', value: ApplicationStatus.underReview),
    (label: 'Approved', value: ApplicationStatus.approved),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(officerStatusFilterProvider);
    final isApprovedFilter = activeFilter == ApplicationStatus.approved;
    final applicationsAsync = isApprovedFilter
        ? ref.watch(approvedApplicationsProvider)
        : ref.watch(pendingApplicationsProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final isAdmin = currentUser?.role == UserRole.admin;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Officer Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.people_outline_rounded),
              tooltip: 'Manage Users',
              onPressed: () => context.push(adminManageUsersPath),
            ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => context.push(profilePath),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              spacing16,
              spacing16,
              spacing16,
              spacing8,
            ),
            child: const OfficerStatsCard(),
          ),
          _FilterChips(filters: _filters, activeFilter: activeFilter),
          Expanded(
            child: applicationsAsync.when(
              data: (applications) {
                final filtered = isApprovedFilter || activeFilter == null
                    ? applications
                    : applications
                          .where((a) => a.status == activeFilter)
                          .toList();

                if (filtered.isEmpty) {
                  return EmptyState(
                    message: isApprovedFilter
                        ? 'No approved applications.'
                        : 'No pending applications.',
                    icon: Icons.check_circle_outline_rounded,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => isApprovedFilter
                      ? ref.invalidate(approvedApplicationsProvider)
                      : ref.invalidate(pendingApplicationsProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(spacing16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: spacing12),
                    itemBuilder: (_, i) =>
                        OfficerApplicationTile(application: filtered[i]),
                  ),
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

class _FilterChips extends ConsumerWidget {
  const _FilterChips({required this.filters, required this.activeFilter});

  final List<({String label, ApplicationStatus? value})> filters;
  final ApplicationStatus? activeFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: horizontalPadding16,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: spacing8),
        itemBuilder: (_, i) {
          final f = filters[i];
          return FilterChip(
            label: Text(f.label),
            selected: activeFilter == f.value,
            onSelected: (_) =>
                ref.read(officerStatusFilterProvider.notifier).set(f.value),
          );
        },
      ),
    );
  }
}
