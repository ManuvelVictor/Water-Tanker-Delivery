import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import 'about_app_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'privacy_policy_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutAlert(BuildContext context, ThemeProvider themeProvider) {
    final theme = themeProvider.themeMode;
    final backgroundColor =
        theme == ThemeMode.dark ? Colors.black : Colors.white;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                HapticFeedback.heavyImpact();
                await _logout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              _showLogoutAlert(context, themeProvider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),

            // Privacy Policy Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen()),
                );
              },
              child: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),

            // About App Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutAppScreen()),
                );
              },
              child: const Text(
                'About App',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final providerData = user.providerData;
        for (var info in providerData) {
          if (info.providerId == 'google.com') {
            await GoogleSignIn().signOut();
            break;
          }
        }
      }
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Text('Logout failed. Please try again.')),
      );
    }
  }
}
