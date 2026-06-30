import '../../../app_exporter.dart';

/// Step 1 — Personal information
class PersonalInfoStep extends ConsumerStatefulWidget {
  /// Creates the personal info step
  const PersonalInfoStep({super.key});

  @override
  ConsumerState<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends ConsumerState<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: spacing4),
          Text(
            'Enter your details exactly as they appear on your supporting documents.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: mediumGrey),
          ),
          const SizedBox(height: spacing24),
          _buildTextField(
            label: 'First Name',
            initialValue: ref.read(firstNameProvider),
            onChanged: (v) => ref.read(firstNameProvider.notifier).update(v),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: spacing16),
          _buildTextField(
            label: 'Middle Name (optional)',
            initialValue: ref.read(middleNameProvider),
            onChanged: (v) => ref.read(middleNameProvider.notifier).update(v),
          ),
          const SizedBox(height: spacing16),
          _buildTextField(
            label: 'Last Name',
            initialValue: ref.read(lastNameProvider),
            onChanged: (v) => ref.read(lastNameProvider.notifier).update(v),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: spacing16),
          _DateOfBirthField(),
          const SizedBox(height: spacing16),
          _GenderField(),
          const SizedBox(height: spacing16),
          _buildTextField(
            label: 'Place of Birth',
            initialValue: ref.read(placeOfBirthProvider),
            onChanged: (v) => ref.read(placeOfBirthProvider.notifier).update(v),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: spacing16),
          _MaritalStatusField(),
          const SizedBox(height: spacing16),
          _buildTextField(
            label: 'Occupation',
            initialValue: ref.read(occupationProvider),
            onChanged: (v) => ref.read(occupationProvider.notifier).update(v),
          ),
          const SizedBox(height: spacing32),
          SizedBox(
            width: double.infinity,
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
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required void Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _DateOfBirthField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dob = ref.watch(dateOfBirthProvider);

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: dob ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
        );
        if (picked != null) {
          ref.read(dateOfBirthProvider.notifier).update(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          dob != null ? '${dob.day}/${dob.month}/${dob.year}' : 'Select date',
          style: dob != null
              ? Theme.of(context).textTheme.bodyMedium
              : Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: mediumGrey),
        ),
      ),
    );
  }
}

class _GenderField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = ref.watch(selectedGenderProvider);

    return DropdownButtonFormField<Gender>(
      initialValue: gender,
      decoration: const InputDecoration(labelText: 'Gender'),
      items: Gender.values
          .map(
            (g) => DropdownMenuItem(
              value: g,
              child: Text(g.name[0].toUpperCase() + g.name.substring(1)),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) ref.read(selectedGenderProvider.notifier).update(v);
      },
      validator: (v) => v == null ? 'Required' : null,
    );
  }
}

class _MaritalStatusField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(selectedMaritalStatusProvider);

    return DropdownButtonFormField<MaritalStatus>(
      initialValue: status,
      decoration: const InputDecoration(labelText: 'Marital Status'),
      items: MaritalStatus.values
          .map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(s.name[0].toUpperCase() + s.name.substring(1)),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) {
          ref.read(selectedMaritalStatusProvider.notifier).update(v);
        }
      },
    );
  }
}
