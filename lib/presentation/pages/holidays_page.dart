import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/presentation/blocs/holiday_cubit/holiday_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page to manage holidays (admin only).
class AdminHolidaysPage extends StatefulWidget {
  const AdminHolidaysPage({super.key});

  @override
  State<AdminHolidaysPage> createState() => _AdminHolidaysPageState();
}

class _AdminHolidaysPageState extends State<AdminHolidaysPage> {
  final _titleCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HolidayCubit>().watchAll();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feiertage verwalten'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _openAddDialog),
        ],
      ),
      body: BlocBuilder<HolidayCubit, HolidayState>(
        builder: (context, state) {
          if (state is HolidayLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HolidayError) {
            return Center(
              child: Text(
                'Liste der Feiertage konnte nicht geladen werden:\n${state.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is HolidayLoaded) {
            final holidays = List<HolidayModel>.from(state.holidays)
              ..sort((a, b) => a.date.compareTo(b.date));

            if (holidays.isEmpty) {
              return const Center(child: Text('Keine Feiertage vorhanden.'));
            }

            return ListView.separated(
              itemCount: holidays.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final h = holidays[i];

                return ListTile(
                  title: Text(h.title),
                  subtitle: Text(
                    '${h.date.day.toString().padLeft(2, '0')}.'
                    '${h.date.month.toString().padLeft(2, '0')}.'
                    '${h.date.year}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context.read<HolidayCubit>().remove(h.id),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
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
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
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
                            initialDate: pickedDate ?? now,
                          );

                          if (d != null) {
                            setDialogState(() {
                              pickedDate = DateTime(d.year, d.month, d.day);
                            });
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
                  onPressed: pickedDate == null
                      ? null
                      : () {
                          final title = _titleCtrl.text.trim();
                          if (title.isEmpty) return;

                          context.read<HolidayCubit>().create(
                            HolidayModel(
                              id: '',
                              date: pickedDate!,
                              title: title,
                              locationId: null,
                            ),
                          );

                          Navigator.pop(ctx);
                        },
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
