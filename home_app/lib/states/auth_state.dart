import 'package:home_app/model/token_model.dart';

sealed class AuthState {}

abstract class AuthActionState extends AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthActionState {
  final AuthToken authToken;
  Authenticated({required this.authToken});
}

class UnAuthenticated extends AuthActionState {}

class AuthError extends AuthActionState {
  final String phoneNumber;
  final String password;
  final String name;
  final String role;
  final String server;

  AuthError(this.phoneNumber, this.password, this.name, this.server, this.role);
}

class ChangeSuccessState extends AuthState {}
