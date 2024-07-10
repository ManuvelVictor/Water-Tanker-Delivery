import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/theme_event.dart';
import '../states/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.light)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  Future<void> _onLoadTheme(
      LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final themeStr = userDoc.data()?['theme'] ?? 'ThemeMode.light';
        final themeMode =
        themeStr == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.light;
        emit(ThemeState(themeMode));
      }
    }
  }

  Future<void> _onToggleTheme(
      ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newThemeMode =
    state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(newThemeMode));
    await _saveThemeToFirebase(newThemeMode);
  }

  Future<void> _onSetTheme(
      SetThemeEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeState(event.themeMode));
    await _saveThemeToFirebase(event.themeMode);
  }

  Future<void> _saveThemeToFirebase(ThemeMode themeMode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'theme':
        themeMode == ThemeMode.dark ? 'ThemeMode.dark' : 'ThemeMode.light',
      });
    }
  }
}
