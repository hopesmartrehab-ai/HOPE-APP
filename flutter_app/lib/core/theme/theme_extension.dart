import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tara_car/core/theme/logic/theme_cubit.dart';
import 'package:tara_car/core/theme/styles/app_colors.dart';

extension MultiThemeColors on BuildContext {
  // We read Cubit instead of Provider
  bool get isDarkMode => read<ThemeCubit>().isDarkMode;
  //Update all Getters to be based on the new isDark

  Color get lightPrimaryColor => isDarkMode
      ? const Color(0xffBB86FC).withValues(alpha: .05)
      : AppColors.primaryColor.withValues(alpha: .05);

  Color get secondaryColor =>
      isDarkMode ? const Color(0xff39601f) : AppColors.secondaryColor;

  Color get textBlack =>
      isDarkMode ? const Color(0xffEAEAEA) : AppColors.textBlack;

  Color get textHintBold =>
      isDarkMode ? const Color(0xffC1C1C1) : AppColors.textExtraStrongColor;

  Color get textHintLight =>
      isDarkMode ? const Color(0xffA0A0A0) : AppColors.textMutedColor;

  Color get lightGray =>
      isDarkMode ? const Color(0xffA0A0A0) : AppColors.borderAndDividerColor;

  Color get textHintMiddle =>
      isDarkMode ? const Color(0xff7A7A7A) : AppColors.textSecondaryColor;

  Color get textHintSimpleBold =>
      isDarkMode ? const Color(0xff9F9F9F) : AppColors.textExtraStrongColor;

  Color get redColor =>
      isDarkMode ? const Color(0xffCF2D2D) : AppColors.redColor;

  Color get white =>
      isDarkMode ? const Color(0xff1C1C1C) : AppColors.whiteColor;

  Color get disabledButtonColor =>
      isDarkMode ? const Color(0xff4B4B4B) : AppColors.disabledButtonColor;

  Color get bordersColor =>
      isDarkMode ? const Color(0xff333333) : AppColors.borderAndDividerColor;

  Color get darkPrimaryColor =>
      isDarkMode ? const Color(0xff03DAC5) : AppColors.secondaryColor;

  Color get buttomSheetTopColor =>
      isDarkMode ? const Color(0xff455A64) : AppColors.foregroundColor;

  Color get darkTextGray =>
      isDarkMode ? const Color(0xff757575) : AppColors.textSecondaryColor;

  Color get navBarBorderColor =>
      isDarkMode ? const Color(0xff333333) : AppColors.borderAndDividerColor;

  Color get searchContainerBorderColor =>
      isDarkMode ? const Color(0xff6082CF) : AppColors.statusTextColor;

  Color get boxOrderColor =>
      isDarkMode ? const Color(0xff1C1C1C) : AppColors.foregroundColor;

  Color get pendingColor =>
      isDarkMode ? const Color(0xffE5B000) : AppColors.mutedGoldColor;

  Color get completedColor =>
      isDarkMode ? const Color(0xff00C853) : AppColors.statusTextColor;

  Color get unselectedLanguageColor =>
      isDarkMode ? const Color(0xff455A64) : AppColors.secondaryColorMutedGold;

  Color get unselectedOrderStatusColor =>
      isDarkMode ? const Color(0xff455A64) : AppColors.secondaryColorMutedGold;

  Color get darkModeSwitchColor => isDarkMode
      ? const Color(0xff787880).withValues(alpha: .16)
      : const Color(0xff787880).withValues(alpha: .16);

  Color get dividerColor =>
      isDarkMode ? const Color(0xffE8E9F1) : AppColors.borderAndDividerColor;

  Color get blackColor =>
      isDarkMode ? const Color(0xff1C1C1C) : AppColors.blackColor;

  Color get successColor =>
      isDarkMode ? const Color(0xff3DC13C) : AppColors.statusTextColor;

  Color get unselectedCategoryColor =>
      isDarkMode ? const Color(0xff455A64) : AppColors.textSecondaryColor;

  Color get discountTagColor =>
      isDarkMode ? const Color(0xffFF0000) : AppColors.badgeColor;

  Color get exclusiveTagColor =>
      isDarkMode ? const Color(0xffffffff) : AppColors.mutedGoldColor;

  Color get newArrivalTagColor =>
      isDarkMode ? const Color(0xffffffff) : AppColors.primaryColor;

