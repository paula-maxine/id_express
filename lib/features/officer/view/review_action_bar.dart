import '../../../app_exporter.dart';

/// Action bar at the bottom of the officer review screen
class ReviewActionBar extends ConsumerWidget {
  /// Creates the review action bar
  const ReviewActionBar({required this.application, super.key});

  /// The application under review
  final ApplicationModel application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(reviewActionLoadingProvider);

    if (application.status == ApplicationStatus.approved ||
        application.status == ApplicationStatus.biometricCaptured ||
        application.status == ApplicationStatus.idReady ||
        application.status == ApplicationStatus.completed) {
      return _ReadOnlyStatus(status: application.status);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        spacing16,
        spacing12,
        spacing16,
        spacing24,
      ),
      decoration: BoxDecoration(
        color: surfaceWhite,
        border: Border(top: BorderSide(color: borderLight)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (application.status == ApplicationStatus.approved)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading
                    ? null
                    : () => _markBiometrics(context, ref),
                icon: const Icon(Icons.fingerprint_rounded),
                label: const Text('Mark Biometrics Captured'),
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => _showRejectDialog(context, ref),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: errorRed,
                      side: const BorderSide(color: errorRed),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: spacing12),
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading ? null : () => _approve(context, ref),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: whiteColor,
                            ),
                          )
                        : const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    ref.read(reviewActionLoadingProvider.notifier).set(true);
    ref.read(reviewActionErrorProvider.notifier).clear();
    try {
      await ref
          .read(officerReviewServiceProvider)
          .approve(
            applicationId: application.applicationId,
            notes: ref.read(officerNotesProvider),
          );
      if (context.mounted) context.pop();
    } catch (e) {
      ref.read(reviewActionErrorProvider.notifier).set('Approval failed.');
    } finally {
      ref.read(reviewActionLoadingProvider.notifier).set(false);
    }
  }

  Future<void> _showRejectDialog(BuildContext context, WidgetRef ref) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => const RejectReasonDialog(),
    );

    if (reason != null && reason.isNotEmpty && context.mounted) {
      ref.read(reviewActionLoadingProvider.notifier).set(true);
      ref.read(reviewActionErrorProvider.notifier).clear();
      try {
        await ref
            .read(officerReviewServiceProvider)
            .reject(applicationId: application.applicationId, reason: reason);
        if (context.mounted) context.pop();
      } catch (e) {
        ref.read(reviewActionErrorProvider.notifier).set('Rejection failed.');
      } finally {
        ref.read(reviewActionLoadingProvider.notifier).set(false);
      }
    }
  }

  Future<void> _markBiometrics(BuildContext context, WidgetRef ref) async {
    ref.read(reviewActionLoadingProvider.notifier).set(true);
    try {
      await ref
          .read(officerReviewServiceProvider)
          .markBiometricsCaptured(application.applicationId);
      if (context.mounted) context.pop();
    } finally {
      ref.read(reviewActionLoadingProvider.notifier).set(false);
    }
  }
}

class _ReadOnlyStatus extends StatelessWidget {
  const _ReadOnlyStatus({required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(spacing16),
      decoration: BoxDecoration(
        color: successGreen.withValues(alpha: 0.08),
        border: Border(
          top: BorderSide(color: successGreen.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: successGreen),
          const SizedBox(width: spacing8),
          Text(
            'Application ${status.name}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: successGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
