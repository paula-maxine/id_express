import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../constants/app_constants.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? iconData;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryBlue,
          disabledBackgroundColor: AppColors.divider,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconData != null) ...[
                    Icon(iconData, color: textColor ?? Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? textColor;

  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? AppColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
