import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class RehabTipCard extends StatelessWidget {
  final String tipText;

  const RehabTipCard({required this.tipText, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '💡 ${LocaleKeys.tip.tr()}: ',
              style: Styles.s12(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: tipText,
              style: Styles.s12(
                context,
              ).copyWith(color: Colors.grey[700], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
