part of 'auth_cubit.dart';

sealed class AuthState {}

class AuthUnknown extends AuthState {}

class LoggedOut extends AuthState {}

class LoggedIn extends AuthState {
  final String uid;
  final String name;
  final String email;

  LoggedIn({required this.uid, required this.name, required this.email});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
