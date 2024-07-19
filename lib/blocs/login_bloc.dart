import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../events/login_event.dart';
import '../states/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginBloc() : super(LoginInitial()) {
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  Future<void> _onLoginWithEmailAndPassword(
      LoginWithEmailAndPassword event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  Future<void> _onLoginWithGoogle(
      LoginWithGoogle event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(LoginInitial());
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibility event, Emitter<LoginState> emit) {
    _obscurePassword = !_obscurePassword;
    emit(PasswordVisibilityToggled(obscurePassword: _obscurePassword));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
