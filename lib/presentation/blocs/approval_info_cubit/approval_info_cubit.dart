import 'package:audavis_time_management/domain/repositories/leave_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'approval_info_state.dart';

class ApprovalInfoCubit extends Cubit<ApprovalInfoState> {
  ApprovalInfoCubit({required this.leaveRepository})
    : super(ApprovalInfoInitial());

  final LeaveRepository leaveRepository;

  Future<void> getUserNameByApprovalId(String approvalId) async {
    emit(ApprovalInfoLoading());
    final info = await leaveRepository.getUserNameByApprovalId(approvalId);
    if (info != null) {
      debugPrint('INFO IS: $info');
      emit(ApprovalInfoLoaded(approvalInfo: info));
    } else {
      emit(
        ApprovalInfoError(
          errorMessage: 'Keine Approval info mit der angegebenen Id',
        ),
      );
    }
  }
}
