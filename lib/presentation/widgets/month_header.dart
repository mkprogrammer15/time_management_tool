import 'package:flutter/material.dart';

class MonthHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final String? selectedColleagueName;
  final VoidCallback? onAddTestLeave;

  const MonthHeader({
    super.key,
    required this.month,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
    required this.selectedColleagueName,
    required this.onAddTestLeave,
  });

  @override
  Widget build(BuildContext context) {
    final title = "${_monthName(month.month)} ${month.year}";
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 12),
          IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: onToday, child: const Text("Heute")),
          const Spacer(),
          if (selectedColleagueName != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                "Ausgewählt: $selectedColleagueName",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: onAddTestLeave,
              icon: const Icon(Icons.add),
              label: const Text("Test-Urlaub"),
            ),
          ),
        ],
      ),
    );
  }

  static String _monthName(int m) {
    const names = [
      "Januar",
      "Februar",
      "März",
      "April",
      "Mai",
      "Juni",
      "Juli",
      "August",
      "September",
      "Oktober",
      "November",
      "Dezember",
    ];
    return names[m - 1];
  }
}

/// Day Header Row
class DayHeaderRow extends StatelessWidget {
  final List<DateTime> monthDays;
  final Set<DateTime> holidays;
  final double cellWidth;
  final double height;

  const DayHeaderRow({
    super.key,
    required this.monthDays,
    required this.holidays,
    required this.cellWidth,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: monthDays.map((day) {
          final isWeekend = _isWeekend(day);
          final isHoliday = _containsDay(holidays, day);

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
