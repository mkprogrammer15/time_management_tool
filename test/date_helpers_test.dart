import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:flutter_test/flutter_test.dart';

LeaveEntryEntity leaveApprovedJan10to12() => LeaveEntryEntity(
  id: 'leave-1',
  createdAt: DateTime(2025, 1, 1, 8, 0),
  updatedAt: DateTime(2025, 1, 2, 8, 0),
  employeeId: 'emp-1',
  employeeName: 'Dummy name',
  type: LeaveType.vacation,
  dayType: LeaveDayType.fullDay,
  status: LeaveStatus.approved,
  start: DateTime(2025, 1, 10),
  end: DateTime(2025, 1, 12),
);

LeaveEntryEntity leaveApprovedJan12only() => LeaveEntryEntity(
  id: 'leave-2',
  createdAt: DateTime(2025, 1, 5, 9, 0),
  updatedAt: DateTime(2025, 1, 6, 9, 0),
  employeeId: 'emp-1',
  employeeName: 'Dummy name',
  type: LeaveType.vacation,
  dayType: LeaveDayType.fullDay,
  status: LeaveStatus.approved,
  start: DateTime(2025, 1, 12),
  end: DateTime(2025, 1, 12),
);

LeaveEntryEntity leavePast2000() => LeaveEntryEntity(
  id: 'leave-old',
  createdAt: DateTime(1999, 12, 31, 12, 0),
  updatedAt: DateTime(1999, 12, 31, 12, 0),
  employeeId: 'emp-old',
  employeeName: 'Old Dummy',
  type: LeaveType.vacation,
  dayType: LeaveDayType.fullDay,
  status: LeaveStatus.approved,
  start: DateTime(2000, 1, 1),
  end: DateTime(2000, 1, 2),
);

LeaveEntryEntity makeLeave({
  required String id,
  required DateTime start,
  required DateTime end,
  DateTime? createdAt,
  DateTime? updatedAt,
  LeaveDayType dayType = LeaveDayType.fullDay,
  LeaveStatus status = LeaveStatus.approved,
  LeaveType type = LeaveType.vacation,
  String employeeId = 'emp-1',
  String employeeName = 'Dummy name',
}) {
  final c = createdAt ?? DateTime(2025, 1, 1, 8, 0);
  final u = updatedAt ?? c;
  return LeaveEntryEntity(
    id: id,
    createdAt: c,
    updatedAt: u,
    dayType: dayType,
    employeeId: employeeId,
    employeeName: employeeName,
    end: end,
    start: start,
    status: status,
    type: type,
  );
}

