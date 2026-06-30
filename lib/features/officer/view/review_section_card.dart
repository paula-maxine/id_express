import '../../../app_exporter.dart';

/// A labeled section card for review detail display
class ReviewSectionCard extends StatelessWidget {
  /// Creates a review section card
  const ReviewSectionCard({
    required this.title,
    required this.items,
    super.key,
  });

  /// Section title
  final String title;

  /// Key-value pairs to display
  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ...items.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: spacing8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
