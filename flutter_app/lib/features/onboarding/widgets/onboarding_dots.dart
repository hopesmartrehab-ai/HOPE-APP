import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDots extends StatelessWidget {
  const OnboardingDots({
    required this.controller,
    required this.count,
    super.key,
  });

  final PageController controller;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: ExpandingDotsEffect(
        activeDotColor: AppColors.onboardingPrimary,
        dotColor: AppColors.onboardingPrimary.withValues(alpha: 0.25),
        dotHeight: 10,
        dotWidth: 10,
        spacing: 8,
        expansionFactor: 2.4,
      ),
    );
  }
}
