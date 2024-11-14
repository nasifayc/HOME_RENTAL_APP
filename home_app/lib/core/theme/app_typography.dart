import 'package:flutter/material.dart';
import 'app_theme.dart';

abstract class AppTypography {
  String get fontFamily;
  TextStyle get displayLarge;
  TextStyle get displayMedium;
  TextStyle get displaySmall;
  TextStyle get headlineLarge;
  TextStyle get headlineMedium;
  TextStyle get headlineSmall;
  TextStyle get titleLarge;
  TextStyle get titleMedium;
  TextStyle get titleSmall;
  TextStyle get labelLarge;
  TextStyle get labelMedium;
  TextStyle get labelSmall;
  TextStyle get bodyLarge;
  TextStyle get bodyMedium;
  TextStyle get bodySmall;
  TextStyle get bodyLargeWhite;
  TextStyle get bodyMediumWhite;
  TextStyle get bodySmallWhite;
}

class ThemeTypography extends AppTypography {
  ThemeTypography(this.theme);

  final AppTheme theme;

  @override
  String get fontFamily => "roboto";
  @override
  TextStyle get displayLarge => TextStyle(
        fontFamily: fontFamily,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 32,
      );
  @override
  TextStyle get displayMedium => TextStyle(
        fontFamily: fontFamily,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 24,
      );
  @override
  TextStyle get displaySmall => TextStyle(
        fontFamily: fontFamily,
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  @override
  TextStyle get headlineLarge => TextStyle(
        fontFamily: fontFamily,
        color: theme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      );
  @override
  TextStyle get headlineMedium => TextStyle(
        fontFamily: fontFamily,
        color: theme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      );

  @override
  TextStyle get headlineSmall => TextStyle(
        fontFamily: fontFamily,
        color: theme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );

  @override
  TextStyle get titleLarge => TextStyle(
      fontFamily: fontFamily,
      color: theme.primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 22,
      overflow: TextOverflow.ellipsis);

  @override
  TextStyle get titleMedium => TextStyle(
      fontFamily: fontFamily,
      color: theme.primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 18,
      overflow: TextOverflow.ellipsis);

  @override
  TextStyle get titleSmall => TextStyle(
      fontFamily: fontFamily,
      color: theme.tertiary,
      fontWeight: FontWeight.normal,
      fontSize: 16,
      overflow: TextOverflow.ellipsis);

  @override
  TextStyle get labelLarge => TextStyle(
        fontFamily: fontFamily,
        color: theme.primaryBackground,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      );
  @override
  TextStyle get labelMedium => TextStyle(
      fontFamily: fontFamily,
      color: theme.primaryBackground,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      overflow: TextOverflow.ellipsis);

  @override
  TextStyle get labelSmall => TextStyle(
        fontFamily: fontFamily,
        color: theme.primaryBackground,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
  @override
  TextStyle get bodyLarge => TextStyle(
        fontFamily: fontFamily,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 22,
      );

  @override
  TextStyle get bodyMedium => TextStyle(
        fontFamily: fontFamily,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );

  @override
  TextStyle get bodySmall => TextStyle(
        fontFamily: fontFamily,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  @override
  TextStyle get bodyLargeWhite => TextStyle(
        fontFamily: fontFamily,
        color: theme.secondaryText,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      );
  @override
  TextStyle get bodyMediumWhite => TextStyle(
        fontFamily: fontFamily,
        color: theme.secondaryText,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      );
  @override
  TextStyle get bodySmallWhite => TextStyle(
        fontFamily: fontFamily,
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
}
