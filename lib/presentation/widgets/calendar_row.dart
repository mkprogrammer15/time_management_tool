import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/domain/entities/leave_entity.dart';
import 'package:audavis_time_management/presentation/widgets/leave_label_widget.dart';
import 'package:flutter/material.dart';

class CalendarRow extends StatelessWidget {
  final ColleagueEntity colleague;
  final List<DateTime> monthDays;
  final Set<DateTime> holidays;
  final List<LeaveEntry> leaves;
  final double cellWidth;
  final double height;

  const CalendarRow({
    super.key,
    required this.colleague,
    required this.monthDays,
    required this.holidays,
    required this.leaves,
    required this.cellWidth,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: monthDays.map((day) {
        final isWeekend =
            day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
        final isHoliday = _containsDay(holidays, day);

        final entry = leaves.firstWhere(
          (e) => e.containsDay(day),
          orElse: () => NoLeave(),
        );

        final bg = _bgForColumn(
          context,
          isWeekend: isWeekend,
          isHoliday: isHoliday,
        );
        final borderColor = Theme.of(context).dividerColor;

        return Container(
          width: cellWidth,
          height: height,
          decoration: BoxDecoration(
            color: bg,
            border: Border(
              right: BorderSide(color: borderColor),
              bottom: BorderSide(color: borderColor),
            ),
          ),
          alignment: Alignment.center,
          child: entry is NoLeave
              ? const SizedBox.shrink()
              : LeaveLabel(entry: entry),
        );
      }).toList(),
    );
  }

  static bool _containsDay(Set<DateTime> set, DateTime d) =>
      set.any((x) => x.year == d.year && x.month == d.month && x.day == d.day);

  static Color _bgForColumn(
    BuildContext context, {
    required bool isWeekend,
    required bool isHoliday,
  }) {
    final base = Theme.of(context).colorScheme.surface;
    if (isHoliday) {
      return Theme.of(context).colorScheme.errorContainer.withAlpha(25);
    }
    if (isWeekend) {
      return Theme.of(context).colorScheme.secondaryContainer.withAlpha(45);
    }
    return base;
  }
}

class NoLeave extends LeaveEntry {
  NoLeave()
    : super(
        colleagueName: "",
        start: _kEpoch,
        end: _kEpoch,
        type: LeaveType.vacation,
        status: LeaveStatus.approved,
      );

  static final DateTime _kEpoch = DateTime(1970, 1, 1);
}