void main() {
  group('formatDate', () {
    test('formats with leading zeros', () {
      expect(formatDate(DateTime(2025, 1, 2)), '02.01.2025');
      expect(formatDate(DateTime(2025, 11, 12)), '12.11.2025');
    });
  });

  group('parseDate', () {
    test('parses dd.MM.yyyy (with 1-2 digits for day/month)', () {
      expect(parseDate('2.1.2025'), DateTime(2025, 1, 2));
      expect(parseDate('02.01.2025'), DateTime(2025, 1, 2));
      expect(parseDate(' 02.01.2025 '), DateTime(2025, 1, 2));
    });

    test('returns null on invalid format', () {
      expect(parseDate('2025-01-02'), isNull);
      expect(parseDate('02/01/2025'), isNull);
      expect(parseDate(''), isNull);
      expect(parseDate('02.01.25'), isNull);
    });

    test('returns null on impossible dates', () {
      expect(parseDate('31.02.2025'), isNull); // Feb 31
      expect(parseDate('29.02.2025'), isNull); // 2025 not leap
      expect(parseDate('00.01.2025'), isNull);
      expect(parseDate('01.00.2025'), isNull);
      expect(parseDate('32.01.2025'), isNull);
      expect(parseDate('01.13.2025'), isNull);
    });

    test('accepts leap day on leap year', () {
      expect(parseDate('29.02.2024'), DateTime(2024, 2, 29));
    });
  });

  group('daysInMonth', () {
    test('returns all days for a 31-day month', () {
      final days = daysInMonth(DateTime(2025, 1, 1)); // Jan 2025
      expect(days.length, 31);
      expect(days.first, DateTime(2025, 1, 1));
      expect(days.last, DateTime(2025, 1, 31));
    });

    test('returns all days for a 30-day month', () {
      final days = daysInMonth(DateTime(2025, 4, 15)); // Apr 2025
      expect(days.length, 30);
      expect(days.first, DateTime(2025, 4, 1));
      expect(days.last, DateTime(2025, 4, 30));
    });

    test('returns 28 days for Feb in non-leap year', () {
      final days = daysInMonth(DateTime(2025, 2, 1));
      expect(days.length, 28);
      expect(days.last, DateTime(2025, 2, 28));
    });

    test('returns 29 days for Feb in leap year', () {
      final days = daysInMonth(DateTime(2024, 2, 1));
      expect(days.length, 29);
      expect(days.last, DateTime(2024, 2, 29));
    });

    test('handles December -> nextMonth year rollover via month+1', () {
      final days = daysInMonth(DateTime(2025, 12, 7));
      expect(days.length, 31);
      expect(days.first, DateTime(2025, 12, 1));
      expect(days.last, DateTime(2025, 12, 31));
    });
  });

  group('dateOnly', () {
    test('drops time portion', () {
      final d = DateTime(2025, 5, 10, 23, 59, 59, 999);
      expect(dateOnly(d), DateTime(2025, 5, 10));
    });
  });

  group('findLeaveForDay', () {
    final dummyLeaves = [leaveApprovedJan10to12(), leaveApprovedJan12only()];
    test('returns null if no entry matches', () {
      expect(findLeaveForDay(dummyLeaves, DateTime(2025, 1, 9)), isNull);
      expect(findLeaveForDay(dummyLeaves, DateTime(2025, 1, 13)), isNull);
    });

    test('returns matching entry if day within range (inclusive)', () {
      final entry = makeLeave(
        id: 'leave-1',
        start: DateTime(2025, 1, 10),
        end: DateTime(2025, 1, 12),
      );
      final dummyLeaves = [entry];

      expect(findLeaveForDay(dummyLeaves, DateTime(2025, 1, 10)), same(entry));
      expect(findLeaveForDay(dummyLeaves, DateTime(2025, 1, 11)), same(entry));
      expect(findLeaveForDay(dummyLeaves, DateTime(2025, 1, 12)), same(entry));
    });

    test('returns first matching entry if multiple match', () {
      final first = makeLeave(
        id: 'first',
        start: DateTime(2025, 1, 10),
        end: DateTime(2025, 1, 15),
      );
      final second = makeLeave(
        id: 'second',
        start: DateTime(2025, 1, 12),
        end: DateTime(2025, 1, 12),
      );
      final dummyLeaves = [first, second];

      final found = findLeaveForDay(dummyLeaves, DateTime(2025, 1, 12));
      expect(found, same(first));
    });
  });

  group('todayOnly', () {
    test('returns today at 00:00:00', () {
      final t = todayOnly;
      final now = DateTime.now();
      expect(t.year, now.year);
      expect(t.month, now.month);
      expect(t.day, now.day);
      expect(t.hour, 0);
      expect(t.minute, 0);
      expect(t.second, 0);
      expect(t.millisecond, 0);
      expect(t.microsecond, 0);
    });
  });

  group('isThisWeekend', () {
    test('true for Saturday/Sunday', () {
      expect(isThisWeekend(DateTime(2025, 1, 4)), isTrue); // Sat
      expect(isThisWeekend(DateTime(2025, 1, 5)), isTrue); // Sun
    });

    test('false for weekday', () {
      expect(isThisWeekend(DateTime(2025, 1, 6)), isFalse); // Mon
    });
  });

  group('containsDay (Set<DateTime>)', () {
    test('matches by y/m/d ignoring time', () {
      final set = <DateTime>{DateTime(2025, 1, 2, 10), DateTime(2025, 1, 3)};

      expect(containsDay(set, DateTime(2025, 1, 2, 23, 59)), isTrue);
      expect(containsDay(set, DateTime(2025, 1, 4)), isFalse);
    });
  });

  group('weekdayShort', () {
    test('returns german abbreviations', () {
      expect(weekdayShort(DateTime.monday), 'Mo');
      expect(weekdayShort(DateTime.tuesday), 'Di');
      expect(weekdayShort(DateTime.wednesday), 'Mi');
      expect(weekdayShort(DateTime.thursday), 'Do');
      expect(weekdayShort(DateTime.friday), 'Fr');
      expect(weekdayShort(DateTime.saturday), 'Sa');
      expect(weekdayShort(DateTime.sunday), 'So');
    });

    test('returns empty string for invalid weekday', () {
      expect(weekdayShort(0), '');
      expect(weekdayShort(8), '');
      expect(weekdayShort(-1), '');
    });
  });

  group('isPastEntry', () {
    test('true if entry.start is strictly before todayStart', () {
      final entry = makeLeave(
        id: 'leave-1',
        start: DateTime(2000, 1, 1),
        end: DateTime(2000, 1, 2),
      );
      expect(isPastEntry(entry), isTrue);
    });

    test('false if entry.start is today (at midnight)', () {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final entry = makeLeave(
        id: '1',
        start: todayStart,
        end: todayStart.add(const Duration(days: 1)),
      );

      expect(isPastEntry(entry), isFalse);
    });

    test('false if entry.start is in the future', () {
      final now = DateTime.now();
      final tomorrow = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(const Duration(days: 1));
      final entry = makeLeave(
        id: '1',
        start: tomorrow,
        end: tomorrow.add(const Duration(days: 2)),
      );

      expect(isPastEntry(entry), isFalse);
    });
  });

  group('inclusiveDays', () {
    test('same day => 1', () {
      expect(inclusiveDays(DateTime(2025, 1, 1), DateTime(2025, 1, 1)), 1);
    });

    test('counts inclusive across days', () {
      expect(inclusiveDays(DateTime(2025, 1, 1), DateTime(2025, 1, 2)), 2);
      expect(inclusiveDays(DateTime(2025, 1, 1), DateTime(2025, 1, 31)), 31);
    });

    test('ignores time portion', () {
      expect(
        inclusiveDays(DateTime(2025, 1, 1, 23, 59), DateTime(2025, 1, 2, 0, 1)),
        2,
      );
    });

    test('works across month/year boundaries', () {
      expect(inclusiveDays(DateTime(2024, 12, 31), DateTime(2025, 1, 1)), 2);
    });

    test('negative range produces <= 0 (current behavior)', () {
      expect(inclusiveDays(DateTime(2025, 1, 2), DateTime(2025, 1, 1)), 0);
    });
  });
}
