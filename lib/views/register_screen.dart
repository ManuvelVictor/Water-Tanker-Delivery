import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:water_tanker/providers/theme_provider.dart';
import 'package:water_tanker/views/login_screen.dart';

import '../utils/mediaquery.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQueryHelper = MediaQueryHelper(context);

    return Scaffold(
      appBar: AppBar(
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
            onPressed: () {
              final themeProvider =
              Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
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
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            TextField(
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
            TextField(
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
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
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            ElevatedButton(
              onPressed: () {
                // Handle registration
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
                'Register',
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

  void _goToLoginScreen() {
    Navigator.pop(context);
  }
}