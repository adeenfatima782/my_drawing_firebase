// lib/core/theme.dart
import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  /// Dark theme (based on your current AppTheme variable)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark,
    primaryColor: AppColors.accentBlue,

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xff3E64FF),
      elevation: 5,
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentBlue,
    ),
  );

  /// Light theme (optional, can customize)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.accentBlue,

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xff3E64FF),
      elevation: 5,
    ),

    colorScheme: const ColorScheme.light(
      primary: AppColors.accentBlue,
    ),
  );
}
