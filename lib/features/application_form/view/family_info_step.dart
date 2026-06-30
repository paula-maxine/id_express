import '../../../app_exporter.dart';

/// Step 2 — Family information
class FamilyInfoStep extends ConsumerStatefulWidget {
  /// Creates the family info step
  const FamilyInfoStep({super.key});

  @override
  ConsumerState<FamilyInfoStep> createState() => _FamilyInfoStepState();
}

class _FamilyInfoStepState extends ConsumerState<FamilyInfoStep> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Family Information',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: spacing4),
          Text(
            'Provide your parents\' names as they appear on official records.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: mediumGrey),
          ),
          const SizedBox(height: spacing24),
          TextFormField(
            initialValue: ref.read(motherNameProvider),
            onChanged: (v) => ref.read(motherNameProvider.notifier).update(v),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: const InputDecoration(labelText: "Mother's Full Name"),
          ),
          const SizedBox(height: spacing16),
          TextFormField(
            initialValue: ref.read(fatherNameProvider),
            onChanged: (v) => ref.read(fatherNameProvider.notifier).update(v),
            decoration: const InputDecoration(
              labelText: "Father's Full Name (optional)",
            ),
          ),
          const SizedBox(height: spacing32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      ref.read(formStepProvider.notifier).previous(),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: spacing12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(formStepProvider.notifier).next();
                    }
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
