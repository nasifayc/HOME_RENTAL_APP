import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/widget/common/welcome_card.dart';
import 'package:home_app/widget/login/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primary,
      body: const Column(
        children: [
          WelcomeCard(),
          SizedBox(
            height: 10,
          ),
          LoginForm()
        ],
      ),
    );
  }
}
