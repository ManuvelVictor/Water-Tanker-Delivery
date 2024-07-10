import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_tanker/blocs/theme_bloc.dart';
import 'package:water_tanker/events/theme_event.dart';
import '../states/theme_state.dart';
import '../utils/mediaquery.dart';
import 'main_screen.dart';
import 'register_screen.dart';

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
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleTheme() {
    HapticFeedback.heavyImpact();
    context.read<ThemeBloc>().add(ToggleThemeEvent());
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Email and Password are required.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      _showSnackbar("Login failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _googleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      _showSnackbar("Google Sign-In failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.red,
          showCloseIcon: true,
          closeIconColor: Colors.white,
          content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryHelper = MediaQueryHelper(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Stack(
          children: [
            Scaffold(
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
                      themeState.themeMode == ThemeMode.dark
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
                          borderRadius: BorderRadius.circular(
                              mediaQueryHelper.scaledWidth(0.02)),
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
                          borderRadius: BorderRadius.circular(
                              mediaQueryHelper.scaledWidth(0.02)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity,
                            mediaQueryHelper.scaledHeight(0.06)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              mediaQueryHelper.scaledWidth(0.02)),
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
                        minimumSize: Size(double.infinity,
                            mediaQueryHelper.scaledHeight(0.06)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              mediaQueryHelper.scaledWidth(0.02)),
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
                              color: themeState.themeMode == ThemeMode.dark
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
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
