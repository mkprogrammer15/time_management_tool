import 'package:flutter/material.dart';

class MonthHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final String? selectedColleagueName;
  final VoidCallback? onAddTestLeave;

  const MonthHeader({
    super.key,
    required this.month,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
    required this.selectedColleagueName,
    required this.onAddTestLeave,
  });

  @override
  Widget build(BuildContext context) {
    final title = "${_monthName(month.month)} ${month.year}";
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 12),
          IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: onToday, child: const Text("Heute")),
          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: onAddTestLeave,
              icon: const Icon(Icons.add),
              label: const Text("Neue Abwesenheit"),
            ),
          ),
        ],
      ),
    );
  }

  static String _monthName(int m) {
    const names = [
      "Januar",
      "Februar",
      "März",
      "April",
      "Mai",
      "Juni",
      "Juli",
      "August",
      "September",
      "Oktober",
      "November",
      "Dezember",
    ];
    return names[m - 1];
  }
}
