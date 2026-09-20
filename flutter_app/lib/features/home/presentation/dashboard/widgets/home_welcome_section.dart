import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class HomeWelcomeSection extends StatelessWidget {
  final String userName;

  const HomeWelcomeSection({required this.userName, super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return LocaleKeys.goodMorning.tr();
    } else if (hour < 18) {
      return LocaleKeys.goodAfternoon.tr();
    }

    return LocaleKeys.goodEvening.tr();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: Styles.s16(context).copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              userName,
              style: Styles.s26(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.waving_hand, color: AppColors.primary, size: 24),
          ],
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
