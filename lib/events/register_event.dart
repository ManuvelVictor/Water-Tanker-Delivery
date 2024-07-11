import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterWithEmailAndPassword extends RegisterEvent {
  final String username;
  final String phoneNumber;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterWithEmailAndPassword({
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [username, phoneNumber, email, password, confirmPassword];
}

class RegisterWithGoogle extends RegisterEvent {}

class TogglePasswordVisibility extends RegisterEvent {}

class ToggleConfirmPasswordVisibility extends RegisterEvent {}
