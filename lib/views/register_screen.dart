import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_tanker/providers/theme_provider.dart';
import 'package:water_tanker/views/home_screen.dart';
import 'package:water_tanker/views/main_screen.dart';

import '../blocs/navigation_bloc.dart';
import '../events/navigation_event.dart';
import '../utils/mediaquery.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  void _goToLoginScreen() {
    Navigator.pop(context);
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || phoneNumber.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("All fields are required.");
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar("Passwords do not match.");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'phoneNumber': phoneNumber,
        'email': email,
        'theme': Provider.of<ThemeProvider>(context, listen: false).themeMode.toString(),
      });

      if (!mounted) return;

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } catch (e) {
      _showSnackbar("Registration failed. Please try again.");
    }
  }

  void _googleSignUp() {
    // Handle Google Sign-Up
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQueryHelper = MediaQueryHelper(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Register",
          style: TextStyle(
            fontSize: mediaQueryHelper.scaledFontSize(0.07),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mediaQueryHelper.scaledWidth(0.04)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Lottie.asset(
                'assets/anim/login_register.json',
                height: mediaQueryHelper.scaledWidth(0.5),
                width: mediaQueryHelper.scaledWidth(0.5),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                minimumSize:
                Size(double.infinity, mediaQueryHelper.scaledHeight(0.06)),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mediaQueryHelper.scaledFontSize(0.04),
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            ElevatedButton(
              onPressed: _googleSignUp,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white30,
                minimumSize:
                Size(double.infinity, mediaQueryHelper.scaledHeight(0.06)),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png',
                    height: mediaQueryHelper.scaledHeight(0.04),
                  ),
                  SizedBox(width: mediaQueryHelper.scaledWidth(0.02)),
                  Text(
                    'Sign Up with Google',
                    style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: mediaQueryHelper.scaledFontSize(0.04),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: mediaQueryHelper.scaledFontSize(0.04),
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToLoginScreen,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQueryHelper.scaledFontSize(0.04),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}