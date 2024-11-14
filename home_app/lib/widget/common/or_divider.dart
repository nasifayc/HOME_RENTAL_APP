import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.tertiary,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "OR",
            style: TextStyle(
              color: theme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.tertiary,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
