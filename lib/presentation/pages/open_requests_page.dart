import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/presentation/blocs/leave_cubit/leave_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:thanos_snap_effect/thanos_snap_effect.dart';

class OpenRequestsPage extends StatefulWidget {
  const OpenRequestsPage({required this.currentUserId, super.key});

  final String currentUserId;

  @override
  State<OpenRequestsPage> createState() => _OpenRequestsPageState();
}

class _OpenRequestsPageState extends State<OpenRequestsPage>
    with TickerProviderStateMixin {
  String _fmt(DateTime d) => DateFormat('dd.MM.yyyy').format(d);

  @override
  void initState() {
    super.initState();
    context.read<LeaveCubit>().startWatchingAll();
  }

  String dayTypeToString(LeaveDayType type) {
    switch (type) {
      case LeaveDayType.fullDay:
        return 'Voller Tag';
      case LeaveDayType.halfDay:
        return 'Halber Tag';
    }
  }

  final Map<String, AnimationController> _animationControllers = {};

  @override
  void dispose() {
    super.dispose();
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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

            return SizedBox(
              width: size.width * 0.3,
              child: ListView.separated(
                padding: kPadAll12,
                itemCount: openRequests.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final entry = openRequests[i];
                  final range = '${_fmt(entry.start)} -> ${_fmt(entry.end)}';
                  if (!_animationControllers.containsKey(entry.id)) {
                    _animationControllers[entry.id] = AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 1000),
                    );
                  }
                  final controller = _animationControllers[entry.id];
                  return Snappable(
                    animation: controller!,
                    child: Card(
                      child: Padding(
                        padding: kPadAll12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.employeeName,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 6),
                            Text(range),
                            const SizedBox(height: 6),

                            Text(dayTypeToString(entry.dayType)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      await controller.forward(from: 0);
                                      if (!context.mounted) return;
                                      await context
                                          .read<LeaveCubit>()
                                          .decideLeave(
                                            entry: entry,
                                            status: LeaveStatus.rejected,
                                            approverId: widget.currentUserId,
                                          );
                                    },
                                    child: const Text('Ablehnen'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () async {
                                      await controller.forward(from: 0);
                                      if (!context.mounted) return;
                                      await context
                                          .read<LeaveCubit>()
                                          .decideLeave(
                                            entry: entry,
                                            status: LeaveStatus.approved,
                                            approverId: widget.currentUserId,
                                          );
                                    },
                                    child: const Text('Annehmen'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: SizedBox.shrink());
          }
        },
      ),
    );
  }
}
