import '../../../app_exporter.dart';

/// Badge displaying the status label of an application
class ApplicationStatusBadge extends StatelessWidget {
  /// Creates an application status badge
  const ApplicationStatusBadge({required this.status, super.key});

  /// The application status to display
  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final label = _label();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: spacing8,
        vertical: spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: borderRadius4,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _color() {
    switch (status) {
      case ApplicationStatus.draft:
        return mediumGrey;
      case ApplicationStatus.submitted:
      case ApplicationStatus.underReview:
        return warningOrange;
      case ApplicationStatus.approved:
      case ApplicationStatus.biometricCaptured:
        return facebookBlue;
      case ApplicationStatus.idReady:
      case ApplicationStatus.completed:
        return successGreen;
      case ApplicationStatus.rejected:
        return errorRed;
      case ApplicationStatus.cancelled:
        return mediumGrey;
    }
  }

  String _label() {
    switch (status) {
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.biometricCaptured:
        return 'Biometrics Done';
      case ApplicationStatus.idReady:
        return 'ID Ready';
      case ApplicationStatus.completed:
        return 'Completed';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.cancelled:
        return 'Cancelled';
    }
  }
}
