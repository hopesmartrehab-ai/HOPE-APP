import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/clicked_widget.dart';
import 'package:hope_app/core/shared_widgets/custom_text_form_field.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.label,
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.trailingLabel,
    this.onTrailingTap,
    this.helperText,
  });

  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Styles.s14(context).copyWith(
                color: AppColors.onboardingPrimary,
                fontWeight: FontWeight.w600,
                height: 1.43,
              ),
            ),
            if (trailingLabel != null)
              ClickedWidget(
                onTap: onTrailingTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    trailingLabel!,
                    style: Styles.s14(context).copyWith(
                      color: AppColors.onboardingLink,
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: CustomTextFormField(
            controller: controller,
            hintText: hintText,
            keyboardType: keyboardType,
            isPassword: obscureText,
            borderColor: AppColors.onboardingBorder,
            borderRadius: 12,
            fillColor: AppColors.scaffoldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            style: Styles.s14(context).copyWith(
              color: AppColors.onboardingPrimary,
              fontSize: 15,
              height: 1.5,
            ),
            hintStyle: Styles.s14(context).copyWith(
              color: AppColors.onboardingHint,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText!,
            style: Styles.s12(
              context,
            ).copyWith(color: AppColors.onboardingSecondary, height: 1.33),
          ),
        ],
      ],
    );
  }
}
