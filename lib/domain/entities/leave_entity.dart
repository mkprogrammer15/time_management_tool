enum LeaveType { vacation, sick }

enum LeaveStatus { requested, approved, rejected }

class LeaveEntry {
  final String id;
  final String colleagueName;
  final DateTime start; // inclusive
  final DateTime end; // inclusive
  final LeaveType type;
  final LeaveStatus status;

  const LeaveEntry({
    required this.id,
    required this.colleagueName,
    required this.start,
    required this.end,
    required this.type,
    required this.status,
  });

  bool containsDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }

  LeaveEntry copyWith({
    DateTime? start,
    DateTime? end,
    LeaveType? type,
    LeaveStatus? status,
  }) {
    return LeaveEntry(
      id: id,
      colleagueName: colleagueName,
      start: start ?? this.start,
      end: end ?? this.end,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}
