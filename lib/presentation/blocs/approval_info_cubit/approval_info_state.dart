part of 'approval_info_cubit.dart';

sealed class ApprovalInfoState {}

final class ApprovalInfoInitial extends ApprovalInfoState {}

final class ApprovalInfoLoaded extends ApprovalInfoState {
  final String approvalInfo;

  ApprovalInfoLoaded({required this.approvalInfo});
}

final class ApprovalInfoError extends ApprovalInfoState {
  final String errorMessage;

  ApprovalInfoError({required this.errorMessage});
}

final class ApprovalInfoLoading extends ApprovalInfoState {}
