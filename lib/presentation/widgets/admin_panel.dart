import 'package:audavis_time_management/presentation/pages/holidays_page.dart';
import 'package:flutter/material.dart';

/// Admin setting panel with buttons to manage holidays, requests, etc.
class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  builder: (ctx) =>
                      Dialog.fullscreen(child: AdminHolidaysPage()),
                );
              },
              child: const Text('Feiertage eintragen'),
            ),

            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) =>
                      Dialog.fullscreen(child: AdminHolidaysPage()),
                );
              },
              child: const Text('Offene Anträge anzeigen'),
            ),
          ],
        ),
      ),
    );
  }
}
