import '../../../app_exporter.dart';

/// Timeline node for application status tracking
class ApplicationStatusTimeline extends StatelessWidget {
  /// Creates the status timeline
  const ApplicationStatusTimeline({required this.currentStatus, super.key});

  /// Current application status
  final ApplicationStatus currentStatus;

  static const _steps = [
    (
      status: ApplicationStatus.submitted,
      label: 'Submitted',
      icon: Icons.send_rounded,
    ),
    (
      status: ApplicationStatus.underReview,
      label: 'Under Review',
      icon: Icons.manage_search_rounded,
    ),
    (
      status: ApplicationStatus.approved,
      label: 'Approved',
      icon: Icons.check_circle_rounded,
    ),
    (
      status: ApplicationStatus.biometricCaptured,
      label: 'Biometrics',
      icon: Icons.fingerprint_rounded,
    ),
    (
      status: ApplicationStatus.idReady,
      label: 'ID Ready',
      icon: Icons.credit_card_rounded,
    ),
    (
      status: ApplicationStatus.completed,
      label: 'Collected',
      icon: Icons.done_all_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _steps.indexWhere((s) => s.status == currentStatus);
    final isRejected = currentStatus == ApplicationStatus.rejected;

    return Column(
      children: List.generate(_steps.length, (i) {
        final step = _steps[i];
        final isDone = currentIndex >= 0 && i <= currentIndex;
        final isActive = i == currentIndex;
        final isLast = i == _steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRejected && isActive
                          ? errorRed
                          : isDone
                          ? facebookBlue
                          : lightGrey,
                    ),
                    child: Icon(
                      isRejected && isActive ? Icons.cancel_rounded : step.icon,
                      size: 16,
                      color: isDone ? whiteColor : mediumGrey,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 32,
                      color: i < currentIndex ? facebookBlue : lightGrey,
                    ),
                ],
              ),
            ),
            const SizedBox(width: spacing12),
            Padding(
              padding: const EdgeInsets.only(top: spacing6),
              child: Text(
                step.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isDone ? textPrimary : mediumGrey,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// Full application detail screen
class ApplicationDetailScreen extends ConsumerWidget {
  /// Creates the application detail screen
  const ApplicationDetailScreen({required this.applicationId, super.key});

  /// ID of the application to display
  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync = ref.watch(
      applicationDetailProvider(applicationId),
    );

    final application = applicationAsync.value;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Application Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      // Pin the primary action to the bottom so the user never has to scroll
      // to reach it. Only shown for the relevant application states.
      bottomNavigationBar: application != null
          ? _DetailActionBar(application: application)
          : null,
      body: applicationAsync.when(
        data: (application) {
          if (application == null) {
            return const EmptyState(
              message: 'Application not found.',
              icon: Icons.search_off_rounded,
            );
          }
          return _DetailBody(application: application);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

/// Pinned bottom action bar for the application detail screen.
///
/// Surfaces the primary action for the application's current state without
/// requiring the user to scroll: schedule a booking when approved, or upload
/// documents when a draft/rejected application still needs them.
class _DetailActionBar extends StatelessWidget {
  const _DetailActionBar({required this.application});

  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    final Widget? action = switch (application.status) {
      ApplicationStatus.approved => FilledButton.icon(
        onPressed: () => context.push(bookAppointmentPath, extra: application),
        icon: const Icon(Icons.event_available_rounded),
        label: const Text('Schedule Booking'),
      ),
      ApplicationStatus.draft ||
      ApplicationStatus.rejected => FilledButton.icon(
        onPressed: () => context.push(documentsPath, extra: application),
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Upload Documents'),
      ),
      _ => null,
    };

    if (action == null) return const SizedBox.shrink();

    return Material(
      color: surfaceWhite,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(spacing16),
          child: SizedBox(width: double.infinity, child: action),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.application});

  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            title: 'Application Reference',
            child: Text(
              application.applicationId.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: facebookBlue,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: spacing16),
          _InfoCard(
            title: 'Application Progress',
            child: Padding(
              padding: const EdgeInsets.only(top: spacing8),
              child: ApplicationStatusTimeline(
                currentStatus: application.status,
              ),
            ),
          ),
          const SizedBox(height: spacing16),
          _InfoCard(
            title: 'Personal Details',
            child: _DetailGrid(
              items: {
                'Full Name': '${application.firstName} ${application.lastName}',
                'Date of Birth': application.dateOfBirth != null
                    ? '${application.dateOfBirth!.day}/${application.dateOfBirth!.month}/${application.dateOfBirth!.year}'
                    : '-',
                'Gender': application.gender?.name ?? '-',
                'Place of Birth': application.placeOfBirth,
              },
            ),
          ),
          const SizedBox(height: spacing16),
          _InfoCard(
            title: 'Family Details',
            child: _DetailGrid(
              items: {
                "Mother's Name": application.motherName,
                "Father's Name": application.fatherName.isEmpty
                    ? '-'
                    : application.fatherName,
              },
            ),
          ),
          const SizedBox(height: spacing16),
          _InfoCard(
            title: 'Address',
            child: _DetailGrid(
              items: {
                'Current Address': application.currentAddress,
                'District': application.districtOfOrigin,
                'Village/Parish': application.villageOfOrigin,
              },
            ),
          ),
          if (application.status == ApplicationStatus.rejected &&
              application.rejectionReason.isNotEmpty) ...[
            const SizedBox(height: spacing16),
            Container(
              width: double.infinity,
              padding: padding16,
              decoration: BoxDecoration(
                color: errorRed.withValues(alpha: 0.07),
                borderRadius: borderRadius8,
                border: Border.all(color: errorRed.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rejection Reason',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: errorRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: spacing8),
                  Text(application.rejectionReason),
                ],
              ),
            ),
          ],
          if (application.status == ApplicationStatus.approved) ...[
            const SizedBox(height: spacing16),
            Container(
              width: double.infinity,
              padding: padding16,
              decoration: BoxDecoration(
                color: successGreen.withValues(alpha: 0.07),
                borderRadius: borderRadius8,
                border: Border.all(color: successGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: successGreen),
                  const SizedBox(width: spacing12),
                  Expanded(
                    child: Text(
                      'Your application is approved. Tap "Schedule Booking" '
                      'below to book an appointment.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Bottom padding so scrollable content clears the pinned action bar.
          const SizedBox(height: spacing24),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding16,
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: borderRadius8,
        border: Border.all(color: borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: mediumGrey,
            ),
          ),
          const SizedBox(height: spacing12),
          child,
        ],
      ),
    );
  }
}

class _DetailGrid extends StatelessWidget {
  const _DetailGrid({required this.items});

  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: spacing8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  e.key,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                ),
              ),
              Expanded(
                child: Text(
                  e.value.isEmpty ? '-' : e.value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
