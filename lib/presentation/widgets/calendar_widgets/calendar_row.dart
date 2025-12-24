import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/presentation/widgets/leave_widgets/leave_widget.dart';
import 'package:flutter/material.dart';

/// Widget representing a single row in the calendar for a colleague.
class CalendarRow extends StatelessWidget {
  final ColleagueEntity colleague;
  final List<DateTime> monthDays;
  final List<HolidayModel> holidays;
  final List<LeaveEntryEntity> leaves;
  final double cellWidth;
  final double height;
  final String myId;

  final void Function(LeaveEntryEntity entry)? onDeleteLeaveTap;

  const CalendarRow({
    super.key,
    required this.colleague,
    required this.monthDays,
    required this.holidays,
    required this.leaves,
    required this.cellWidth,
    required this.height,
    required this.myId,
    this.onDeleteLeaveTap,
  });

  @override
  Widget build(BuildContext context) {
    final holidaySet = holidays.map((h) => dateOnly(h.date)).toSet();

    return Row(
      children: monthDays.map((day) {
        final dayOnly = dateOnly(day);

        final isWeekend =
            day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

        final isHoliday = holidaySet.contains(dayOnly);

        final entry = findLeaveForDay(leaves, dayOnly);

        final bg = bgForColumn(
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
              : LeaveWidget(entry: entry),
        );

        if (entry == null) return cell;

        return IgnorePointer(
          ignoring: colleague.id != myId,
          child: InkWell(
            onTap: () => onDeleteLeaveTap?.call(entry),
            child: cell,
          ),
        );
      }).toList(),
    );
  }

  /// Get background color for a calendar cell based on whether it's a weekend or holiday.
  static Color bgForColumn(
    BuildContext context, {
    required bool isWeekend,
    required bool isHoliday,
  }) {
    final base = Colors.white;
    if (isHoliday) {
      return Theme.of(context).colorScheme.errorContainer.withAlpha(25);
    }
    if (isWeekend) {
      return Theme.of(context).colorScheme.secondaryContainer.withAlpha(45);
    }
    return base;
  }
}
