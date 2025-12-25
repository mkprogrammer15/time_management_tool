import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/presentation/blocs/leave_cubit/leave_cubit.dart';
import 'package:audavis_time_management/presentation/pages/holidays_page.dart';
import 'package:audavis_time_management/presentation/pages/open_requests_page.dart';
import 'package:audavis_time_management/presentation/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Admin setting panel with buttons to manage holidays, requests, etc.
class AdminPanel extends StatelessWidget {
  const AdminPanel({
    required this.currentUserId,
    required this.isAdmin,
    super.key,
  });
  final String currentUserId;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceTint,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          spacing: 20,
          children: [
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) =>
                      Dialog.fullscreen(child: AdminHolidaysPage()),
                );
              },
              child: const Text('Feiertage eintragen'),
            ),

            BlocBuilder<LeaveCubit, LeaveState>(
              builder: (context, state) {
                int openCount = 0;

                if (state is LeaveLoaded) {
                  openCount = state.leaves
                      .where(
                        (e) =>
                            e.type == LeaveType.vacation &&
                            e.status == LeaveStatus.requested,
                      )
                      .length;
                }

                return Badge(
                  backgroundColor: Colors.red.shade400,
                  isLabelVisible: openCount > 0,
                  label: Text(openCount.toString()),
                  child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => Dialog.fullscreen(
                          child: OpenRequestsPage(currentUserId: currentUserId),
                        ),
                      );
                    },
                    child: const Text('Offene Anträge anzeigen'),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) =>
                      Dialog.fullscreen(child: UserPage(isAdmin: isAdmin)),
                );
              },
              child: const Text('Nutzer verwalten'),
            ),
          ],
        ),
      ),
    );
  }
}
