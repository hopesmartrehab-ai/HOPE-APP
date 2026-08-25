import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.textBlack,
    ),
    textTheme: GoogleFonts.robotoTextTheme(),
    colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppDarkColors.primaryColor,
    scaffoldBackgroundColor: const Color(0xff121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppDarkColors.primaryColor,
      foregroundColor: AppColors.textWhite,
    ),
    textTheme: GoogleFonts.robotoTextTheme(),
    colorScheme: const ColorScheme.dark(primary: AppDarkColors.primaryColor),
  );
}
