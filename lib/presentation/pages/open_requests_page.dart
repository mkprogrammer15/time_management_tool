import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/presentation/blocs/leave_cubit/leave_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OpenRequestsPage extends StatefulWidget {
  const OpenRequestsPage({required this.currentUserId, super.key});

  final String currentUserId;

  @override
  State<OpenRequestsPage> createState() => _OpenRequestsPageState();
}

class _OpenRequestsPageState extends State<OpenRequestsPage> {
  String _fmt(DateTime d) => DateFormat('dd.MM.yyyy').format(d);

  @override
  void initState() {
    super.initState();
    context.read<LeaveCubit>().startWatchingAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offene Urlaubsanfragen')),
      body: BlocBuilder<LeaveCubit, LeaveState>(
        builder: (context, state) {
          if (state is LeaveError) {
            final err = state;

            return Center(child: Text('Fehler: ${err.message}'));
          } else if (state is LeaveLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LeaveLoaded) {
            final openRequests = state.leaves.where((e) {
              return e.type == LeaveType.vacation &&
                  e.status == LeaveStatus.requested;
            }).toList();

            if (openRequests.isEmpty) {
              return const Center(child: Text('Keine offenen Anfragen'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: openRequests.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final entry = openRequests[i];
                final range = '${_fmt(entry.start)} -> ${_fmt(entry.end)}';
                debugPrint(entry.employeeName);
                debugPrint(entry.id);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.employeeName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(range),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    context.read<LeaveCubit>().decideLeave(
                                      entry: entry,
                                      status: LeaveStatus.rejected,
                                      approverId: widget.currentUserId,
                                    ),
                                child: const Text('Ablehnen'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton(
                                onPressed: () =>
                                    context.read<LeaveCubit>().decideLeave(
                                      entry: entry,
                                      status: LeaveStatus.approved,
                                      approverId: widget.currentUserId,
                                    ),
                                child: const Text('Annehmen'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: SizedBox.shrink());
          }
        },
      ),
    );
  }
}
