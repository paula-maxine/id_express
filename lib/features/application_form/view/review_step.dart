import '../../../app_exporter.dart';

/// Step 4 — Review and submit
class ReviewStep extends ConsumerWidget {
  /// Creates the review step
  const ReviewStep({required this.onSubmit, super.key});

  /// Callback when submission is triggered
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(firstNameProvider);
    final middleName = ref.watch(middleNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final dob = ref.watch(dateOfBirthProvider);
    final gender = ref.watch(selectedGenderProvider);
    final placeOfBirth = ref.watch(placeOfBirthProvider);
    final motherName = ref.watch(motherNameProvider);
    final fatherName = ref.watch(fatherNameProvider);
    final currentAddress = ref.watch(currentAddressProvider);
    final district = ref.watch(districtOfOriginProvider);
    final village = ref.watch(villageOfOriginProvider);
    final isSubmitting = ref.watch(formSubmittingProvider);
    final error = ref.watch(formErrorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Details',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: spacing4),
        Text(
          'Please review before submitting. You can go back to make changes.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: mediumGrey),
        ),
        const SizedBox(height: spacing24),
        _ReviewSection(
          title: 'Personal Information',
          items: {
            'Full Name': [
              firstName,
              middleName,
              lastName,
            ].where((s) => s.isNotEmpty).join(' '),
            'Date of Birth': dob != null
                ? '${dob.day}/${dob.month}/${dob.year}'
                : '-',
            'Gender': gender != null
                ? gender.name[0].toUpperCase() + gender.name.substring(1)
                : '-',
            'Place of Birth': placeOfBirth,
          },
        ),
        const SizedBox(height: spacing16),
        _ReviewSection(
          title: 'Family Information',
          items: {
            "Mother's Name": motherName,
            "Father's Name": fatherName.isEmpty ? '-' : fatherName,
          },
        ),
        const SizedBox(height: spacing16),
        _ReviewSection(
          title: 'Address Information',
          items: {
            'Current Address': currentAddress,
            'District of Origin': district,
            'Village/Parish': village,
          },
        ),
        if (error.isNotEmpty) ...[
          const SizedBox(height: spacing16),
          Container(
            padding: padding16,
            decoration: BoxDecoration(
              color: errorRed.withValues(alpha: 0.1),
              borderRadius: borderRadius8,
              border: Border.all(color: errorRed.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: errorRed,
                  size: iconSizeMedium,
                ),
                const SizedBox(width: spacing8),
                Expanded(
                  child: Text(
                    error,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: errorRed),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: spacing32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isSubmitting
                    ? null
                    : () => ref.read(formStepProvider.notifier).previous(),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: spacing12),
            Expanded(
              child: FilledButton(
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: whiteColor,
                        ),
                      )
                    : const Text('Submit Application'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.title, required this.items});

  final String title;
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
              color: facebookBlue,
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
                    width: 130,
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
