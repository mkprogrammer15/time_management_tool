import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/presentation/blocs/user_leaves_cubit/user_leaves_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget to display the leaves of a colleague.
class ColleagueLeavesWidget extends StatelessWidget {
  const ColleagueLeavesWidget({required this.colleagueId, super.key});

  final String colleagueId;

  @override
  Widget build(BuildContext context) {
    context.read<UserLeavesCubit>().loadByUserId(colleagueId);
    return BlocBuilder<UserLeavesCubit, UserLeavesState>(
      builder: (context, state) {
        if (state is UserLeavesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLeavesLoaded) {
          final leaves = state.leaves;
          final vacationLeaves =
              leaves.where((l) => l.type == LeaveType.vacation).toList()
                ..sort((a, b) => a.start.compareTo(b.start));

          final sicknessLeaves =
              leaves.where((l) => l.type == LeaveType.sick).toList()
                ..sort((a, b) => a.start.compareTo(b.start));
          return leaves.isEmpty
              ? const Center(child: Text('Keine Abwesenheiten vorhanden'))
              : Expanded(
                  child: ListView(
                    children: [
                      if (vacationLeaves.isNotEmpty) ...[
                        const SectionHeader(title: 'Urlaub'),
                        ...vacationLeaves.map((leave) => LeaveTile(leave)),
                      ],
                      if (sicknessLeaves.isNotEmpty) ...[
                        const SectionHeader(title: 'Krankheit'),
                        ...sicknessLeaves.map((leave) => LeaveTile(leave)),
                      ],
                    ],
                  ),
                );
        } else if (state is UserLeavesError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LeaveTile extends StatelessWidget {
  final LeaveEntryEntity leave;

  const LeaveTile(this.leave, {super.key});

  String getReadableLeaveType(LeaveType type) {
    switch (type) {
      case LeaveType.vacation:
        return 'Urlaub';
      case LeaveType.sick:
        return 'Krankheit';
    }
  }

  String getReadableLeaveStatus(String status) {
    switch (status) {
      case 'requested':
        return 'Ausstehend';
      case 'approved':
        return 'Genehmigt';
      case 'rejected':
        return 'Abgelehnt';
      default:
        return 'requested';
    }
  }

  Icon getLeaveTypeIcon(LeaveType type) {
    switch (type) {
      case LeaveType.vacation:
        return Icon(Icons.beach_access, size: 16, color: Colors.blue.shade300);
      case LeaveType.sick:
        return Icon(
          Icons.medical_services,
          size: 16,
          color: Colors.red.shade300,
        );
    }
  }

  Icon getIconByStatus(String status) {
    switch (status) {
      case 'requested':
        return Icon(Icons.hourglass_empty, size: 16, color: Colors.orange);
      case 'approved':
        return Icon(Icons.check_circle, size: 16, color: Colors.green);
      case 'rejected':
        return Icon(Icons.cancel, size: 16, color: Colors.red);
      default:
        return Icon(Icons.hourglass_empty, size: 16, color: Colors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadSymV8,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        title: Text(
          'Vom ${formatDate(leave.start)} bis ${formatDate(leave.end)}',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: kPadOnlyR8,
                  child: Text(
                    'Typ: ${getReadableLeaveType(leave.type)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                getLeaveTypeIcon(leave.type),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: kPadOnlyR8,
                  child: Text(
                    'Status: ${getReadableLeaveStatus(leave.status.name)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                getIconByStatus(leave.status.name),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
