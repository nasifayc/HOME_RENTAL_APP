import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/widget/common/form_components.dart';
import 'package:home_app/widget/common/google_auth_button.dart';
import 'package:home_app/widget/common/or_divider.dart';
import 'package:home_app/widget/common/primary_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  "Welcome Back",
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
                formComponents.buildNormalTextField(
                  _emailController,
                  Text(
                    'Email',
                    style: theme.typography.titleSmall,
                  ),
                  prefixIcon: const Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'username is required!';
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
                    if (value == null || value.isEmpty) {
                      return 'password is required!';
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
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   content: const Text("Welcome!"),
                        //   backgroundColor: theme.primary,
                        // ));

                        Navigator.of(context).pushNamed('/otp');
                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           const LandingPage()), // Your main screen widget
                        //   (route) => false,
                        // );
                      }
                    },
                    color: theme.primary,
                    child: Text(
                      'Login',
                      style: theme.typography.bodyMediumWhite,
                    )),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: theme.typography.bodyMedium,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushReplacementNamed('/signup'),
                      child: Text(
                        'Sign Up',
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
