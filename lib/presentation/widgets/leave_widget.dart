import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:flutter/material.dart';

/// A small leave label
class LeaveWidget extends StatelessWidget {
  final LeaveEntryEntity entry;
  const LeaveWidget({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final (icon, baseLabel) = switch (entry.type) {
      LeaveType.vacation => (Icons.beach_access, "U"),
      LeaveType.sick => (Icons.local_hospital, "K"),
    };

    final Color vacationBg = switch (entry.status) {
      LeaveStatus.approved => Colors.green.shade100,
      LeaveStatus.requested => Colors.yellow.shade200,
      LeaveStatus.rejected => Colors.red.shade100,
    };

    final bool isSick = entry.type == LeaveType.sick;

    final dayTypeLabel = entry.dayType != LeaveDayType.fullDay ? "0,5" : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isSick ? Colors.transparent : vacationBg,
        borderRadius: BorderRadius.circular(10),
        border: isSick
            ? Border.all(color: Colors.grey.shade400, width: 1)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: entry.dayType != LeaveDayType.fullDay
                ? const EdgeInsets.only(bottom: 4)
                : EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 12,
                  color: isSick ? Colors.grey.shade700 : null,
                ),
                const SizedBox(width: 2),
                Text(
                  baseLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSick ? Colors.grey.shade700 : null,
                  ),
                ),
              ],
            ),
          ),
          if (entry.dayType != LeaveDayType.fullDay)
            Text(
              dayTypeLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isSick ? Colors.grey.shade700 : null,
              ),
            ),
        ],
      ),
    );
  }
}
