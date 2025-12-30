import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';

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

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

LeaveEntryEntity? findLeaveForDay(List<LeaveEntryEntity> leaves, DateTime day) {
  for (final e in leaves) {
    if (e.containsDay(day)) return e;
  }
  return null;
}

DateTime get todayOnly {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

bool isThisWeekend(DateTime d) =>
    d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;

bool containsDay(Set<DateTime> set, DateTime d) =>
    set.any((x) => x.year == d.year && x.month == d.month && x.day == d.day);

String weekdayShort(int weekday) {
  const map = {
    DateTime.monday: "Mo",
    DateTime.tuesday: "Di",
    DateTime.wednesday: "Mi",
    DateTime.thursday: "Do",
    DateTime.friday: "Fr",
    DateTime.saturday: "Sa",
    DateTime.sunday: "So",
  };
  return map[weekday] ?? "";
}

bool isPastEntry(LeaveEntryEntity entry) {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day); // 00:00 heute

  // Wenn der Eintrag komplett vor heute endet, ist er "Vergangenheit"
  // -> gestern oder früher
  return entry.start.isBefore(todayStart);
}

// Logic for blocking new vacation requests if out of limit
int inclusiveDays(DateTime from, DateTime to) {
  final f = DateTime(from.year, from.month, from.day);
  final t = DateTime(to.year, to.month, to.day);
  return t.difference(f).inDays + 1; // inclusive
}
