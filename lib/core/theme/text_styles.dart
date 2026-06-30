import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Base font function
TextStyle baseFontFunction({TextStyle? textStyle}) {
  return GoogleFonts.inter(textStyle: textStyle);
}

/// Base text style
final baseTextStyle = baseFontFunction();

/// Bold text style
final boldTextStyle = baseTextStyle.copyWith(fontWeight: FontWeight.w700);

/// Semi-bold text style
final semiBoldTextStyle = baseTextStyle.copyWith(fontWeight: FontWeight.w600);

/// Medium text style
final mediumTextStyle = baseTextStyle.copyWith(fontWeight: FontWeight.w500);

/// Regular text style
final regularTextStyle = baseTextStyle.copyWith(fontWeight: FontWeight.w400);

/// Light text style
final lightTextStyle = baseTextStyle.copyWith(fontWeight: FontWeight.w300);

/// Headline 1 (32px, bold)
final headline1 = boldTextStyle.copyWith(fontSize: 32, color: textPrimary);

/// Headline 2 (28px, bold)
final headline2 = boldTextStyle.copyWith(fontSize: 28, color: textPrimary);

/// Headline 3 (24px, semi-bold)
final headline3 = semiBoldTextStyle.copyWith(fontSize: 24, color: textPrimary);

/// Title (20px, semi-bold)
final titleStyle = semiBoldTextStyle.copyWith(fontSize: 20, color: textPrimary);

/// Subtitle (18px, medium)
final subtitleStyle = mediumTextStyle.copyWith(
  fontSize: 18,
  color: textPrimary,
);

/// Body large (16px, regular)
final bodyLarge = regularTextStyle.copyWith(fontSize: 16, color: textPrimary);

/// Body medium (14px, regular)
final bodyMedium = regularTextStyle.copyWith(fontSize: 14, color: textPrimary);

/// Body small (12px, regular)
final bodySmall = regularTextStyle.copyWith(fontSize: 12, color: textSecondary);

/// Caption (11px, regular)
final caption = regularTextStyle.copyWith(fontSize: 11, color: textSecondary);

/// Button text (16px, semi-bold)
final buttonText = semiBoldTextStyle.copyWith(
  fontSize: 16,
  color: textOnPrimary,
);
