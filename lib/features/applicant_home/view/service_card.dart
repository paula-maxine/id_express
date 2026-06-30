import '../../../app_exporter.dart';

/// Service card for the applicant home grid
class ServiceCard extends StatelessWidget {
  /// Creates a service card
  const ServiceCard({required this.service, super.key});

  /// The service to display
  final ServiceType service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surfaceWhite,
      borderRadius: borderRadius12,
      child: InkWell(
        onTap: service.isEnabled
            ? () => context.push(
                newApplicationPath,
                extra: service.applicationType,
              )
            : null,
        borderRadius: borderRadius12,
        child: Container(
          padding: padding16,
          decoration: BoxDecoration(
            border: Border.all(color: borderLight),
            borderRadius: borderRadius12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(spacing12),
                decoration: BoxDecoration(
                  color: facebookBlue.withValues(alpha: 0.1),
                  borderRadius: borderRadius12,
                ),
                child: Icon(
                  service.icon,
                  size: iconSizeLarge,
                  color: service.isEnabled ? facebookBlue : mediumGrey,
                ),
              ),
              const SizedBox(height: spacing12),
              Text(
                service.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: service.isEnabled ? textPrimary : mediumGrey,
                ),
              ),
              const SizedBox(height: spacing4),
              Text(
                service.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: mediumGrey, height: 1.3),
              ),
              if (!service.isEnabled) ...[
                const SizedBox(height: spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacing8,
                    vertical: spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: borderRadius4,
                  ),
                  child: Text(
                    'Coming Soon',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: mediumGrey),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
