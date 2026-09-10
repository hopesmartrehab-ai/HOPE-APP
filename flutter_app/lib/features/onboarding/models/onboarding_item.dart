import 'package:flutter/material.dart';

class OnboardingItem {
  const OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.topColor,
    required this.bottomColor,
    this.hasImageBackground = false,
  });

  final String title;
  final String description;
  final String image;
  final Color topColor;
  final Color bottomColor;
  final bool hasImageBackground;
}
