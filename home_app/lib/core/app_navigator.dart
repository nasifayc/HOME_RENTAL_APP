import 'package:flutter/material.dart';
// import 'package:home_app/screen/onboarding.dart';
import 'package:home_app/screen/splash_screen.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
