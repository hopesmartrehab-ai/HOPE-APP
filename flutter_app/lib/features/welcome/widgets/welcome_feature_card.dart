import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class WelcomeFeatureCard extends StatelessWidget {
  const WelcomeFeatureCard({
    required this.icon,
    required this.title,
    required this.backgroundColor,
    super.key,
  });

  final String icon;
  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: const Color(0xFFD4E2EF)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 1),
            blurRadius: 1.5,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: Styles.s24(context)),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.s12(context).copyWith(
              color: AppColors.onboardingPrimary,
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}
