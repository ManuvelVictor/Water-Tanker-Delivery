import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PasswordVisibilityToggled extends RegisterState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  PasswordVisibilityToggled({
    required this.obscurePassword,
    required this.obscureConfirmPassword,
  });

  @override
  List<Object?> get props => [obscurePassword, obscureConfirmPassword];
}
