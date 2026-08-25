import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hope_app/core/theme/logic/theme_cubit.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';

extension MultiThemeColors on BuildContext {
  // We read Cubit instead of Provider
  bool get isDarkMode => read<ThemeCubit>().isDarkMode;
  //Update all Getters to be based on the new isDark

  Color get textBlack =>
      isDarkMode ? const Color(0xffEAEAEA) : AppColors.textBlack;

  Color get textHintBold =>
      isDarkMode ? const Color(0xffC1C1C1) : AppColors.textExtraStrongColor;

  Color get textHintLight =>
      isDarkMode ? const Color(0xffA0A0A0) : AppColors.textMutedColor;

  Color get lightGray =>
      isDarkMode ? const Color(0xffA0A0A0) : AppColors.borderAndDividerColor;

  Color get redColor =>
      isDarkMode ? const Color(0xffCF2D2D) : AppColors.redColor;

  Color get white =>
      isDarkMode ? const Color(0xff1C1C1C) : AppColors.whiteColor;

  Color get disabledButtonColor =>
      isDarkMode ? const Color(0xff4B4B4B) : AppColors.disabledButtonColor;

  Color get bordersColor =>
      isDarkMode ? const Color(0xff333333) : AppColors.borderAndDividerColor;

  Color get buttomSheetTopColor =>
      isDarkMode ? const Color(0xff455A64) : AppColors.foregroundColor;

  Color get pendingColor =>
      isDarkMode ? const Color(0xffE5B000) : AppColors.mutedGoldColor;

  Color get completedColor =>
      isDarkMode ? const Color(0xff00C853) : AppColors.statusTextColor;

  Color get dividerColor =>
      isDarkMode ? const Color(0xffE8E9F1) : AppColors.borderAndDividerColor;

  Color get blackColor =>
      isDarkMode ? const Color(0xff1C1C1C) : AppColors.blackColor;

  Color get successColor =>
      isDarkMode ? const Color(0xff3DC13C) : AppColors.statusTextColor;

  //new colors
  Color get scaffoldBackgroundColor => isDarkMode
      ? AppDarkColors.scaffoldBackgroundColor
      : AppColors.scaffoldBackgroundColor;
  Color get primaryColor =>
      isDarkMode ? AppDarkColors.primaryColor : AppColors.primaryColor;
  Color get lightLightnessColor => isDarkMode
      ? AppDarkColors.lightLightnessColor
      : AppColors.lightLightnessColor;
  Color get darkDarkColor =>
      isDarkMode ? AppDarkColors.darkDark : AppColors.darkDark;
  Color get darkLightColor =>
      isDarkMode ? AppDarkColors.darkLight : AppColors.darkLight;
  Color get darkLightestColor =>
      isDarkMode ? AppDarkColors.darkLightest : AppColors.darkLightest;
  Color get darkMediumColor =>
      isDarkMode ? AppDarkColors.darkMedium : AppColors.darkMedium;
  Color get errorDarkColor =>
      isDarkMode ? AppDarkColors.errorDark : AppColors.errorDark;
}