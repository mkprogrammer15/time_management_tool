import 'package:audavis_time_management/domain/entities/leave_entity.dart';
import 'package:flutter/material.dart';

/// A small leave label
class LeaveLabel extends StatelessWidget {
  final LeaveEntry entry;
  const LeaveLabel({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final (icon, baseLabel) = switch (entry.type) {
      LeaveType.vacation => (Icons.beach_access, "U"),
      LeaveType.sick => (Icons.local_hospital, "K"),
    };

    final bg = switch (entry.status) {
      LeaveStatus.approved => Theme.of(context).colorScheme.primaryContainer,
      LeaveStatus.requested => Theme.of(context).colorScheme.tertiaryContainer,
      LeaveStatus.rejected => Theme.of(context).colorScheme.errorContainer,
    };

    final dayTypeLabel = entry.dayType != LeaveDayType.fullDay ? "0,5" : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
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
                Icon(icon, size: 12),
                const SizedBox(width: 2),
                Text(
                  baseLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          entry.dayType == LeaveDayType.fullDay
              ? const SizedBox.shrink()
              : Text(
                  dayTypeLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ],
      ),
    );
  }
}
