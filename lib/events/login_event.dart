import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginWithEmailAndPassword extends LoginEvent {
  final String email;
  final String password;

  LoginWithEmailAndPassword({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogle extends LoginEvent {}

class TogglePasswordVisibility extends LoginEvent {}
