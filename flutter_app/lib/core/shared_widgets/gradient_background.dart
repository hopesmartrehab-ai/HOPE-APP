import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEEF3F8), AppColors.scaffoldBg],
          stops: [0, 0.6],
        ),
      ),
      child: child,
    );
  }
}
