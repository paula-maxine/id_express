import 'package:intl/intl.dart';

/// Extension on DateTime
extension DateTimeX on DateTime {
  /// Format as "Monday, 14 June 2026"
  String get format => DateFormat('EEEE, dd MMMM yyyy').format(this);

  /// Format as "14 Jun 2026"
  String get shortFormat => DateFormat('dd MMM yyyy').format(this);

  /// Format as "14/06/2026"
  String get slashFormat => DateFormat('dd/MM/yyyy').format(this);

  /// Format as "14-06-2026"
  String get dashFormat => DateFormat('dd-MM-yyyy').format(this);

  /// Format as "Mon, 14 Jun"
  String get dayMonth => DateFormat('EEE, dd MMM').format(this);

  /// Format as "14 Jun • 3:00 PM"
  String get dateTime => DateFormat('dd MMM • h:mm a').format(this);

  /// Format as "3:00 PM"
  String get time => DateFormat('h:mm a').format(this);

  /// Format as "Today", "Yesterday", or date
  String get relative {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(year, month, day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return shortFormat;
    }
  }

  /// Returns true if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns true if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Returns true if date is in the future
  bool get isFuture => isAfter(DateTime.now());
}
