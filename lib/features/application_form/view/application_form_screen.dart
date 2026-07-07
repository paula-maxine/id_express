import '../../../app_exporter.dart';

/// Multi-step application form screen
class ApplicationFormScreen extends ConsumerWidget {
  /// Creates the application form screen
  const ApplicationFormScreen({this.applicationType, super.key});

  /// The application type pre-selected from the home screen
  final ApplicationType? applicationType;

  static const _stepLabels = ['Personal', 'Family', 'Address', 'Review'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(formStepProvider);

    // Set the application type on first build if provided
    if (applicationType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(selectedApplicationTypeProvider.notifier)
            .update(applicationType!);
      });
    }

    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && step > 0) {
          ref.read(formStepProvider.notifier).previous();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('New Application'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (step > 0) {
                ref.read(formStepProvider.notifier).previous();
              } else {
                context.pop();
              }
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                spacing16,
                spacing16,
                spacing16,
                spacing8,
              ),
              child: StepIndicator(
                currentStep: step,
                totalSteps: 4,
                stepLabels: _stepLabels,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: horizontalPadding16,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: spacing16,
                    bottom: spacing32,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(step),
                      child: _buildStep(context, ref, step),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, WidgetRef ref, int step) {
    switch (step) {
      case 0:
        return const PersonalInfoStep();
      case 1:
        return const FamilyInfoStep();
      case 2:
        return const AddressInfoStep();
      case 3:
        return ReviewStep(onSubmit: () => _submitApplication(context, ref));
      default:
        return const PersonalInfoStep();
    }
  }

  Future<void> _submitApplication(BuildContext context, WidgetRef ref) async {
    // Capture notifiers before the async gap so they remain usable even if
    // this widget is unmounted after navigating away on success.
    final submittingNotifier = ref.read(formSubmittingProvider.notifier);
    final errorNotifier = ref.read(formErrorProvider.notifier);

    submittingNotifier.set(true);
    errorNotifier.clear();

    try {
      final id = await ref
          .read(applicationServiceProvider)
          .createApplication(
            applicationType: ref.read(selectedApplicationTypeProvider),
            firstName: ref.read(firstNameProvider),
            middleName: ref.read(middleNameProvider),
            lastName: ref.read(lastNameProvider),
            dateOfBirth: ref.read(dateOfBirthProvider),
            gender: ref.read(selectedGenderProvider),
            placeOfBirth: ref.read(placeOfBirthProvider),
            maritalStatus: ref.read(selectedMaritalStatusProvider),
            occupation: ref.read(occupationProvider),
            motherName: ref.read(motherNameProvider),
            fatherName: ref.read(fatherNameProvider),
            currentAddress: ref.read(currentAddressProvider),
            permanentAddress: ref.read(permanentAddressProvider),
            districtOfOrigin: ref.read(districtOfOriginProvider),
            villageOfOrigin: ref.read(villageOfOriginProvider),
            previousNin: ref.read(previousNinProvider),
          );

      if (id != null && context.mounted) {
        clearApplicationForm(ref);
        context.go('/application/$id');
      }
    } catch (e, s) {
      Printer.error(
        'Application submission failed',
        tag: 'ApplicationForm',
        error: e,
        stackTrace: s,
      );
      errorNotifier.set(
        'Submission failed. Please check your connection and try again.',
      );
    } finally {
      submittingNotifier.set(false);
    }
  }
}
