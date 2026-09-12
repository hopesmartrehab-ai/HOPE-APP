import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          title: LocaleKeys.welcomeCreateAccount.tr(),
          isLoading: false,
          backgroundColor: AppColors.onboardingStart,
          borderRadius: 16,
          height: 56,
          onPressed: () {},
          style: Styles.s16(context),
        ),
        const SizedBox(height: 12),
        CustomButton(
          title: LocaleKeys.welcomeSignIn.tr(),
          isLoading: false,
          isStroked: true,
          borderRadius: 16,
          height: 56,
          onPressed: () {},
          foregroundColor: AppColors.onboardingPrimary,
          style: Styles.s16(context),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            text: LocaleKeys.welcomeTermsPrefix.tr(),
            children: [
              TextSpan(
                text: LocaleKeys.welcomeTermsService.tr(),
                style: const TextStyle(
                  color: Color(0xFF347CB3),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(text: LocaleKeys.welcomeTermsMiddle.tr()),
              TextSpan(
                text: LocaleKeys.welcomePrivacyPolicy.tr(),
                style: const TextStyle(
                  color: Color(0xFF347CB3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: Styles.s12(
            context,
          ).copyWith(color: const Color(0xFF8AAEC4), height: 1.33),
        ),
      ],
    );
  }
}
