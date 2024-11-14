import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Center(
      child: Text(
        "Home",
        style: theme.typography.headlineMedium,
      ),
    );
  }
}
