import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppThemes {
  // ─── Light Theme ────────────────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.sage,
      surface: AppColors.surface,
      error: AppColors.statusError,
      brightness: Brightness.light,
    ),

    // Scaffold & general backgrounds
    scaffoldBackgroundColor: AppColors.scaffoldBg,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarBg,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    // Typography
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      displayLarge: GoogleFonts.roboto(color: AppColors.textPrimary),
      headlineLarge: GoogleFonts.roboto(color: AppColors.textPrimary),
      titleLarge: GoogleFonts.roboto(color: AppColors.textPrimary),
      bodyLarge: GoogleFonts.roboto(color: AppColors.textPrimary),
      bodyMedium: GoogleFonts.roboto(color: AppColors.textSecondary),
      bodySmall: GoogleFonts.roboto(color: AppColors.textMuted),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.containerBg,
      hintStyle: const TextStyle(color: AppColors.textHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.statusError),
      ),
    ),

    // Buttons
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.buttonDisabledBg,
        disabledForegroundColor: AppColors.buttonDisabledFg,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.buttonDisabledBg,
        disabledForegroundColor: AppColors.buttonDisabledFg,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.secondary,
        side: const BorderSide(color: AppColors.secondary, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
    ),

    // Bottom Navigation
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.navBarBg,
      indicatorColor: AppColors.navIndicator,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),

    // Progress indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.secondary,
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.containerBg,
      labelStyle: const TextStyle(color: AppColors.textPrimary),
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // ─── Dark Theme ─────────────────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppDarkColors.primary,
      primary: AppDarkColors.primary,
      secondary: AppDarkColors.secondary,
      tertiary: AppDarkColors.sage,
      surface: AppDarkColors.surface,
      error: AppDarkColors.statusError,
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: AppDarkColors.scaffoldBg,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppDarkColors.appBarBg,
      foregroundColor: AppDarkColors.textOnPrimary,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.roboto(color: AppDarkColors.textPrimary),
      headlineLarge: GoogleFonts.roboto(color: AppDarkColors.textPrimary),
      titleLarge: GoogleFonts.roboto(color: AppDarkColors.textPrimary),
      bodyLarge: GoogleFonts.roboto(color: AppDarkColors.textPrimary),
      bodyMedium: GoogleFonts.roboto(color: AppDarkColors.textSecondary),
      bodySmall: GoogleFonts.roboto(color: AppDarkColors.textMuted),
    ),

    cardTheme: CardThemeData(
      color: AppDarkColors.surface,
      elevation: 2,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppDarkColors.border),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppDarkColors.containerBg,
      hintStyle: const TextStyle(color: AppDarkColors.textHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppDarkColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppDarkColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppDarkColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppDarkColors.statusError),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppDarkColors.primary,
        foregroundColor: AppDarkColors.textOnPrimary,
        disabledBackgroundColor: AppDarkColors.buttonDisabledBg,
        disabledForegroundColor: AppDarkColors.buttonDisabledFg,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppDarkColors.primary,
        foregroundColor: AppDarkColors.textOnPrimary,
        disabledBackgroundColor: AppDarkColors.buttonDisabledBg,
        disabledForegroundColor: AppDarkColors.buttonDisabledFg,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppDarkColors.secondary,
        side: const BorderSide(color: AppDarkColors.secondary, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppDarkColors.secondary),
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppDarkColors.navBarBg,
      indicatorColor: AppDarkColors.navIndicator,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

    dividerTheme: const DividerThemeData(
      color: AppDarkColors.border,
      thickness: 1,
      space: 1,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppDarkColors.secondary,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppDarkColors.containerBg,
      labelStyle: const TextStyle(color: AppDarkColors.textPrimary),
      side: const BorderSide(color: AppDarkColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
