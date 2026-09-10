import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/assets_constants.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/app_svg.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/onboarding/models/onboarding_item.dart';
import 'package:hope_app/features/onboarding/widgets/onboarding_dots.dart';

class OnboardingBottomSection extends StatelessWidget {
  const OnboardingBottomSection({
    required this.controller,
    required this.onboardingItems,
    required this.currentPage,
    required this.onNext,
    super.key,
  });

  final PageController controller;
  final List<OnboardingItem> onboardingItems;
  final int currentPage;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: onboardingItems[currentPage].bottomColor,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(32, 8, 32, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                onboardingItems[currentPage].title.tr(),
                style: Styles.s26(context).copyWith(
                  color: AppColors.onboardingPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                onboardingItems[currentPage].description.tr(),
                style: Styles.s14(context).copyWith(
                  color: AppColors.onboardingSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  OnboardingDots(controller: controller, count: 3),
                  const Spacer(),
                  currentPage == onboardingItems.length - 1
                      ? SizedBox(
                          width: 234,
                          child: CustomButton(
                            title: LocaleKeys.onboardingStart.tr(),
                            isLoading: false,
                            isBackgroundPrimary: true,
                            backgroundColor: AppColors.onboardingStart,
                            borderRadius: 16,
                            height: 52,
                            onPressed: onNext,
                          ),
                        )
                      : CustomButton(
                          title: LocaleKeys.onboardingNext.tr(),
                          isLoading: false,
                          isBackgroundPrimary: true,
                          backgroundColor: AppColors.onboardingPrimary,
                          width: 56,
                          height: 52,
                          borderRadius: 16,
                          padding: EdgeInsets.zero,
                          onPressed: onNext,
                          child: Transform.flip(
                            flipX: context.locale.languageCode == 'ar',
                            child: const AppSvg(
                              assetName: Assets.onboardingNext,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
