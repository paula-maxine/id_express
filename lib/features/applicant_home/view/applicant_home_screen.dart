import '../../../app_exporter.dart';

/// Applicant home screen — dashboard with services and recent applications
class ApplicantHomeScreen extends ConsumerWidget {
  /// Creates the applicant home screen
  const ApplicantHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('ID Express'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(notificationsPath),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => context.push(profilePath),
          ),
        ],
      ),
      body: currentUser.when(
        data: (user) => _HomeBody(displayName: user?.displayName ?? ''),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(availableServicesProvider);
    final applicationsAsync = ref.watch(userApplicationsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(userApplicationsProvider);
        ref.invalidate(pendingApplicationsCountProvider);
        ref.invalidate(upcomingAppointmentsCountProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: horizontalPadding16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: spacing20),
            _GreetingSection(displayName: displayName),
            const SizedBox(height: spacing20),
            const QuickStatsCard(),
            const SizedBox(height: spacing24),
            Text(
              'Our Services',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: spacing12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: spacing12,
                mainAxisSpacing: spacing12,
                childAspectRatio: 0.95,
              ),
              itemCount: services.length,
              itemBuilder: (_, i) => ServiceCard(service: services[i]),
            ),
            const SizedBox(height: spacing24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Applications',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.push(applicationsListPath),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: spacing12),
            applicationsAsync.when(
              data: (applications) {
                if (applications.isEmpty) {
                  return const EmptyState(
                    message:
                        'No applications yet.\nStart by selecting a service above.',
                    icon: Icons.folder_open_rounded,
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: applications.length,
                  separatorBuilder: (_, _) => const SizedBox(height: spacing12),
                  itemBuilder: (_, i) =>
                      RecentApplicationCard(application: applications[i]),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: padding24,
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, _) => const EmptyState(
                message: 'Could not load applications.',
                icon: Icons.error_outline,
              ),
            ),
            const SizedBox(height: spacing32),
          ],
        ),
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    final name = displayName.isEmpty ? 'Guest' : displayName;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning,'
        : hour < 17
        ? 'Good Afternoon,'
        : 'Good Evening,';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: mediumGrey),
        ),
        const SizedBox(height: spacing4),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
      ],
    );
  }
}
