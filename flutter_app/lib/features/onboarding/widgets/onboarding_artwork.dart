import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/onboarding/models/onboarding_item.dart';

class OnboardingArtwork extends StatelessWidget {
  const OnboardingArtwork({required this.item, super.key});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.onboardingShadow,
            offset: Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
          BoxShadow(
            color: AppColors.onboardingShadow,
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: item.hasImageBackground
            ? DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.onboardingGloveBottom,
                      AppColors.onboardingGloveCardEnd,
                    ],
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    item.image,
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
              )
            : Image.asset(
                item.image,
                width: 280,
                height: 260,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
      ),
    );
  }
}
