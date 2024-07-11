import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:water_tanker/blocs/theme_bloc.dart';
import 'package:water_tanker/events/theme_event.dart';
import '../events/login_event.dart';
import '../states/login_state.dart';
import '../states/theme_state.dart';
import '../utils/mediaquery.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import '../blocs/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryHelper = MediaQueryHelper(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
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
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          context.read<ThemeBloc>().add(ToggleThemeEvent());
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
                        _buildTextField(
                          context: context,
                          label: 'Email',
                          controller: context.read<LoginBloc>().emailController,
                        ),
                        SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                        _buildPasswordTextField(
                          context: context,
                          label: 'Password',
                          controller: context.read<LoginBloc>().passwordController,
                          obscureText: (state is PasswordVisibilityToggled)
                              ? state.obscurePassword
                              : true,
                          toggleVisibility: () {
                            context.read<LoginBloc>().add(TogglePasswordVisibility());
                          },
                        ),
                        SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                        ElevatedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(
                              LoginWithEmailAndPassword(
                                email: context.read<LoginBloc>().emailController.text,
                                password: context.read<LoginBloc>().passwordController.text,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, mediaQueryHelper.scaledHeight(0.06)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
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
                          onPressed: () {
                            context.read<LoginBloc>().add(LoginWithGoogle());
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white30,
                            minimumSize: Size(double.infinity, mediaQueryHelper.scaledHeight(0.06)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                  );
                                },
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
                if (state is LoginLoading)
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
      },
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
  }) {
    final mediaQueryHelper = MediaQueryHelper(context);
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    final mediaQueryHelper = MediaQueryHelper(context);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}