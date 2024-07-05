import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_tanker/providers/theme_provider.dart';
import 'package:water_tanker/views/main_screen.dart';
import 'package:water_tanker/views/register_screen.dart';

import '../blocs/navigation_bloc.dart';
import '../events/navigation_event.dart';
import '../utils/mediaquery.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Email and Password are required.");
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;

      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      await themeProvider.saveThemeToFirebase(themeProvider.themeMode);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      _showSnackbar("Login failed. Please try again.");
    }
  }


  void _goToRegisterScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  void _googleSignIn() {
    // Handle Google Sign-In
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
          "Login",
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
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(double.infinity, mediaQueryHelper.scaledHeight(0.06)),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mediaQueryHelper.scaledFontSize(0.04),
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            ElevatedButton(
              onPressed: _googleSignIn,
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
                    'Sign In with Google',
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
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: mediaQueryHelper.scaledFontSize(0.04),
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToRegisterScreen,
                    child: Text(
                      'Register',
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
