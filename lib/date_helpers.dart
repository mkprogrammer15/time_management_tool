import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime month = DateTime(DateTime.now().year, DateTime.now().month);

String formatDate(DateTime d) =>
    "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";

DateTime? parseDate(String input) {
  final s = input.trim();
  // expects dd.MM.yyyy
  final m = RegExp(r'^(\d{1,2})\.(\d{1,2})\.(\d{4})$').firstMatch(s);
  if (m == null) return null;

  final day = int.tryParse(m.group(1)!);
  final month = int.tryParse(m.group(2)!);
  final year = int.tryParse(m.group(3)!);
  if (day == null || month == null || year == null) return null;

  final d = DateTime(year, month, day);
  if (d.year != year || d.month != month || d.day != day) return null;

  return DateTime(d.year, d.month, d.day);
}

List<DateTime> daysInMonth(DateTime month) {
  final first = DateTime(month.year, month.month, 1);
  final nextMonth = DateTime(month.year, month.month + 1, 1);
  final last = nextMonth.subtract(const Duration(days: 1));

  return List.generate(
    last.day,
    (i) => DateTime(first.year, first.month, i + 1),
  );
}

// final _dateFormatter = DateFormat('dd.MM.yyyy');

// String formatRange(DateTime start, DateTime end) {
//   if (DateUtils.isSameDay(start, end)) {
//     return _dateFormatter.format(start);
//   }
//   return '${_dateFormatter.format(start)} – ${_dateFormatter.format(end)}';
// }
