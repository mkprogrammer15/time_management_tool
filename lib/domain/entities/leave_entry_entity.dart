enum LeaveType {
  vacation('Vacation'),
  sick('Sickness');

  final String value;
  const LeaveType(this.value);

  static LeaveType fromValue(dynamic v) {
    final s = (v?.toString() ?? '').trim().toLowerCase();
    return LeaveType.values.firstWhere(
      (e) => e.value.toLowerCase() == s,
      orElse: () => LeaveType.vacation,
    );
  }
}

enum LeaveStatus {
  requested('Requested'),
  approved('Approved'),
  rejected('Rejected');

  final String value;
  const LeaveStatus(this.value);

  static LeaveStatus fromValue(dynamic v) {
    final s = (v?.toString() ?? '').trim().toLowerCase();
    return LeaveStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == s,
      orElse: () => LeaveStatus.requested,
    );
  }
}

enum LeaveDayType {
  fullDay('Full Day'),
  halfDay('Half Day');

  final String value;
  const LeaveDayType(this.value);

  static LeaveDayType fromValue(dynamic v) {
    final s = (v?.toString() ?? '').trim().toLowerCase();

    switch (s) {
      case 'half day':
      case 'halfday':
      case 'half_day':
        return LeaveDayType.halfDay;

      case 'full day':
      case 'fullday':
      case 'full_day':
      default:
        return LeaveDayType.fullDay;
    }
  }
}

class LeaveEntryEntity {
  final String id;
  final String employeeId;
  final String employeeName;

  final DateTime start;
  final DateTime end;

  final DateTime createdAt;
  final DateTime updatedAt;

  final LeaveType type;
  final LeaveStatus status;
  final LeaveDayType dayType;

  final String? approverId;

  const LeaveEntryEntity({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.status,
    required this.dayType,
    this.approverId,
  });

  bool containsDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }
}
