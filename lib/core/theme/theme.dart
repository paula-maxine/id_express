import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'colors.dart';
import 'text_styles.dart';

/// Provides the app theme
final appThemeProvider = Provider<ThemeData>((ref) => AppTheme.light);

/// App theme configuration
class AppTheme {
  /// Light theme
  static ThemeData get light {
    final textTheme = ThemeData.light().textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: facebookBlue,
      scaffoldBackgroundColor: backgroundColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      //* AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: whiteColor,
        foregroundColor: textPrimary,
        titleTextStyle: semiBoldTextStyle.copyWith(
          fontSize: 18,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),

      //* Card
      cardTheme: const CardThemeData(
        elevation: 0,
        color: whiteColor,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      //* Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: facebookBlue,
          foregroundColor: textOnPrimary,
          disabledBackgroundColor: lightGrey,
          disabledForegroundColor: mediumGrey,
          textStyle: buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(),
        ),
      ),

      //* Filled Button
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: facebookBlue,
          foregroundColor: textOnPrimary,
          disabledBackgroundColor: lightGrey,
          disabledForegroundColor: mediumGrey,
          textStyle: buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(),
        ),
      ),

      //* Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: facebookBlue,
          textStyle: semiBoldTextStyle.copyWith(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const StadiumBorder(),
        ),
      ),

      //* Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: facebookBlue,
          side: const BorderSide(color: facebookBlue, width: 1.5),
          textStyle: semiBoldTextStyle.copyWith(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(),
        ),
      ),

      //* Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: whiteColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: lightGrey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: facebookBlue, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: errorRed, width: 1.5),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: errorRed, width: 2),
        ),
        hintStyle: regularTextStyle.copyWith(fontSize: 14, color: mediumGrey),
        labelStyle: regularTextStyle.copyWith(fontSize: 14, color: textPrimary),
      ),

      //* Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return facebookBlue;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(textOnPrimary),
        side: const BorderSide(color: mediumGrey, width: 1.5),
      ),

      //* Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return facebookBlue;
          }
          return mediumGrey;
        }),
      ),

      //* Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return facebookBlue;
          }
          return lightGrey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return facebookBlue.withValues(alpha: 0.5);
          }
          return mediumGrey.withValues(alpha: 0.3);
        }),
      ),

      //* Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: facebookBlue,
      ),

      //* Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: facebookBlue,
        foregroundColor: textOnPrimary,
        elevation: 0,
      ),

      //* Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: whiteColor,
        selectedItemColor: facebookBlue,
        unselectedItemColor: mediumGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      //* Divider
      dividerTheme: const DividerThemeData(
        color: lightGrey,
        thickness: 1,
        space: 1,
      ),

      //* Text Theme
      textTheme: TextTheme(
        displayLarge: baseFontFunction(textStyle: textTheme.displayLarge),
        displayMedium: baseFontFunction(textStyle: textTheme.displayMedium),
        displaySmall: baseFontFunction(textStyle: textTheme.displaySmall),
        headlineLarge: baseFontFunction(textStyle: textTheme.headlineLarge),
        headlineMedium: baseFontFunction(textStyle: textTheme.headlineMedium),
        headlineSmall: baseFontFunction(textStyle: textTheme.headlineSmall),
        titleLarge: baseFontFunction(textStyle: textTheme.titleLarge),
        titleMedium: baseFontFunction(textStyle: textTheme.titleMedium),
        titleSmall: baseFontFunction(textStyle: textTheme.titleSmall),
        bodyLarge: baseFontFunction(textStyle: textTheme.bodyLarge),
        bodyMedium: baseFontFunction(textStyle: textTheme.bodyMedium),
        bodySmall: baseFontFunction(textStyle: textTheme.bodySmall),
        labelLarge: baseFontFunction(textStyle: textTheme.labelLarge),
        labelMedium: baseFontFunction(textStyle: textTheme.labelMedium),
        labelSmall: baseFontFunction(textStyle: textTheme.labelSmall),
      ),
    );
  }
}
