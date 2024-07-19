import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:water_tanker/events/theme_event.dart';
import 'package:water_tanker/states/theme_state.dart';

import '../blocs/register_bloc.dart';
import '../blocs/theme_bloc.dart';
import '../events/register_event.dart';
import '../states/register_state.dart';
import '../utils/mediaquery.dart';
import 'main_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryHelper = MediaQueryHelper(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, registerState) {
            if (registerState is RegisterSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            } else if (registerState is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(registerState.error),
                  backgroundColor: Colors.red,
                  showCloseIcon: true,
                  closeIconColor: Colors.white,
                ),
              );
            }
          },
          builder: (context, registerState) {
            return Stack(
              children: [
                Scaffold(
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
                          label: 'Username',
                          controller:
                              context.read<RegisterBloc>().usernameController,
                        ),
                        SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                        _buildTextField(
                          context: context,
                          label: 'Phone Number',
                          controller: context
                              .read<RegisterBloc>()
                              .phoneNumberController,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                        _buildTextField(
                          keyboardType: TextInputType.emailAddress,
                          context: context,
                          label: 'Email',
                          controller:
                              context.read<RegisterBloc>().emailController,
                        ),
                        SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                        _buildPasswordTextField(
                          context: context,
                          label: 'Password',
                          controller:
                              context.read<RegisterBloc>().passwordController,
                          obscureText:
                              (registerState is PasswordVisibilityToggled)
                                  ? registerState.obscurePassword
                                  : true,
                          toggleVisibility: () {
                            context
                                .read<RegisterBloc>()
                                .add(TogglePasswordVisibility());
                          },
                        ),
                        SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                        _buildPasswordTextField(
                          context: context,
                          label: 'Confirm Password',
                          controller: context
                              .read<RegisterBloc>()
                              .confirmPasswordController,
                          obscureText:
                              (registerState is PasswordVisibilityToggled)
                                  ? registerState.obscureConfirmPassword
                                  : true,
                          toggleVisibility: () {
                            context
                                .read<RegisterBloc>()
                                .add(ToggleConfirmPasswordVisibility());
                          },
                        ),
                        SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RegisterBloc>().add(
                                  RegisterWithEmailAndPassword(
                                    username: context
                                        .read<RegisterBloc>()
                                        .usernameController
                                        .text,
                                    phoneNumber: context
                                        .read<RegisterBloc>()
                                        .phoneNumberController
                                        .text,
                                    email: context
                                        .read<RegisterBloc>()
                                        .emailController
                                        .text,
                                    password: context
                                        .read<RegisterBloc>()
                                        .passwordController
                                        .text,
                                    confirmPassword: context
                                        .read<RegisterBloc>()
                                        .confirmPasswordController
                                        .text,
                                  ),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                mediaQueryHelper.scaledHeight(0.06)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  mediaQueryHelper.scaledWidth(0.02)),
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
                          onPressed: () {
                            context
                                .read<RegisterBloc>()
                                .add(RegisterWithGoogle());
                          },
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
                              SizedBox(
                                  width: mediaQueryHelper.scaledWidth(0.02)),
                              Text(
                                'Sign Up with Google',
                                style: TextStyle(
                                  color: themeState.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize:
                                      mediaQueryHelper.scaledFontSize(0.04),
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
                                  fontSize:
                                      mediaQueryHelper.scaledFontSize(0.04),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        mediaQueryHelper.scaledFontSize(0.04),
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
                if (registerState is RegisterLoading)
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    final mediaQueryHelper = MediaQueryHelper(context);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
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
          borderRadius:
              BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
