import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromRGBO(16, 73, 138, 1);   // C:100 M:70 Y:0 K:20
  static const Color secondary = Color.fromRGBO(0, 108, 181, 1); // C:100 M:50 Y:0 K:0
  static const Color gray07 = Color.fromRGBO(137, 137, 137, 1);  // C:0 M:0 Y:0 K:60
  static const Color gray04 = Color(0xFFBDBDBD);
  static const Color surface = Colors.white;
  static const Color disabled = Color(0xFFEEEEEE);
  static const Color text = primary;
}

class AppTheme {
  static ThemeData bootcampTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surface,
    disabledColor: AppColors.disabled,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface, // reemplaza background
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.primary, // reemplaza onBackground
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: AppColors.text,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: AppColors.gray07,
      ),
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          } else if (states.contains(WidgetState.disabled)) {
            return AppColors.gray07;
          }
          return AppColors.gray04;
        },
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    ),
  );
}