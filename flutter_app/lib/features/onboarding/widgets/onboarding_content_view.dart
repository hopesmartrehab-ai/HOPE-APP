import 'package:flutter/material.dart';
import 'package:hope_app/features/onboarding/models/onboarding_item.dart';
import 'package:hope_app/features/onboarding/widgets/onboarding_bottom_section.dart';
import 'package:hope_app/features/onboarding/widgets/onboarding_top_section.dart';

class OnboardingContentView extends StatelessWidget {
  const OnboardingContentView({
    required this.controller,
    required this.onboardingItems,
    required this.currentPage,
    required this.onPageChanged,
    required this.onNext,
    required this.onSkip,
    super.key,
  });

  final PageController controller;
  final List<OnboardingItem> onboardingItems;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: OnboardingTopSection(
            controller: controller,
            onboardingItems: onboardingItems,
            onPageChanged: onPageChanged,
            onSkip: onSkip,
          ),
        ),
        OnboardingBottomSection(
          controller: controller,
          onboardingItems: onboardingItems,
          currentPage: currentPage,
          onNext: onNext,
        ),
      ],
    );
  }
}
