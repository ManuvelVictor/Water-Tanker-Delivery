import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:water_tanker/providers/theme_provider.dart';
import 'package:water_tanker/views/register_screen.dart';

import '../utils/mediaquery.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _goToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQueryHelper = MediaQueryHelper(context);

    return Scaffold(
      appBar: AppBar(
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
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            ElevatedButton(
              onPressed: () {
                // Handle login
              },
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
          ],
        ),
      ),
    );
  }
}
