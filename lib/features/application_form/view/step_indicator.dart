import '../../../app_exporter.dart';

/// Step indicator for the multi-step application form
class StepIndicator extends StatelessWidget {
  /// Creates a step indicator
  const StepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
    super.key,
  });

  /// Zero-indexed current step
  final int currentStep;

  /// Total number of steps
  final int totalSteps;

  /// Label for each step
  final List<String> stepLabels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isDone = i < currentStep;
        final isActive = i == currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDone || isActive ? facebookBlue : lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isDone
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: whiteColor,
                              )
                            : Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: isActive ? whiteColor : mediumGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: spacing4),
                    Text(
                      stepLabels[i],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isActive ? facebookBlue : mediumGrey,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < totalSteps - 1)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: spacing20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 2,
                      color: isDone ? facebookBlue : lightGrey,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