  Color get productOutOfStockColor => isDarkMode
      ? const Color(0xffFFEEEE)
      : AppColors.redColor.withValues(alpha: .08);

  Color get mutedGoldColor =>
      isDarkMode ? const Color(0xffBC9658) : AppColors.mutedGoldColor;

  Color get textMutedColor =>
      isDarkMode ? const Color(0xffBFBFBF) : AppColors.textMutedColor;

  Color get statusBackgroundColor =>
      isDarkMode ? const Color(0xffEDF4FE) : AppColors.statusBackgroundColor;

  Color get deductionColor =>
      isDarkMode ? const Color(0xffB02500) : const Color(0xffB02500);

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
  Color get lightDarkColor =>
      isDarkMode ? AppDarkColors.lightDark : AppColors.lightDark;
  Color get darkLightColor =>
      isDarkMode ? AppDarkColors.darkLight : AppColors.darkLight;
  Color get darkLightestColor =>
      isDarkMode ? AppDarkColors.darkLightest : AppColors.darkLightest;
  Color get lightMediumColor =>
      isDarkMode ? AppDarkColors.lightMedium : AppColors.lightMedium;
  Color get naturalLightLightColor => isDarkMode
      ? AppDarkColors.naturalLightLight
      : AppColors.naturalLightLight;
  Color get textWhite =>
      isDarkMode ? const Color(0xff1C1C1C) : AppColors.textWhite;
  Color get darkDarkestColor =>
      isDarkMode ? AppDarkColors.darkDarkest : AppColors.darkDarkest;
  Color get lightDarkestColor =>
      isDarkMode ? AppDarkColors.lightDarkest : AppColors.lightDarkest;
  Color get lightLightestColor =>
      isDarkMode ? AppDarkColors.lightLightest : AppColors.lightLightest;
  Color get premiumColor =>
      isDarkMode ? AppDarkColors.premiumColor : AppColors.premiumColor;
  Color get darkMediumColor =>
      isDarkMode ? AppDarkColors.darkMedium : AppColors.darkMedium;
  Color get errorDarkColor =>
      isDarkMode ? AppDarkColors.errorDark : AppColors.errorDark;
  Color get addCircleBackgroundColor => isDarkMode
      ? AppDarkColors.addCircleBackgroundColor
      : AppColors.addCircleBackgroundColor;
  Color get iconVerified =>
      isDarkMode ? AppDarkColors.iconVerified : AppColors.iconVerified;
  Color get containerDividerColor =>
      isDarkMode ? AppDarkColors.containerDivider : AppColors.containerDivider;
  Color get successLightColor =>
      isDarkMode ? AppDarkColors.successLight : AppColors.successLight;
  Color get warningLightColor =>
      isDarkMode ? AppDarkColors.warningLight : AppColors.warningLight;
  Color get warningDarkColor =>
      isDarkMode ? AppDarkColors.warningDark : AppColors.warningDark;
  Color get carGreenColor =>
      isDarkMode ? AppDarkColors.carGreen : AppColors.carGreen;
  Color get carRedColor => isDarkMode ? AppDarkColors.carRed : AppColors.carRed;
  Color get carBlueColor =>
      isDarkMode ? AppDarkColors.carBlue : AppColors.carBlue;
  Color get carGrayColor =>
      isDarkMode ? AppDarkColors.carGray : AppColors.carGray;
  Color get carBlackColor =>
      isDarkMode ? AppDarkColors.carBlack : AppColors.carBlack;
  Color get carYellowColor =>
      isDarkMode ? AppDarkColors.carYellow : AppColors.carYellow;
  Color get carPurpleColor =>
      isDarkMode ? AppDarkColors.carPurple : AppColors.carPurple;
  Color get carOrangeColor =>
      isDarkMode ? AppDarkColors.carOrange : AppColors.carOrange;
  Color get greenLightColor =>
      isDarkMode ? AppDarkColors.greenLight : AppColors.greenLight;
  Color get dottedColor =>
      isDarkMode ? AppDarkColors.dottedColor : AppColors.dottedColor;
  Color get dustyTeal =>
      isDarkMode ? AppDarkColors.dustyTeal : AppColors.dustyTeal;
  Color get oxfordBlue =>
      isDarkMode ? AppDarkColors.oxfordBlue : AppColors.oxfordBlue;
}
