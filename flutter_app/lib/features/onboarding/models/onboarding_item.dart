import 'package:flutter/material.dart';

class OnboardingItem {
  const OnboardingItem({
    required this.titleKey,
    required this.descriptionKey,
    required this.image,
    required this.topColor,
    required this.bottomColor,
    this.hasImageBackground = false,
  });

  final String titleKey;
  final String descriptionKey;
  final String image;
  final Color topColor;
  final Color bottomColor;
  final bool hasImageBackground;
}
