import 'package:audavis_time_management/domain/entities/leave_entity.dart';
import 'package:flutter/material.dart';

/// A small leave label
class LeaveLabel extends StatelessWidget {
  final LeaveEntry entry;
  const LeaveLabel({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (entry.type) {
      LeaveType.vacation => (Icons.beach_access, "U"),
      LeaveType.sick => (Icons.local_hospital, "K"),
    };

    final bg = switch (entry.status) {
      LeaveStatus.approved => Theme.of(context).colorScheme.primaryContainer,
      LeaveStatus.requested => Theme.of(context).colorScheme.tertiaryContainer,
      LeaveStatus.rejected => Theme.of(context).colorScheme.errorContainer,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10),
          const SizedBox(width: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
