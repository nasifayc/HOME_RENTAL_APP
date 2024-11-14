import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/widget/common/form_components.dart';
import 'package:home_app/widget/common/google_auth_button.dart';
import 'package:home_app/widget/common/or_divider.dart';
import 'package:home_app/widget/common/primary_button.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    FormComponents formComponents = FormComponents(context: context);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Create account",
                  style: theme.typography.headlineMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Enter your details below",
                  style: theme.typography.titleSmall,
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Expanded(
                      child: formComponents.buildNormalTextField(
                        _usernameController,
                        Text(
                          'Username',
                          style: theme.typography.titleSmall,
                        ),
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'username is required!';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: formComponents.buildNormalTextField(
                        _emailController,
                        Text(
                          'Email',
                          style: theme.typography.titleSmall,
                        ),
                        prefixIcon: const Icon(Icons.email),
                        validator: (value) {
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (value == null || value.isEmpty) {
                            return 'email is required!';
                          }

                          // Validate email format
                          if (!emailRegex
                              .hasMatch(_emailController.text.trim())) {
                            return 'Invalid email format.';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                formComponents.buildNormalTextField(
                  _phoneController,
                  Text(
                    "Phone",
                    style: theme.typography.titleSmall,
                  ),
                  prefixIcon: const Icon(Icons.phone),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'phone is required!';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                formComponents.buildPasswordField(
                  _passwordController,
                  Text(
                    'Password',
                    style: theme.typography.titleSmall,
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) {
                    final passwordRegex =
                        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
                    if (value == null || value.isEmpty) {
                      return 'password is required!';
                    }

                    if (!passwordRegex
                        .hasMatch(_passwordController.text.trim())) {
                      return 'Password must be at least 8 characters long and contain both letters and numbers.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Data Submited successfuly"),
                            backgroundColor: theme.primary,
                          ),
                        );
                        Navigator.of(context).pushNamed('/otp');
                      }
                    },
                    color: theme.primary,
                    child: Text(
                      'Sign Up',
                      style: theme.typography.bodyMediumWhite,
                    )),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have an account?',
                      style: theme.typography.bodyMedium,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushReplacementNamed('/login'),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                const OrDivider(),
                const SizedBox(
                  height: 25,
                ),
                const GoogleAuthButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
