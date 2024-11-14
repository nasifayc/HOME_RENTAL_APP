import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Center(
      child: Text(
        "Chat",
        style: theme.typography.headlineMedium,
      ),
    );
  }
}
