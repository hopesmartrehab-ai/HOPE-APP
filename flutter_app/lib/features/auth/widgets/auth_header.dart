import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/assets_constants.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/clicked_widget.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.onboardingBorder)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 24,
          top: 24,
          end: 24,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClickedWidget(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppColors.onboardingSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      LocaleKeys.back.tr(),
                      style: Styles.s14(context).copyWith(
                        color: AppColors.onboardingSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Image.asset(Assets.welcomeHopeLogo, width: 36, height: 36),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Styles.s22(context).copyWith(
                    color: AppColors.onboardingPrimary,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Styles.s14(
                context,
              ).copyWith(color: AppColors.onboardingSecondary, height: 1.43),
            ),
          ],
        ),
      ),
    );
  }
}
