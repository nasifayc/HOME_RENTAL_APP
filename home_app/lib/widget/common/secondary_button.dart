import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';

class SecondaryButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color? color;

  const SecondaryButton(
      {super.key,
      required this.child,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: theme.secondary, width: 1),
            color: color!.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Center(child: child),
      ),
    );
  }
}
