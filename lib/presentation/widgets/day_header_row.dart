import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/date_helpers.dart';
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
          final isWeekend = isThisWeekend(day);
          final isHoliday = containsDay(holidaySet, day);

          final bg = bgForColumn(
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
                  weekdayShort(day.weekday),
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

  static Color bgForColumn(
    BuildContext context, {
    required bool isWeekend,
    required bool isHoliday,
    required bool isHeader,
  }) {
    final base = Colors.white;
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
