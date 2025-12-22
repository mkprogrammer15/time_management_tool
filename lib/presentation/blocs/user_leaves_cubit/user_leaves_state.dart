part of 'user_leaves_cubit.dart';

sealed class UserLeavesState {
  const UserLeavesState();
}

class UserLeavesInitial extends UserLeavesState {
  const UserLeavesInitial();
}

class UserLeavesLoading extends UserLeavesState {
  const UserLeavesLoading();
}

class UserLeavesLoaded extends UserLeavesState {
  const UserLeavesLoaded({required this.leaves});

  final List<LeaveEntryEntity> leaves;
}

class UserLeavesError extends UserLeavesState {
  const UserLeavesError({required this.message});

  final String message;
}
