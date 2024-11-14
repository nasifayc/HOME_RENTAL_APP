import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Center(
      child: Text(
        "Post",
        style: theme.typography.headlineMedium,
      ),
    );
  }
}
