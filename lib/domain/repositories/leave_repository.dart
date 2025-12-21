import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';

abstract interface class LeaveRepository {
  Stream<List<LeaveEntryEntity>> watchAllLeaves();
  Future<List<LeaveEntryEntity>> fetchAllLeaves();

  Future<void> createLeave(LeaveEntryEntity entry);

  Future<void> updateLeaveStatus({
    required String leaveId,
    required LeaveStatus status,
    String? approverId,
  });

  Future<void> deleteLeave(String leaveId);

  Future<List<LeaveEntryEntity>> fetchLeavesByUserId(String employeeId);
}
