import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/data/models/colleague_model.dart';
import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/domain/entities/leave_entity.dart';
import 'package:audavis_time_management/presentation/widgets/calendar_row.dart';
import 'package:audavis_time_management/presentation/widgets/left_pane.dart';
import 'package:audavis_time_management/presentation/widgets/month_header.dart';
import 'package:flutter/material.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  final _verticalController = ScrollController();
  final _headerController = ScrollController();
  final _horizontalController = ScrollController();

  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  String _search = "";
  String? _teamFilter;
  String? _selectedColleagueName;

  // Dummy colleagues
  late final List<ColleagueModel> _allColleagues = [
    const ColleagueModel(id: '1', name: "Michael Karp", team: "Frontend"),
    const ColleagueModel(
      id: '2',
      name: "Moritz Fuchshofer",
      team: "Data Engineering",
    ),
    const ColleagueModel(
      id: '3',
      name: "Mathias Hosang",
      team: "Infrastructure",
    ),
    const ColleagueModel(id: '4', name: "Philipp Roebruck", team: "Sales"),
    const ColleagueModel(id: '5', name: "Otrek Wilke", team: "Backend"),
  ];

  late List<LeaveEntry> _leaves = [
    LeaveEntry(
      colleagueName: "Moritz Fuchshofer",
      start: DateTime(DateTime.now().year, DateTime.now().month, 3),
      end: DateTime(DateTime.now().year, DateTime.now().month, 6),
      type: LeaveType.vacation,
      status: LeaveStatus.approved,
    ),
    LeaveEntry(
      colleagueName: "Michael Karp",
      start: DateTime(DateTime.now().year, DateTime.now().month, 10),
      end: DateTime(DateTime.now().year, DateTime.now().month, 10),
      type: LeaveType.vacation,
      status: LeaveStatus.approved,
    ),
    LeaveEntry(
      colleagueName: "Mathias Hosang",
      start: DateTime(DateTime.now().year, DateTime.now().month, 18),
      end: DateTime(DateTime.now().year, DateTime.now().month, 19),
      type: LeaveType.sick,
      status: LeaveStatus.requested,
    ),
    LeaveEntry(
      colleagueName: "Philipp Roebruck",
      start: DateTime(DateTime.now().year, DateTime.now().month, 15),
      end: DateTime(DateTime.now().year, DateTime.now().month, 15),
      type: LeaveType.sick,
      status: LeaveStatus.requested,
    ),
    LeaveEntry(
      colleagueName: "Otrek Wilke",
      start: DateTime(DateTime.now().year, DateTime.now().month, 23),
      end: DateTime(DateTime.now().year, DateTime.now().month, 24),
      type: LeaveType.sick,
      status: LeaveStatus.requested,
    ),
  ];

  @override
  void initState() {
    super.initState();

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

  late List<HolidayModel> _holidaysFromAdmin = [
    HolidayModel(
      id: 'h1',
      date: DateTime(_month.year, _month.month, 1),
      title: 'Feiertag 1',
    ),
    HolidayModel(
      id: 'h2',
      date: DateTime(_month.year, _month.month, 25),
      title: 'Feiertag 2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final days = _daysInMonth(_month);
    final holidays = holidaysSetFrom(_holidaysFromAdmin, _month);

    final teams = _allColleagues.map((c) => c.team).toSet().toList()..sort();

    final colleagues = _allColleagues.where((c) {
      final matchesSearch =
          _search.trim().isEmpty ||
          c.name.toLowerCase().contains(_search.trim().toLowerCase());
      final matchesTeam = _teamFilter == null || c.team == _teamFilter;
      return matchesSearch && matchesTeam;
    }).toList();

    _selectedColleagueName ??= colleagues.isNotEmpty
        ? colleagues.first.name
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Abwesenheiten")),
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
                            onChanged: (v) => setState(() => _search = v),
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
                    month: _month,
                    onPrev: () => setState(
                      () => _month = DateTime(_month.year, _month.month - 1),
                    ),
                    onNext: () => setState(
                      () => _month = DateTime(_month.year, _month.month + 1),
                    ),
                    onToday: () => setState(
                      () => _month = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                      ),
                    ),
                    selectedColleagueName: _selectedColleagueName,
                    onAddTestLeave: _selectedColleagueName == null
                        ? null
                        : () {
                            final now = DateTime.now();
                            final start = DateTime(
                              _month.year,
                              _month.month,
                              (now.day.clamp(1, days.length)),
                            );
                            final end = start.add(const Duration(days: 2));
                            setState(() {
                              _leaves = [
                                ..._leaves,
                                LeaveEntry(
                                  colleagueName: _selectedColleagueName!,
                                  start: start,
                                  end: DateTime(end.year, end.month, end.day),
                                  type: LeaveType.vacation,
                                  status: LeaveStatus.requested,
                                ),
                              ];
                            });
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      physics: NeverScrollableScrollPhysics(),
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
                      final selected = c.name == _selectedColleagueName;
                      return LeftPane(
                        colleague: c,
                        selected: selected,
                        onTap: () =>
                            setState(() => _selectedColleagueName = c.name),
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
                            final rowLeaves = _leaves
                                .where((e) => e.colleagueName == c.name)
                                .toList();

                            return CalendarRow(
                              colleague: c,
                              monthDays: days,
                              holidays: holidays,
                              leaves: rowLeaves,
                              cellWidth: dayCellWidth,
                              height: rowHeight,
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
        ],
      ),
    );
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    final last = nextMonth.subtract(const Duration(days: 1));

    return List.generate(
      last.day,
      (i) => DateTime(first.year, first.month, i + 1),
    );
  }

  Set<DateTime> holidaysSetFrom(List<HolidayModel> holidays, DateTime month) {
    return holidays
        .where((h) => h.date.year == month.year && h.date.month == month.month)
        .map((h) => DateTime(h.date.year, h.date.month, h.date.day))
        .toSet();
  }
}
