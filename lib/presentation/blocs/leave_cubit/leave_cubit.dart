import 'dart:async';

import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/domain/repositories/leave_repository.dart';
import 'package:bloc/bloc.dart';

part 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  LeaveCubit({required this.leaveRepository}) : super(LeaveInitial());

  final LeaveRepository leaveRepository;
  StreamSubscription? _sub;

  void startWatchingAll() {
    emit(LeaveLoading());

    _sub?.cancel();
    _sub = leaveRepository.watchAllLeaves().listen(
      (leaves) => emit(LeaveLoaded(leaves: leaves)),
      onError: (e) {
        emit(LeaveError(message: e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
