part of 'leave_management_cubit.dart';

abstract class LeaveManagementState {}

class LeaveManagementInitial extends LeaveManagementState {}

class LeaveManagementSaving extends LeaveManagementState {}

class LeaveManagementSuccess extends LeaveManagementState {
  final LeaveAction action;
  LeaveManagementSuccess({required this.action});
}

class LeaveManagementError extends LeaveManagementState {
  final LeaveAction action;
  final String message;

  LeaveManagementError({required this.action, required this.message});
}

enum LeaveAction { create, update, delete }
