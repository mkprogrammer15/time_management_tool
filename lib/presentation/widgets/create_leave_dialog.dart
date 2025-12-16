import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateLeaveDialog extends StatefulWidget {
  const CreateLeaveDialog({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  final String currentUserId;
  final String currentUserName;

  @override
  State<CreateLeaveDialog> createState() => _CreateLeaveDialogState();
}

class _CreateLeaveDialogState extends State<CreateLeaveDialog> {
  late final TextEditingController _fromCtrl;
  late final TextEditingController _toCtrl;

  DateTime? _from;
  DateTime? _to;

  LeaveType _type = LeaveType.vacation;
  LeaveStatus _status = LeaveStatus.requested;

  String _selectedLeaveType = "Full Day";
  final List<String> _leaveTimeOptions = const ["Full Day", "Half Day"];

  @override
  void initState() {
    super.initState();
    _fromCtrl = TextEditingController();
    _toCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit => _from != null && _to != null;

  void _setFrom(DateTime d) {
    _from = DateTime(d.year, d.month, d.day);
    _fromCtrl.text = formatDate(_from!);

    if (_to != null && _to!.isBefore(_from!)) {
      _to = _from;
      _toCtrl.text = formatDate(_to!);
    }
    setState(() {});
  }

  void _setTo(DateTime d) {
    _to = DateTime(d.year, d.month, d.day);
    _toCtrl.text = formatDate(_to!);
    setState(() {});
  }

  void _parseFromText(String value) {
    final parsed = parseDate(value);
    if (parsed == null) {
      setState(() => _from = null);
      return;
    }
    _setFrom(parsed);
  }

  void _parseToText(String value) {
    final parsed = parseDate(value);
    if (parsed == null) {
      setState(() => _to = null);
      return;
    }
    if (_from != null && parsed.isBefore(_from!)) {
      _setTo(_from!);
      return;
    }
    _setTo(parsed);
  }

  Future<void> _pickFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _from ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null) _setFrom(picked);
  }

  Future<void> _pickTo() async {
    if (_from == null) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: _to ?? _from!,
      firstDate: _from!,
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null) _setTo(picked);
  }

  void _submit() {
    if (!_canSubmit) return;

    final entry = LeaveEntryEntity(
      id: Uuid().v4(),
      approverId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),

      employeeId: widget.currentUserId,
      employeeName: widget.currentUserName,

      start: _from!,
      end: _to!,
      type: _type,
      status: _status,
      dayType: _selectedLeaveType == "Half Day"
          ? LeaveDayType.halfDay
          : LeaveDayType.fullDay,
    );

    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Abwesenheit anlegen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedLeaveType,
            items: _leaveTimeOptions
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedLeaveType = value);
            },
            decoration: const InputDecoration(
              labelText: "Dauer",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _fromCtrl,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: "Von (dd.MM.yyyy)",
              border: const OutlineInputBorder(),
              isDense: true,
              prefixIcon: const Icon(Icons.event),
              suffixIcon: IconButton(
                tooltip: "Datum wählen",
                icon: const Icon(Icons.calendar_month),
                onPressed: _pickFrom,
              ),
              errorText: (_fromCtrl.text.isEmpty || _from != null)
                  ? null
                  : "Ungültiges Datum",
            ),
            onChanged: _parseFromText,
            onEditingComplete: () => _parseFromText(_fromCtrl.text),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _toCtrl,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: "Bis (dd.MM.yyyy)",
              border: const OutlineInputBorder(),
              isDense: true,
              prefixIcon: const Icon(Icons.event_available),
              suffixIcon: IconButton(
                tooltip: "Datum wählen",
                icon: const Icon(Icons.calendar_month),
                onPressed: (_from == null) ? null : _pickTo,
              ),
              errorText: (_toCtrl.text.isEmpty || _to != null)
                  ? null
                  : "Ungültiges Datum",
            ),
            onChanged: _parseToText,
            onEditingComplete: () => _parseToText(_toCtrl.text),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<LeaveType>(
            initialValue: _type,
            decoration: const InputDecoration(
              labelText: "Typ",
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(
                value: LeaveType.vacation,
                child: Text("Urlaub"),
              ),
              DropdownMenuItem(value: LeaveType.sick, child: Text("Krank")),
            ],
            onChanged: (val) {
              if (val == null) return;
              setState(() => _type = val);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Abbrechen"),
        ),
        ElevatedButton(
          onPressed: _canSubmit ? _submit : null,
          child: const Text("Anlegen"),
        ),
      ],
    );
  }
}
