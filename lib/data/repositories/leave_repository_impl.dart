import 'package:audavis_time_management/data/data_source/leave_remote_datasource.dart';
import 'package:audavis_time_management/data/models/leave_entry_model.dart';
import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/domain/repositories/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  LeaveRepositoryImpl({required this.leaveRemoteDataSource});

  final LeaveRemoteDataSource leaveRemoteDataSource;

  @override
  Stream<List<LeaveEntryEntity>> watchAllLeaves() {
    return leaveRemoteDataSource.watchAll().map((snap) {
      final result = <LeaveEntryEntity>[];

      for (final d in snap.docs) {
        try {
          result.add(LeaveEntryDto.fromDoc(d));
        } catch (e, st) {}
      }

      return result;
    });
  }

  @override
  Future<List<LeaveEntryEntity>> fetchAllLeaves() async {
    final snap = await leaveRemoteDataSource.fetchAll();
    return snap.docs.map(LeaveEntryDto.fromDoc).toList();
  }

  @override
  Future<void> createLeave(LeaveEntryEntity entry) {
    final dto = LeaveEntryDto.fromEntity(entry);
    return leaveRemoteDataSource.create(dto.toFirestore(isCreate: true));
  }

  @override
  Future<void> updateLeaveStatus({
    required String leaveId,
    required LeaveStatus status,
    String? approverId,
  }) {
    return leaveRemoteDataSource.updateLeave(leaveId, {
      'status': status.name,
      if (approverId != null) 'approverId': approverId,
    });
  }

  @override
  Future<void> deleteLeave(String leaveId) {
    return leaveRemoteDataSource.delete(leaveId);
  }

  @override
  Future<List<LeaveEntryEntity>> fetchLeavesByUserId(String employeeId) async {
    final snap = await leaveRemoteDataSource.fetchAll();

    return snap.docs
        .map(LeaveEntryDto.fromDoc)
        .where((e) => e.employeeId == employeeId)
        .toList();
  }
}
