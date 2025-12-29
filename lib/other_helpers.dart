// helper to safely get colleague by id
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:flutter/services.dart';

ColleagueEntity? findColleagueById(List<ColleagueEntity> all, String? id) {
  if (id == null) return null;
  try {
    return all.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

class VacationDaysInputFormatter extends TextInputFormatter {
  static const double maxValue = 45.0;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Leer lassen erlauben (z. B. beim Löschen)
    if (text.isEmpty) {
      return newValue;
    }

    // Nur Ziffern und EIN Komma erlauben
    if (!RegExp(r'^\d{0,2}(,\d{0,1})?$').hasMatch(text)) {
      return oldValue;
    }

    // Komma am Ende erlauben (z. B. "1,")
    if (text.endsWith(',')) {
      return newValue;
    }

    // Umwandlung für Berechnung
    final normalized = text.replaceAll(',', '.');
    final value = double.tryParse(normalized);

    if (value == null) {
      return oldValue;
    }

    // Maximalwert prüfen
    if (value > maxValue) {
      return oldValue;
    }

    // Nur .0 oder .5 erlauben
    if ((value * 2) % 1 != 0) {
      return oldValue;
    }

    return newValue;
  }
}
