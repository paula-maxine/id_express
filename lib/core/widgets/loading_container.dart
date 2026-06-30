import 'package:flutter/material.dart';

/// Widget that shows loading indicator over its child
class LoadingContainer extends StatelessWidget {
  /// Creates a loading container
  const LoadingContainer({
    required this.child,
    required this.isLoading,
    super.key,
  });

  /// The child widget
  final Widget child;

  /// Whether to show loading indicator
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
