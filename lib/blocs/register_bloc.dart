import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../events/register_event.dart';
import '../states/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterWithEmailAndPassword>((event, emit) async {
      emit(RegisterLoading());
      try {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final uid = userCredential.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'username': event.username,
          'phoneNumber': event.phoneNumber,
          'email': event.email,
        });

        final User user = userCredential.user!;

        await user.updateProfile(displayName: event.username);

        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });

    on<RegisterWithGoogle>((event, emit) async {
      emit(RegisterLoading());
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          emit(RegisterFailure(error: 'Google Sign-In cancelled.'));
          return;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });

    on<TogglePasswordVisibility>((event, emit) {
      _obscurePassword = !_obscurePassword;
      emit(PasswordVisibilityToggled(
        obscurePassword: _obscurePassword,
        obscureConfirmPassword: _obscureConfirmPassword,
      ));
    });

    on<ToggleConfirmPasswordVisibility>((event, emit) {
      _obscureConfirmPassword = !_obscureConfirmPassword;
      emit(PasswordVisibilityToggled(
        obscurePassword: _obscurePassword,
        obscureConfirmPassword: _obscureConfirmPassword,
      ));
    });
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
