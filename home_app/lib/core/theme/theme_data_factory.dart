import 'package:flutter/material.dart';

import 'app_theme.dart';

class ThemeDataFactory {
  static ThemeData toThemeData(AppTheme theme) {
    return ThemeData(
        useMaterial3: false,
        brightness: theme.brightness,
        fontFamily: theme.typography.fontFamily,
        colorScheme: ColorScheme.fromSeed(
            seedColor: theme.primary,
            brightness: theme.brightness,
            primary: theme.primary,
            onPrimary: theme.primaryText,
            secondary: theme.secondary,
            onSecondary: theme.secondaryText,
            error: theme.error,
            onError: theme.error,
            surface: theme.secondaryBackground,
            onSurface: theme.primaryText),
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: theme.secondaryBackground),
        appBarTheme: AppBarTheme(
          backgroundColor: theme.primaryBackground,
          iconTheme: IconThemeData(
            color: theme.primaryText,
          ),
          titleTextStyle: TextStyle(color: theme.primaryText, fontSize: 21),
        ),
        dialogTheme: DialogTheme(backgroundColor: theme.secondaryBackground),
        primaryColor: theme.primary,
        iconTheme: IconThemeData(
          color: theme.primaryText,
        ),
        bannerTheme: const MaterialBannerThemeData(),
        chipTheme: const ChipThemeData(),
        snackBarTheme:
            SnackBarThemeData(backgroundColor: theme.secondaryBackground),
        scaffoldBackgroundColor: theme.primaryBackground,
        radioTheme: RadioThemeData(
          fillColor: WidgetStatePropertyAll(theme.primary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              theme.primary,
            ),
            foregroundColor: WidgetStatePropertyAll(
              theme.primary,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                theme.primary,
              ),
              // maximumSize: MaterialStateProperty.all(const Size(200, 60)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(theme.radius),
                      side: BorderSide(
                        color: theme.primary,
                      )))),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          refreshBackgroundColor: theme.secondaryBackground,
          color: theme.primary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: theme.primary,
          selectionHandleColor: theme.primary,
          selectionColor: Colors.black12,
        ),
        indicatorColor: theme.primary,
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStatePropertyAll(
            theme.primary,
          ),
          trackColor: const WidgetStatePropertyAll(
            Color(0xFF06309A),
          ),
        ),
        dividerTheme: const DividerThemeData(color: Colors.black12),
        textTheme: TextTheme(
          bodyLarge: theme.typography.bodyLargeWhite,
          bodyMedium: theme.typography.bodyMediumWhite,
          bodySmall: theme.typography.bodySmallWhite,
          displayLarge: theme.typography.displayLarge,
          displayMedium: theme.typography.displayMedium,
          displaySmall: theme.typography.displaySmall,
          headlineLarge: theme.typography.headlineLarge,
          headlineMedium: theme.typography.headlineMedium,
          headlineSmall: theme.typography.headlineSmall,
          labelLarge: theme.typography.labelLarge,
          labelMedium: theme.typography.labelMedium,
          labelSmall: theme.typography.labelSmall,
          titleLarge: theme.typography.titleLarge,
          titleMedium: theme.typography.titleMedium,
          titleSmall: theme.typography.titleSmall,
        ));
  }
}
