import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class PasswordVisibilityToggled extends LoginState {
  final bool obscurePassword;

  PasswordVisibilityToggled({required this.obscurePassword});

  @override
  List<Object> get props => [obscurePassword];
}
