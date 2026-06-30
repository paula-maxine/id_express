import 'package:intl/intl.dart';

/// Extension on num
extension NumX on num {
  /// Format number with commas
  String get format => NumberFormat('#,##0').format(this);

  /// Format as currency (no symbol)
  String get formatCurrency =>
      NumberFormat.currency(symbol: '', decimalDigits: 0).format(this);

  /// Format as currency with decimals
  String get formatCurrencyWithDecimals =>
      NumberFormat.currency(symbol: '', decimalDigits: 2).format(this);

  /// Check if not zero
  bool get isNotZero => this != 0;

  /// Check if zero
  bool get isZero => this == 0;

  /// Check if positive
  bool get isPositive => this > 0;

  /// Check if negative
  bool get isNegative => this < 0;
}
