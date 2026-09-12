import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hope_app/core/constants/assets_constants.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class SplashMark extends StatelessWidget {
  const SplashMark({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.splashOuterCircleBorder,
                width: 1.55,
              ),
            ),
          ),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.splashInnerCircleBorder,
                width: 1.15,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.assetsImagesHopeSplashLogo,
                width: 128,
                height: 128,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 26),
              Text(
                LocaleKeys.splashTitle.tr(),
                style: GoogleFonts.manrope(
                  textStyle: Styles.s28(context).copyWith(
                    color: AppColors.splashTitle,
                    fontSize: 36,
                    height: 1.11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.splashSubtitle.tr(),
                style: GoogleFonts.inter(
                  textStyle: Styles.s14(context).copyWith(
                    color: AppColors.splashSubtitle,
                    height: 1.43,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
