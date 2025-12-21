import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/presentation/blocs/leave_cubit/leave_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColleagueLeavesWidget extends StatelessWidget {
  const ColleagueLeavesWidget({required this.colleagueId, super.key});

  final String colleagueId;

  @override
  Widget build(BuildContext context) {
    context.read<LeaveCubit>().loadLeavesByUserId(colleagueId);

    return BlocBuilder<LeaveCubit, LeaveState>(
      builder: (context, state) {
        if (state is LeaveLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LeaveLoaded) {
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
        } else if (state is LeaveError) {
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Vom ${formatDate(leave.start)} bis ${formatDate(leave.end)}',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Typ: ${leave.type.name}'),
          Text('Status: ${leave.status.name}'),
        ],
      ),
    );
  }
}
