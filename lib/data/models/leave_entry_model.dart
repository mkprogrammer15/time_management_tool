import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

LeaveDayType _parseLeaveDayType(dynamic v) {
  final s = (v?.toString() ?? '').trim().toLowerCase();

  switch (s) {
    // Full day
    case 'full day':
    case 'fullday':
    case 'full_day':
      return LeaveDayType.fullDay;
    case 'half day':
    case 'Half Day':
    case 'half':
      return LeaveDayType.halfDay;
    default:
      // Fallback: try enum names (fullDay, halfDayMorning, ...)
      return LeaveDayType.values.firstWhere(
        (e) => e.name.toLowerCase() == s,
        orElse: () => LeaveDayType.fullDay,
      );
  }
}

LeaveType _parseLeaveType(dynamic v) {
  final s = (v?.toString() ?? '').trim().toLowerCase();
  switch (s) {
    case 'vacation':
      return LeaveType.vacation;
    case 'sick':
    case 'sickness':
    case 'sickleave':
    case 'sick_leave':
      return LeaveType.sick;
    default:
      return LeaveType.vacation;
  }
}

LeaveStatus _parseLeaveStatus(dynamic v) {
  final s = (v?.toString() ?? '').trim().toLowerCase();
  switch (s) {
    case 'requested':
      return LeaveStatus.requested;
    case 'approved':
      return LeaveStatus.approved;
    case 'rejected':
      return LeaveStatus.rejected;
    default:
      return LeaveStatus.requested;
  }
}

class LeaveEntryDto extends LeaveEntryEntity {
  const LeaveEntryDto({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    required super.start,
    required super.end,
    required super.createdAt,
    required super.updatedAt,
    required super.type,
    required super.status,
    required super.dayType,
    super.approverId,
  });

  factory LeaveEntryDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return LeaveEntryDto(
      id: doc.id,
      employeeId: data['employeeId'] as String,
      employeeName: (data['employeeName'] as String?) ?? '',
      start: (data['start'] as Timestamp).toDate(),
      end: (data['end'] as Timestamp).toDate(),

      createdAt: (data['createdAt'] as Timestamp?)!.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)!.toDate(),
      type: _parseLeaveType(data['type']),
      status: _parseLeaveStatus(data['status']),
      dayType: _parseLeaveDayType(data['dayType']),
      approverId: data['approverId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore({bool isCreate = false}) {
    final map = <String, dynamic>{
      'employeeId': employeeId,
      'employeeName': employeeName,
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
      'type': type.value,
      'status': status.value,
      'dayType': dayType.value,
      'approverId': approverId,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (isCreate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }

    return map;
  }

  static LeaveEntryDto fromEntity(LeaveEntryEntity entity) {
    return LeaveEntryDto(
      id: entity.id,
      employeeId: entity.employeeId,
      employeeName: entity.employeeName,
      start: entity.start,
      end: entity.end,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      type: entity.type,
      status: entity.status,
      dayType: entity.dayType,
      approverId: entity.approverId,
    );
  }
}
