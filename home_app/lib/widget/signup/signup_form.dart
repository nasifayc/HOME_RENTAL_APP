import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/auth.dart';
import 'package:home_app/screen/main_screens/landing_page.dart';
import 'package:home_app/states/auth_state.dart';
import 'package:home_app/widget/common/form_components.dart';
import 'package:home_app/widget/common/primary_button.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? selectedRole;
  String roleError = '';

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    AppTheme theme = AppTheme.of(context);
    FormComponents formComponents = FormComponents(context: context);
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is Authenticated) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandingPage(),
            ));
      }
    }, builder: (context, state) {
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
                          _nameController,
                          Text(
                            'Name',
                            style: theme.typography.titleSmall,
                          ),
                          prefixIcon: const Icon(Icons.person),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'name is required!';
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  state is AuthError && state.name != ''
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
                                    state.name,
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
                      if (value!.trim().length < 6) {
                        return 'Password must be at least 6 characters';
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
                  const SizedBox(
                    height: 20,
                  ),
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
                  const SizedBox(height: 20),
                  PrimaryButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          authCubit.signup(_phoneController.text,
                              _passwordController.text, _nameController.text);
                        }
                      },
                      color: theme.primary,
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Sign Up',
                              style: theme.typography.bodyMediumWhite,
                            )),
                  const SizedBox(
                    height: 10,
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
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed('/login'),
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
