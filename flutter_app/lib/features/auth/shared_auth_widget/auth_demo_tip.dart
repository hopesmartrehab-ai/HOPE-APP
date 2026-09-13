import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class AuthDemoTip extends StatelessWidget {
  const AuthDemoTip({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.onboardingGloveTop,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.onboardingBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text.rich(
          TextSpan(
            text: title,
            style: const TextStyle(
              color: AppColors.onboardingPrimary,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: description,
                style: const TextStyle(
                  color: AppColors.onboardingSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          style: Styles.s12(context).copyWith(height: 1.63),
        ),
      ),
    );
  }
}
