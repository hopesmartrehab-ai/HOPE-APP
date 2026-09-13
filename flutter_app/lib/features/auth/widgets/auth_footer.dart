import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/clicked_widget.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({
    required this.text,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  final String text;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Styles.s14(
              context,
            ).copyWith(color: AppColors.onboardingSecondary, height: 1.43),
          ),
        ),
        ClickedWidget(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              actionText,
              style: Styles.s14(context).copyWith(
                color: AppColors.onboardingLink,
                fontWeight: FontWeight.w600,
                height: 1.43,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
