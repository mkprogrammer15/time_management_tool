import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:flutter/material.dart';

class AdminHolidaysPage extends StatefulWidget {
  const AdminHolidaysPage({super.key});

  @override
  State<AdminHolidaysPage> createState() => _AdminHolidaysPageState();
}

class _AdminHolidaysPageState extends State<AdminHolidaysPage> {
  final _titleCtrl = TextEditingController();

  // Demo: später ersetzen durch Firestore Stream
  final List<HolidayModel> _holidays = [
    HolidayModel(id: '1', date: DateTime(2026, 1, 1), title: 'Neujahr'),
    HolidayModel(id: '2', date: DateTime(2026, 12, 25), title: 'Weihnachten'),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _holidays.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feiertage verwalten'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _openAddDialog),
        ],
      ),
      body: ListView.separated(
        itemCount: _holidays.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final h = _holidays[i];
          return ListTile(
            title: Text(h.title),
            subtitle: Text(
              '${h.date.day.toString().padLeft(2, '0')}.'
              '${h.date.month.toString().padLeft(2, '0')}.'
              '${h.date.year}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => _holidays.removeAt(i)),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openAddDialog() async {
    _titleCtrl.text = '';
    DateTime? pickedDate;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Feiertag hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pickedDate == null
                          ? 'Kein Datum gewählt'
                          : '${pickedDate!.day.toString().padLeft(2, '0')}.'
                                '${pickedDate!.month.toString().padLeft(2, '0')}.'
                                '${pickedDate!.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final d = await showDatePicker(
                        context: ctx,
                        firstDate: DateTime(now.year - 1, 1, 1),
                        lastDate: DateTime(now.year + 5, 12, 31),
                        initialDate: now,
                      );
                      if (d != null) {
                        setState(
                          () => pickedDate = DateTime(d.year, d.month, d.day),
                        );
                      }
                    },
                    child: const Text('Datum wählen'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                if (pickedDate == null) return;
                final title = _titleCtrl.text.trim();
                if (title.isEmpty) return;

                setState(() {
                  _holidays.add(
                    HolidayModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: pickedDate!,
                      title: title,
                    ),
                  );
                });

                Navigator.pop(ctx);
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }
}
