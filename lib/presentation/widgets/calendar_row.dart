import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/presentation/widgets/leave_label_widget.dart';
import 'package:flutter/material.dart';

class CalendarRow extends StatelessWidget {
  final ColleagueEntity colleague;
  final List<DateTime> monthDays;
  final List<HolidayModel> holidays;
  final List<LeaveEntryEntity> leaves;
  final double cellWidth;
  final double height;

  final void Function(LeaveEntryEntity entry)? onDeleteLeaveTap;

  const CalendarRow({
    super.key,
    required this.colleague,
    required this.monthDays,
    required this.holidays,
    required this.leaves,
    required this.cellWidth,
    required this.height,
    this.onDeleteLeaveTap,
  });

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  LeaveEntryEntity? findLeaveForDay(
    List<LeaveEntryEntity> leaves,
    DateTime day,
  ) {
    for (final e in leaves) {
      if (e.containsDay(day)) return e;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final holidaySet = holidays.map((h) => _dateOnly(h.date)).toSet();

    return Row(
      children: monthDays.map((day) {
        final dayOnly = _dateOnly(day);

        final isWeekend =
            day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

        final isHoliday = holidaySet.contains(dayOnly);

        final entry = findLeaveForDay(leaves, dayOnly);

        final bg = _bgForColumn(
          context,
          isWeekend: isWeekend,
          isHoliday: isHoliday,
        );

        final borderColor = Theme.of(context).dividerColor;

        final cell = Container(
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
          child: entry == null
              ? const SizedBox.shrink()
              : LeaveLabel(entry: entry),
        );

        if (entry == null) return cell;

        return InkWell(onTap: () => onDeleteLeaveTap?.call(entry), child: cell);
      }).toList(),
    );
  }

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
