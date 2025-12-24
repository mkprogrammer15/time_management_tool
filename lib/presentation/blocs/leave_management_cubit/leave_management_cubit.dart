import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/domain/repositories/leave_repository.dart';
import 'package:bloc/bloc.dart';

part 'leave_management_state.dart';

/// Bloc for managing leave creation, update, and deletion
class LeaveManagementCubit extends Cubit<LeaveManagementState> {
  LeaveManagementCubit({required this.leaveRepository})
    : super(LeaveManagementInitial());

  final LeaveRepository leaveRepository;

  Future<void> createLeave(LeaveEntryEntity entry) async {
    emit(LeaveManagementSaving());
    try {
      await leaveRepository.createLeave(entry);
      emit(LeaveManagementSuccess(action: LeaveAction.create));
    } catch (e) {
      emit(
        LeaveManagementError(action: LeaveAction.create, message: e.toString()),
      );
    }
  }

  Future<void> updateLeave(LeaveEntryEntity entry) async {
    emit(LeaveManagementSaving());
    try {
      await leaveRepository.updateLeaveStatus(
        leaveId: entry.id,
        status: entry.status,
      );
      emit(LeaveManagementSuccess(action: LeaveAction.update));
    } catch (e) {
      emit(
        LeaveManagementError(action: LeaveAction.update, message: e.toString()),
      );
    }
  }

  Future<void> deleteLeave(String leaveId) async {
    emit(LeaveManagementSaving());
    try {
      await leaveRepository.deleteLeave(leaveId);
      emit(LeaveManagementSuccess(action: LeaveAction.delete));
    } catch (e) {
      emit(
        LeaveManagementError(action: LeaveAction.delete, message: e.toString()),
      );
    }
  }
}
