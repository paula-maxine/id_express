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
    // Capture notifiers/service before the async gap so they remain usable
    // even if this widget is unmounted after popping on success.
    final loadingNotifier = ref.read(reviewActionLoadingProvider.notifier);
    final errorNotifier = ref.read(reviewActionErrorProvider.notifier);
    final reviewService = ref.read(officerReviewServiceProvider);
    final notes = ref.read(officerNotesProvider);

    loadingNotifier.set(true);
    errorNotifier.clear();
    try {
      await reviewService.approve(
        applicationId: application.applicationId,
        notes: notes,
      );
      if (context.mounted) context.pop();
    } catch (e, s) {
      Printer.error(
        'Application approval failed',
        tag: 'ReviewActionBar',
        error: e,
        stackTrace: s,
      );
      errorNotifier.set('Approval failed.');
    } finally {
      loadingNotifier.set(false);
    }
  }

  Future<void> _showRejectDialog(BuildContext context, WidgetRef ref) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => const RejectReasonDialog(),
    );

    if (reason != null && reason.isNotEmpty && context.mounted) {
      // Capture notifiers/service before the async gap so they remain usable
      // even if this widget is unmounted after popping on success.
      final loadingNotifier = ref.read(reviewActionLoadingProvider.notifier);
      final errorNotifier = ref.read(reviewActionErrorProvider.notifier);
      final reviewService = ref.read(officerReviewServiceProvider);

      loadingNotifier.set(true);
      errorNotifier.clear();
      try {
        await reviewService.reject(
          applicationId: application.applicationId,
          reason: reason,
        );
        if (context.mounted) context.pop();
      } catch (e, s) {
        Printer.error(
          'Application rejection failed',
          tag: 'ReviewActionBar',
          error: e,
          stackTrace: s,
        );
        errorNotifier.set('Rejection failed.');
      } finally {
        loadingNotifier.set(false);
      }
    }
  }

  Future<void> _markBiometrics(BuildContext context, WidgetRef ref) async {
    // Capture notifier/service before the async gap so they remain usable
    // even if this widget is unmounted after popping on success.
    final loadingNotifier = ref.read(reviewActionLoadingProvider.notifier);
    final reviewService = ref.read(officerReviewServiceProvider);

    loadingNotifier.set(true);
    try {
      await reviewService.markBiometricsCaptured(application.applicationId);
      if (context.mounted) context.pop();
    } finally {
      loadingNotifier.set(false);
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
