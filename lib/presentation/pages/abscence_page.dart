import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/colleague_cubit/colleague_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/holiday_cubit/holiday_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/leave_management_cubit/leave_management_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/leave_cubit/leave_cubit.dart';
import 'package:audavis_time_management/presentation/pages/holidays_page.dart';
import 'package:audavis_time_management/presentation/widgets/calendar_row.dart';
import 'package:audavis_time_management/presentation/widgets/create_leave_dialog.dart';
import 'package:audavis_time_management/presentation/widgets/day_header_row.dart';
import 'package:audavis_time_management/presentation/widgets/delete_leave_dialog.dart';
import 'package:audavis_time_management/presentation/widgets/left_pane.dart';
import 'package:audavis_time_management/presentation/widgets/month_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbscencePage extends StatefulWidget {
  const AbscencePage({super.key});

  @override
  State<AbscencePage> createState() => _AbscencePageState();
}

class _AbscencePageState extends State<AbscencePage> {
  final _verticalController = ScrollController();
  final _headerController = ScrollController();
  final _horizontalController = ScrollController();

  String _search = "";
  String? _teamFilter;

  String? _selectedColleagueId;

  String selectedLeaveType = "";
  final leaveTimeOptions = ["Full Day", "Half Day"];

  @override
  void initState() {
    super.initState();

    selectedLeaveType = leaveTimeOptions.first;

    // Start streams once
    context.read<LeaveCubit>().startWatchingAll();
    context.read<ColleaguesCubit>().startWatching();
    context.read<HolidayCubit>().watchMonth(month);

    _horizontalController.addListener(() {
      if (!_headerController.hasClients) return;

      final target = _horizontalController.offset;
      final current = _headerController.offset;

      if ((target - current).abs() < 0.1) return;
      _headerController.jumpTo(target);
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _headerController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  // helper to safely get colleague by id
  ColleagueEntity? _findColleagueById(List<ColleagueEntity> all, String? id) {
    if (id == null) return null;
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void _setMonth(DateTime newMonth) {
    setState(() => month = DateTime(newMonth.year, newMonth.month));
    context.read<HolidayCubit>().watchMonth(newMonth);
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    if (authState is! LoggedIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentUserId = authState.uid;
    final currentUserName = authState.name;

    return BlocListener<LeaveManagementCubit, LeaveManagementState>(
      listener: (context, state) {
        if (state is LeaveManagementError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is LeaveManagementSuccess) {
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<ColleaguesCubit, ColleaguesState>(
        builder: (context, colleagueState) {
          if (colleagueState is ColleaguesInitial ||
              colleagueState is ColleaguesLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (colleagueState is ColleaguesError) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    const Text(
                      "Abwesenheiten",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              body: Center(child: Text(colleagueState.message)),
            );
          }

          final allColleagues = (colleagueState as ColleaguesLoaded).colleagues;

          return BlocBuilder<LeaveCubit, LeaveState>(
            builder: (context, leaveState) {
              if (leaveState is LeaveInitial || leaveState is LeaveLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (leaveState is LeaveError) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      "Abwesenheiten",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: Center(child: Text(leaveState.message)),
                );
              }

              final leaves = (leaveState as LeaveLoaded).leaves;

              final days = daysInMonth(month);

              final teams = allColleagues.map((c) => c.team).toSet().toList()
                ..sort();
              final holidayState = context.watch<HolidayCubit>().state;

              final List<HolidayModel> holidays = switch (holidayState) {
                HolidayLoaded(:final holidays) => holidays,
                _ => const <HolidayModel>[],
              };
              final colleagues = allColleagues.where((c) {
                final matchesSearch =
                    _search.trim().isEmpty ||
                    c.name.toLowerCase().contains(_search.trim().toLowerCase());
                final matchesTeam =
                    _teamFilter == null || c.team == _teamFilter;
                final isActive = c.active;
                return matchesSearch && matchesTeam && isActive;
              }).toList();

              // set default selected colleague by id
              _selectedColleagueId ??= colleagues.isNotEmpty
                  ? colleagues.first.id
                  : null;

              final selectedColleague = _findColleagueById(
                allColleagues,
                _selectedColleagueId,
              );
              final selectedColleagueName = selectedColleague?.name;

              return Scaffold(
                appBar: AppBar(
                  title: const Text("Abwesenheiten"),

                  actions: [
                    TextButton(
                      onPressed: () => context.read<AuthCubit>().logout(),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text('Ausloggen'),
                          ),
                          Icon(Icons.logout),
                        ],
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    SizedBox(
                      height: 72,
                      child: Row(
                        children: [
                          SizedBox(
                            width: leftPaneWidth,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.search),
                                        hintText: "Kollegen suchen…",
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      onChanged: (v) =>
                                          setState(() => _search = v),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 180,
                                    child: DropdownButtonFormField<String?>(
                                      initialValue: _teamFilter,
                                      isDense: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        labelText: "Team",
                                      ),
                                      items: [
                                        const DropdownMenuItem<String?>(
                                          value: null,
                                          child: Text("Alle"),
                                        ),
                                        ...teams.map(
                                          (t) => DropdownMenuItem<String?>(
                                            value: t,
                                            child: Text(t),
                                          ),
                                        ),
                                      ],
                                      onChanged: (val) =>
                                          setState(() => _teamFilter = val),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(
                            child: MonthHeader(
                              month: month,
                              onPrev: () => _setMonth(
                                DateTime(month.year, month.month - 1),
                              ),
                              onNext: () => _setMonth(
                                DateTime(month.year, month.month + 1),
                              ),
                              onToday: () => _setMonth(
                                DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                ),
                              ),
                              selectedColleagueName: selectedColleagueName,
                              onAddTestLeave: (_selectedColleagueId == null)
                                  ? null
                                  : () async {
                                      final entry = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CreateLeaveDialog(
                                            currentUserId: currentUserId,
                                            currentUserName: currentUserName,
                                          );
                                        },
                                      );

                                      if (entry == null) return;
                                      if (!context.mounted) return;

                                      await context
                                          .read<LeaveManagementCubit>()
                                          .createLeave(entry);
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    SizedBox(
                      height: 44,
                      child: Row(
                        children: [
                          SizedBox(
                            width: leftPaneWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Mitarbeiter (${colleagues.length})",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ),
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(
                            child: IgnorePointer(
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _headerController,
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: days.length * dayCellWidth,
                                  child: DayHeaderRow(
                                    monthDays: days,
                                    holidays: holidays,
                                    cellWidth: dayCellWidth,
                                    height: 44,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: leftPaneWidth,
                            child: ListView.builder(
                              controller: _verticalController,
                              itemCount: colleagues.length,
                              itemExtent: rowHeight,
                              itemBuilder: (context, index) {
                                final c = colleagues[index];
                                final selected = c.id == _selectedColleagueId;

                                return ColleagueListTile(
                                  myId: currentUserId,
                                  colleague: c,
                                  selected: selected,
                                  onTap: () => setState(
                                    () => _selectedColleagueId = c.id,
                                  ),
                                );
                              },
                            ),
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(
                            child: Scrollbar(
                              controller: _horizontalController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _horizontalController,
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: days.length * dayCellWidth,
                                  child: ListView.builder(
                                    controller: _verticalController,
                                    itemCount: colleagues.length,
                                    itemExtent: rowHeight,
                                    itemBuilder: (context, rowIndex) {
                                      final c = colleagues[rowIndex];

                                      // match leaves by employeeId (not name)
                                      final rowLeaves = leaves
                                          .where((e) => e.employeeId == c.id)
                                          .toList();

                                      return CalendarRow(
                                        colleague: c,
                                        monthDays: days,
                                        holidays: holidays,
                                        leaves: rowLeaves,
                                        cellWidth: dayCellWidth,
                                        height: rowHeight,
                                        onDeleteLeaveTap: (entry) async {
                                          final result =
                                              await showDialog<LeaveEditResult>(
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteLeaveDialog(
                                                    colleague: c,

                                                    entry: entry,
                                                  );
                                                },
                                              );

                                          if (result == null) return;

                                          if (result.isDeleted) {
                                            if (!context.mounted) return;
                                            await context
                                                .read<LeaveManagementCubit>()
                                                .deleteLeave(entry.id);
                                          } else if (result.updatedEntry !=
                                              null) {
                                            final updated =
                                                result.updatedEntry!;
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceTint,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (ctx) => Dialog.fullscreen(
                                    child: AdminHolidaysPage(),
                                  ),
                                );
                              },
                              child: const Text('Feiertage eintragen'),
                            ),

                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (ctx) => Dialog.fullscreen(
                                    child: AdminHolidaysPage(),
                                  ),
                                );
                              },
                              child: const Text('Offene Anträge anzeigen'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// 1. Only isMe can onTap on Days to delete stuff
// 2. Only admin can see buttons on the bottom
// 3. Approve / Decline for vacations and change color in calendar
// 4. Show month buttons to choose which month to show
// 5. Redesign, refactor, test, push to remote
// 6. Wenn Urlaub mitgenommen wird vom Vorjahr. Soll vom admin eingetragen werden. Zahl der Urlaubstage ändern.