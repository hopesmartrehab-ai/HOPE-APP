import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HopeColors {
  HopeColors._();

  static const Color navy = Color(0xFF1A4663);
  static const Color teal = Color(0xFF357185);
  static const Color sage = Color(0xFF89B189);
  static const Color offWhite = Color(0xFFE9E8E6);
  static const Color ink = Color(0xFF1F2933);
  static const Color muted = Color(0xFF5C6B77);
}

ThemeData buildHopeTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: HopeColors.navy,
    primary: HopeColors.navy,
    secondary: HopeColors.teal,
    tertiary: HopeColors.sage,
    surface: HopeColors.offWhite,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: HopeColors.offWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: HopeColors.offWhite,
      foregroundColor: HopeColors.navy,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: HopeColors.navy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HopeColors.navy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: HopeColors.teal),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: HopeColors.teal,
    ),
  );
}
