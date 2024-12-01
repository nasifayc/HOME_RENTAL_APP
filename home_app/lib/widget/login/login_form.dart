import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/auth.dart';
import 'package:home_app/screen/main_screens/landing_page.dart';
import 'package:home_app/states/auth_state.dart';
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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    AppTheme theme = AppTheme.of(context);
    FormComponents formComponents = FormComponents(context: context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LandingPage(),
              ));
        }
      },
      builder: (context, state) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
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
                      _phoneController,
                      Text(
                        'Phone Number',
                        style: theme.typography.titleSmall,
                      ),
                      prefixIcon: const Icon(Icons.phone),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone Number is required!';
                        }

                        return null;
                      },
                    ),
                    state is AuthError && state.phoneNumber != ''
                        ? Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 6,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.phoneNumber,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 204, 43, 31)),
                                    )),
                              ],
                            ),
                          )
                        : const SizedBox(),
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
                    state is AuthError && state.password != ''
                        ? Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 6,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.password,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 204, 43, 31)),
                                    )),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    state is AuthError && state.server != ''
                        ? Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 6,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.server,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 204, 43, 31)),
                                    )),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            authCubit.login(_phoneController.text,
                                _passwordController.text);
                          }
                        },
                        color: theme.primary,
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Text(
                                'Login',
                                style: theme.typography.bodyMediumWhite,
                              )),
                    const SizedBox(
                      height: 10,
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
                          onTap: () => Navigator.of(context)
                              .pushReplacementNamed('/signup'),
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
      },
    );
  }
}
