import 'package:flutter/material.dart';
import 'package:home_app/core/theme/theme_data_factory.dart';

import 'app_typography.dart';

abstract class AppTheme {
  static AppTheme of(BuildContext context) {
    return LightModeTheme();
  }

  late Brightness brightness;
  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late double radius;

  late LinearGradient primaryBackgroundGradient;

  late Color warning;
  late Color error;

  AppTypography get typography => ThemeTypography(this);
  ThemeData get themeData => ThemeDataFactory.toThemeData(this);
}

class LightModeTheme extends AppTheme {
  @override
  Brightness get brightness => Brightness.light;
  @override
  Color get primary => const Color(0xFF4A90E2);
  @override
  Color get secondary => const Color(0xFF000000);
  @override
  Color get tertiary => const Color(0xFF9E9E9E);

  @override
  Color get primaryText => const Color(0xFF000000);
  @override
  Color get secondaryText => const Color(0xFFFFFFFF);

  @override
  Color get primaryBackground => const Color(0xFFFFFFFF);
  @override
  LinearGradient get primaryBackgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromARGB(255, 0, 196, 196), Color(0xFF008080)],
      );

  @override
  Color get secondaryBackground => const Color(0xFF475AD7);

  @override
  Color get warning => const Color(0xFFF9CF58);
  @override
  Color get error => const Color(0xFFE50000);

  @override
  double get radius => 40;
}
