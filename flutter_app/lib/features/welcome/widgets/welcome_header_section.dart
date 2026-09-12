import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/assets_constants.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/welcome/widgets/welcome_feature_row.dart';

class WelcomeHeaderSection extends StatelessWidget {
  const WelcomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          Assets.welcomeHopeLogo,
          width: 96,
          height: 96,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
        Text(
          LocaleKeys.welcomeTitle.tr(),
          textAlign: TextAlign.center,
          style: Styles.s28(context).copyWith(
            color: AppColors.onboardingPrimary,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          LocaleKeys.welcomeDescription.tr(),
          textAlign: TextAlign.center,
          style: Styles.s14(
            context,
          ).copyWith(color: AppColors.onboardingSecondary, fontSize: 15),
        ),
        const SizedBox(height: 40),
        const WelcomeFeatureRow(),
      ],
    );
  }
}
