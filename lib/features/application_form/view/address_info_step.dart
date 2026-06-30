import '../../../app_exporter.dart';

/// Step 3 — Address information
class AddressInfoStep extends ConsumerStatefulWidget {
  /// Creates the address info step
  const AddressInfoStep({super.key});

  @override
  ConsumerState<AddressInfoStep> createState() => _AddressInfoStepState();
}

class _AddressInfoStepState extends ConsumerState<AddressInfoStep> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appType = ref.watch(selectedApplicationTypeProvider);
    final needsPreviousNin =
        appType == ApplicationType.renewal ||
        appType == ApplicationType.replacement ||
        appType == ApplicationType.changeOfParticulars;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address Information',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: spacing4),
          Text(
            'Provide your current and permanent address details.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: mediumGrey),
          ),
          const SizedBox(height: spacing24),
          TextFormField(
            initialValue: ref.read(currentAddressProvider),
            onChanged: (v) =>
                ref.read(currentAddressProvider.notifier).update(v),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: const InputDecoration(labelText: 'Current Address'),
            maxLines: 2,
          ),
          const SizedBox(height: spacing16),
          TextFormField(
            initialValue: ref.read(permanentAddressProvider),
            onChanged: (v) =>
                ref.read(permanentAddressProvider.notifier).update(v),
            decoration: const InputDecoration(
              labelText: 'Permanent Address (if different)',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: spacing16),
          TextFormField(
            initialValue: ref.read(districtOfOriginProvider),
            onChanged: (v) =>
                ref.read(districtOfOriginProvider.notifier).update(v),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: const InputDecoration(labelText: 'District of Origin'),
          ),
          const SizedBox(height: spacing16),
          TextFormField(
            initialValue: ref.read(villageOfOriginProvider),
            onChanged: (v) =>
                ref.read(villageOfOriginProvider.notifier).update(v),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: const InputDecoration(
              labelText: 'Village/Parish of Origin',
            ),
          ),
          if (needsPreviousNin) ...[
            const SizedBox(height: spacing16),
            TextFormField(
              initialValue: ref.read(previousNinProvider),
              onChanged: (v) =>
                  ref.read(previousNinProvider.notifier).update(v),
              validator: (v) =>
                  needsPreviousNin && (v == null || v.trim().isEmpty)
                  ? 'Previous NIN required'
                  : null,
              decoration: const InputDecoration(
                labelText: 'Previous NIN',
                helperText: 'Your existing National Identification Number',
              ),
            ),
          ],
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
                  child: const Text('Review'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
