import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:flutter/material.dart';

class DayHeaderRow extends StatelessWidget {
  final List<DateTime> monthDays;
  final List<HolidayModel> holidays;
  final double cellWidth;
  final double height;

  const DayHeaderRow({
    super.key,
    required this.monthDays,
    required this.holidays,
    required this.cellWidth,
    required this.height,
  });

  Set<DateTime> _toDateSet(List<HolidayModel> holidays) {
    return holidays
        .map((h) => DateTime(h.date.year, h.date.month, h.date.day))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final holidaySet = _toDateSet(holidays);
    return SizedBox(
      height: height,
      child: Row(
        children: monthDays.map((day) {
          final isWeekend = _isWeekend(day);
          final isHoliday = _containsDay(holidaySet, day);

          final bg = _bgForColumn(
            context,
            isWeekend: isWeekend,
            isHoliday: isHoliday,
            isHeader: true,
          );

          return Container(
            width: cellWidth,
            height: height,
            decoration: BoxDecoration(
              color: bg,
              border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _weekdayShort(day.weekday),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  "${day.day}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  static bool _isWeekend(DateTime d) =>
      d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;

  static bool _containsDay(Set<DateTime> set, DateTime d) =>
      set.any((x) => x.year == d.year && x.month == d.month && x.day == d.day);

  static String _weekdayShort(int weekday) {
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

  static Color _bgForColumn(
    BuildContext context, {
    required bool isWeekend,
    required bool isHoliday,
    required bool isHeader,
  }) {
    final base = Theme.of(context).colorScheme.surface;
    if (isHoliday) {
      return Theme.of(
        context,
      ).colorScheme.errorContainer.withAlpha(isHeader ? 125 : 25);
    }
    if (isWeekend) {
      return Theme.of(
        context,
      ).colorScheme.secondaryContainer.withAlpha(isHeader ? 125 : 25);
    }
    return base;
  }
}
