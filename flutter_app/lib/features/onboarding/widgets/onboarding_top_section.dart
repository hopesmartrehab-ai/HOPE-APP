import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/onboarding/models/onboarding_item.dart';
import 'package:hope_app/features/onboarding/widgets/onboarding_artwork.dart';

class OnboardingTopSection extends StatelessWidget {
  const OnboardingTopSection({
    required this.controller,
    required this.onboardingItems,
    required this.onPageChanged,
    required this.onSkip,
    super.key,
  });

  final PageController controller;
  final List<OnboardingItem> onboardingItems;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: onboardingItems.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final item = onboardingItems[index];

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [item.topColor, item.bottomColor],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 32,
                top: 16,
                end: 24,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: index == 2
                        ? const SizedBox(height: 32)
                        : TextButton(
                            onPressed: onSkip,
                            child: Text(
                              LocaleKeys.onboardingSkip.tr(),
                              style: Styles.s14(context).copyWith(
                                color: AppColors.onboardingSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                  ),
                  const Spacer(),
                  OnboardingArtwork(item: item),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
