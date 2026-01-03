import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/other_helpers.dart';
import 'package:audavis_time_management/presentation/blocs/approval_info_cubit/approval_info_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/leave_cubit/leave_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteLeaveDialog extends StatelessWidget {
  const DeleteLeaveDialog({
    super.key,
    required this.colleague,
    required this.entry,
  });

  final ColleagueEntity colleague;
  final LeaveEntryEntity entry;

  @override
  Widget build(BuildContext context) {
    final isPast = isPastEntry(entry);
    if (entry.approverId != null) {
      context.read<ApprovalInfoCubit>().getUserNameByApprovalId(
        entry.approverId!,
      );
    }

    return AlertDialog(
      title: const Text("Eintrag löschen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Mitarbeiter", colleague.name),
          const SizedBox(height: 8),
          _row("Von", formatDate(entry.start)),
          _row("Bis", formatDate(entry.end)),
          const SizedBox(height: 8),
          _row("Typ", leaveTypeLabel(entry.type)),
          const SizedBox(height: 8),

          BlocBuilder<ApprovalInfoCubit, ApprovalInfoState>(
            builder: (context, state) {
              if (state is ApprovalInfoLoaded) {
                return Row(
                  children: [
                    SizedBox(
                      width: 170,
                      child: _row('Status', getReadableStatus(entry.status)),
                    ),

                    Text(
                      ' von ${state.approvalInfo.isEmpty ? colleague.name : state.approvalInfo}',
                    ),
                  ],
                );
              } else if (state is ApprovalInfoLoading) {
                return const CircularProgressIndicator();
              } else if (state is ApprovalInfoError) {
                return _row('Status', state.errorMessage);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              isPast
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.lock_outline),
                    )
                  : const SizedBox.shrink(),
              Text(
                isPast
                    ? "Vergangene oder gestartete Einträge können nicht gelöscht werden."
                    : "Möchtest du diesen Eintrag wirklich löschen?",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Abbrechen"),
        ),
        TextButton.icon(
          icon: const Icon(Icons.delete_outline),
          label: const Text("Eintrag löschen"),
          onPressed: isPast
              ? null
              : () => Navigator.pop(context, LeaveEditResult.deleted()),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
