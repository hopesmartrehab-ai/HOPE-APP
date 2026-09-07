import 'package:flutter/material.dart';

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
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.30),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
