import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tara_car/core/theme/logic/theme_cubit.dart';
import 'package:tara_car/core/theme/styles/app_assets.dart';

extension MultiThemeAssets on BuildContext {
  bool get isDark => read<ThemeCubit>().isDarkMode;
  //----------------------------------------------------------------------------------
  //This dosent change with theme becuse it .png
  String get homeLogo => isDark ? AppDarkImages.homeLogo : AppImages.homeLogo;
  //This dosent change with theme becuse it has multi colors
  String get car => isDark ? AppDarkImages.car : AppImages.car;
  //This dosent change with theme becuse it has multi colors
  String get policeCar =>
      isDark ? AppDarkImages.policeCar : AppImages.policeCar;
  //This dosent change with theme becuse it has multi colors
  String get rocket => isDark ? AppDarkImages.rocket : AppImages.rocket;
  //This dosent change with theme becuse it has multi colors
  String get emptyNotification =>
      isDark ? AppDarkImages.emptyNotification : AppImages.emptyNotification;
  //----------------------------------------------------------------------------------

  // String get automaticIcon =>
  //     isDark ? AppDarkImages.automaticIcon : AppImages.automaticIcon;
  // String get manualIcon =>
  //     isDark ? AppDarkImages.manualIcon : AppImages.manualIcon;
  // String get locationIcon =>
  //     isDark ? AppDarkImages.locationIcon : AppImages.locationIcon;
  // String get calendarIcon =>
  //     isDark ? AppDarkImages.calendarIcon : AppImages.calendarIcon;
  // String get kmIcon => isDark ? AppDarkImages.kmIcon : AppImages.kmIcon;
  // String get searchSettingIcon =>
  //     isDark ? AppDarkImages.searchSettingIcon : AppImages.searchSettingIcon;
  //----------------------------------------------------------------------------------

  // String get closeIcon =>
  //     isDark ? AppDarkImages.closeIcon : AppImages.closeIcon;
  // String get backIcon => isDark ? AppDarkImages.backIcon : AppImages.backIcon;
  // String get clockIcon =>
  //     isDark ? AppDarkImages.clockIcon : AppImages.clockIcon;
  // String get carStockIcon =>
  //     isDark ? AppDarkImages.carStockIcon : AppImages.carStockIcon;
}
