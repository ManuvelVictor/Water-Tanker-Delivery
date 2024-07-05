import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    saveThemeToFirebase(_themeMode);
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    saveThemeToFirebase(_themeMode);
  }

  Future<void> saveThemeToFirebase(ThemeMode themeMode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'theme': _themeMode == ThemeMode.dark ? 'ThemeMode.dark' : 'ThemeMode.light',
      });
    }
  }

  Future<void> loadThemeFromFirebase() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final themeStr = userDoc.data()?['theme'] ?? 'ThemeMode.light';
        _themeMode = themeStr == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.light;
        notifyListeners();
      }
    }
  }
}
