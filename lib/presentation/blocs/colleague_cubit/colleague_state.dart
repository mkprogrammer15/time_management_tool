part of 'colleague_cubit.dart';

sealed class ColleaguesState {}

final class ColleaguesInitial extends ColleaguesState {}

final class ColleaguesLoading extends ColleaguesState {}

final class ColleaguesLoaded extends ColleaguesState {
  final List<ColleagueEntity> colleagues;
  ColleaguesLoaded({required this.colleagues});
}

final class ColleaguesError extends ColleaguesState {
  final String message;
  ColleaguesError(this.message);
}
