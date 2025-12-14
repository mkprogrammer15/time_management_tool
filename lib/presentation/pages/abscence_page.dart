import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/leave_entity.dart';
import 'package:audavis_time_management/dummy_data.dart';
import 'package:audavis_time_management/presentation/pages/holidays_page.dart';
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

  String _search = "";
  String? _teamFilter;
  String? _selectedColleagueName;

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

  @override
  Widget build(BuildContext context) {
    final days = daysInMonth(month);
    final holidays = holidaysSetFrom(holidaysFromAdmin, month);

    final teams = allColleagues.map((c) => c.team).toSet().toList()..sort();

    final colleagues = allColleagues.where((c) {
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
                    month: month,
                    onPrev: () => setState(
                      () => month = DateTime(month.year, month.month - 1),
                    ),
                    onNext: () => setState(
                      () => month = DateTime(month.year, month.month + 1),
                    ),
                    onToday: () => setState(
                      () => month = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                      ),
                    ),
                    selectedColleagueName: _selectedColleagueName,
                    onAddTestLeave: _selectedColleagueName == null
                        ? null
                        : () async {
                            final entry = await _openAddLeaveDialog(context);
                            if (entry == null) return;

                            setState(() {
                              leaves = [...leaves, entry];
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
                      return ColleagueListTile(
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
                            final rowLeaves = leaves
                                .where((e) => e.colleagueName == c.name)
                                .toList();

                            return CalendarRow(
                              colleague: c,
                              monthDays: days,
                              holidays: holidays,
                              leaves: rowLeaves,
                              cellWidth: dayCellWidth,
                              height: rowHeight,
                              onLeaveTap: (entry) async {
                                final result = await _openEditLeaveDialog(
                                  context,
                                  entry,
                                );
                                if (result == null) return;

                                setState(() {
                                  if (result.isDeleted) {
                                    leaves.removeWhere((e) => e.id == entry.id);
                                  } else if (result.updatedEntry != null) {
                                    final idx = leaves.indexWhere(
                                      (e) => e.id == entry.id,
                                    );
                                    if (idx != -1) {
                                      leaves[idx] = result.updatedEntry!;
                                    }
                                  }
                                });
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
                    child: Text('Feiertage eintragen'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) =>
                            Dialog.fullscreen(child: AdminHolidaysPage()),
                      );
                    },
                    child: Text('Kollegen hinzufügen'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) =>
                            Dialog.fullscreen(child: AdminHolidaysPage()),
                      );
                    },
                    child: Text('Offene Anträge anzeigen'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<DateTime> holidaysSetFrom(List<HolidayModel> holidays, DateTime month) {
    return holidays
        .where((h) => h.date.year == month.year && h.date.month == month.month)
        .map((h) => DateTime(h.date.year, h.date.month, h.date.day))
        .toSet();
  }

  Future<LeaveEntry?> _openAddLeaveDialog(BuildContext context) async {
    final fromCtrl = TextEditingController();
    final toCtrl = TextEditingController();

    DateTime? from;
    DateTime? to;

    LeaveType type = LeaveType.vacation;

    // helper to keep text + DateTime in sync
    void setFrom(StateSetter setDialogState, DateTime d) {
      from = DateTime(d.year, d.month, d.day);
      fromCtrl.text = formatDate(from!);

      // auto-fix "to" if it's before "from"
      if (to != null && to!.isBefore(from!)) {
        to = from;
        toCtrl.text = formatDate(to!);
      }

      setDialogState(() {});
    }

    void setTo(StateSetter setDialogState, DateTime d) {
      to = DateTime(d.year, d.month, d.day);
      toCtrl.text = formatDate(to!);
      setDialogState(() {});
    }

    return showDialog<LeaveEntry>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            Future<void> pickFrom() async {
              final picked = await showDatePicker(
                context: ctx,
                initialDate: from ?? DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 2),
              );
              if (picked != null) setFrom(setDialogState, picked);
            }

            Future<void> pickTo() async {
              if (from == null) return;

              final picked = await showDatePicker(
                context: ctx,
                initialDate: to ?? from!,
                firstDate: from!,
                lastDate: DateTime(DateTime.now().year + 2),
              );
              if (picked != null) setTo(setDialogState, picked);
            }

            void parseFromText(String value) {
              final parsed = parseDate(value);
              if (parsed == null) {
                setDialogState(() => from = null);
                return;
              }
              setFrom(setDialogState, parsed);
            }

            void parseToText(String value) {
              final parsed = parseDate(value);
              if (parsed == null) {
                setDialogState(() => to = null);
                return;
              }

              if (from != null && parsed.isBefore(from!)) {
                setTo(setDialogState, from!);
                return;
              }
              setTo(setDialogState, parsed);
            }

            final canSubmit = from != null && to != null;

            return AlertDialog(
              title: const Text("Add Leave"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: fromCtrl,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: "From (dd.MM.yyyy)",
                      border: const OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: const Icon(Icons.event),
                      suffixIcon: IconButton(
                        tooltip: "Pick date",
                        icon: const Icon(Icons.calendar_month),
                        onPressed: pickFrom,
                      ),
                      errorText: (fromCtrl.text.isEmpty || from != null)
                          ? null
                          : "Invalid date",
                    ),
                    onChanged: parseFromText,
                    onEditingComplete: () => parseFromText(fromCtrl.text),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: toCtrl,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: "To (dd.MM.yyyy)",
                      border: const OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: const Icon(Icons.event_available),
                      suffixIcon: IconButton(
                        tooltip: "Pick date",
                        icon: const Icon(Icons.calendar_month),
                        onPressed: (from == null) ? null : pickTo,
                      ),
                      errorText: (toCtrl.text.isEmpty || to != null)
                          ? null
                          : "Invalid date",
                    ),
                    onChanged: parseToText,
                    onEditingComplete: () => parseToText(toCtrl.text),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<LeaveType>(
                    initialValue: type,
                    decoration: const InputDecoration(
                      labelText: "Leave type",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: LeaveType.vacation,
                        child: Text("Vacation"),
                      ),
                      DropdownMenuItem(
                        value: LeaveType.sick,
                        child: Text("Sick leave"),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => type = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    fromCtrl.dispose();
                    toCtrl.dispose();
                    Navigator.pop(ctx);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: canSubmit
                      ? () {
                          fromCtrl.dispose();
                          toCtrl.dispose();
                          Navigator.pop(
                            ctx,
                            LeaveEntry(
                              id: 'new',
                              colleagueName: _selectedColleagueName!,
                              start: from!,
                              end: to!,
                              type: type,
                              status: LeaveStatus.requested,
                            ),
                          );
                        }
                      : null,
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class LeaveEditResult {
  final bool isDeleted;
  final LeaveEntry? updatedEntry;

  const LeaveEditResult.deleted() : isDeleted = true, updatedEntry = null;

  const LeaveEditResult.updated(this.updatedEntry) : isDeleted = false;
}

//-----------------
Future<LeaveEditResult?> _openEditLeaveDialog(
  BuildContext context,
  LeaveEntry entry,
) async {
  final fromCtrl = TextEditingController(text: formatDate(entry.start));
  final toCtrl = TextEditingController(text: formatDate(entry.end));

  DateTime? from = DateTime(
    entry.start.year,
    entry.start.month,
    entry.start.day,
  );
  DateTime? to = DateTime(entry.end.year, entry.end.month, entry.end.day);

  LeaveType type = entry.type;
  LeaveStatus status = entry.status;

  void setFrom(StateSetter setDialogState, DateTime d) {
    from = DateTime(d.year, d.month, d.day);
    fromCtrl.text = formatDate(from!);
    if (to != null && to!.isBefore(from!)) {
      to = from;
      toCtrl.text = formatDate(to!);
    }
    setDialogState(() {});
  }

  void setTo(StateSetter setDialogState, DateTime d) {
    to = DateTime(d.year, d.month, d.day);
    toCtrl.text = formatDate(to!);
    setDialogState(() {});
  }

  return showDialog<LeaveEditResult>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setDialogState) {
          Future<void> pickFrom() async {
            final picked = await showDatePicker(
              context: ctx,
              initialDate: from ?? DateTime.now(),
              firstDate: DateTime(DateTime.now().year - 2),
              lastDate: DateTime(DateTime.now().year + 3),
            );
            if (picked != null) setFrom(setDialogState, picked);
          }

          Future<void> pickTo() async {
            if (from == null) return;
            final picked = await showDatePicker(
              context: ctx,
              initialDate: to ?? from!,
              firstDate: from!,
              lastDate: DateTime(DateTime.now().year + 3),
            );
            if (picked != null) setTo(setDialogState, picked);
          }

          void parseFromText(String value) {
            final parsed = parseDate(value);
            if (parsed == null) {
              setDialogState(() => from = null);
              return;
            }
            setFrom(setDialogState, parsed);
          }

          void parseToText(String value) {
            final parsed = parseDate(value);
            if (parsed == null) {
              setDialogState(() => to = null);
              return;
            }
            if (from != null && parsed.isBefore(from!)) {
              setTo(setDialogState, from!);
              return;
            }
            setTo(setDialogState, parsed);
          }

          final canSave = from != null && to != null;

          return AlertDialog(
            title: Text("Edit Leave (${entry.colleagueName})"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fromCtrl,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "From (dd.MM.yyyy)",
                    border: const OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: const Icon(Icons.event),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: pickFrom,
                    ),
                    errorText: (fromCtrl.text.isEmpty || from != null)
                        ? null
                        : "Invalid date",
                  ),
                  onChanged: parseFromText,
                  onEditingComplete: () => parseFromText(fromCtrl.text),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: toCtrl,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "To (dd.MM.yyyy)",
                    border: const OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: const Icon(Icons.event_available),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: (from == null) ? null : pickTo,
                    ),
                    errorText: (toCtrl.text.isEmpty || to != null)
                        ? null
                        : "Invalid date",
                  ),
                  onChanged: parseToText,
                  onEditingComplete: () => parseToText(toCtrl.text),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<LeaveType>(
                  initialValue: type,
                  decoration: const InputDecoration(
                    labelText: "Type",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: LeaveType.vacation,
                      child: Text("Vacation"),
                    ),
                    DropdownMenuItem(
                      value: LeaveType.sick,
                      child: Text("Sickness"),
                    ),
                  ],
                  onChanged: (v) =>
                      v == null ? null : setDialogState(() => type = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<LeaveStatus>(
                  initialValue: status,
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: LeaveStatus.requested,
                      child: Text("Requested"),
                    ),
                    DropdownMenuItem(
                      value: LeaveStatus.approved,
                      child: Text("Approved"),
                    ),
                    DropdownMenuItem(
                      value: LeaveStatus.rejected,
                      child: Text("Rejected"),
                    ),
                  ],
                  onChanged: (v) =>
                      v == null ? null : setDialogState(() => status = v),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  fromCtrl.dispose();
                  toCtrl.dispose();
                  Navigator.pop(ctx);
                },
                child: const Text("Cancel"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text("Delete"),
                onPressed: () {
                  fromCtrl.dispose();
                  toCtrl.dispose();
                  Navigator.pop(ctx, const LeaveEditResult.deleted());
                },
              ),
              ElevatedButton(
                onPressed: canSave
                    ? () {
                        final updated = entry.copyWith(
                          start: from!,
                          end: to!,
                          type: type,
                          status: status,
                        );
                        fromCtrl.dispose();
                        toCtrl.dispose();
                        Navigator.pop(ctx, LeaveEditResult.updated(updated));
                      }
                    : null,
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}
