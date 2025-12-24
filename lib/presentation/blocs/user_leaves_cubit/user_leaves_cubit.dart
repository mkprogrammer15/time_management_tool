import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
import 'package:audavis_time_management/domain/repositories/leave_repository.dart';
import 'package:bloc/bloc.dart';

part 'user_leaves_state.dart';

/// Bloc for getting user leaves by its id
class UserLeavesCubit extends Cubit<UserLeavesState> {
  UserLeavesCubit({required this.leaveRepository}) : super(UserLeavesInitial());

  final LeaveRepository leaveRepository;

  Future<void> loadByUserId(String employeeId) async {
    emit(UserLeavesLoading());
    try {
      final leaves = await leaveRepository.fetchLeavesByUserId(employeeId);
      emit(UserLeavesLoaded(leaves: leaves));
    } catch (e) {
      emit(UserLeavesError(message: e.toString()));
    }
  }
}
