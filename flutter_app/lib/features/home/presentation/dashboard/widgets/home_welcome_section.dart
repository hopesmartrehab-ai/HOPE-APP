import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class HomeWelcomeSection extends StatelessWidget {
  final String userName;

  const HomeWelcomeSection({required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.goodMorning.tr(),
          style: Styles.s16(context).copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: Styles.s26(
            context,
          ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.keepUpGreatWork.tr(),
          style: Styles.s14(context).copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
