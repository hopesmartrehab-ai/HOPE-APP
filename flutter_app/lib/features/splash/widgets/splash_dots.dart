import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';

class SplashDots extends StatelessWidget {
  const SplashDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: AppColors.splashDot,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
