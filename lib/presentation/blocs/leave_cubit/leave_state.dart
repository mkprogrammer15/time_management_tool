part of 'leave_cubit.dart';

sealed class LeaveState {}

final class LeaveInitial extends LeaveState {}

final class LeaveLoading extends LeaveState {}

final class LeaveLoaded extends LeaveState {
  final List<LeaveEntryEntity> leaves;
  LeaveLoaded({required this.leaves});
}

final class LeaveError extends LeaveState {
  final String message;
  LeaveError({required this.message});
}
