import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hope_app/core/theme/logic/theme_cubit.dart';
import 'package:hope_app/core/theme/styles/app_assets.dart';

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
}
