import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

import '../../../../../core/constants/locale_keys.dart';

class WelcomeTexts extends StatelessWidget {
  const WelcomeTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.greatJobCompleting.tr(),
          style: Styles.s14(
            context,
          ).copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.welcomeToRehabJourney.tr(),
          style: Styles.s26(context).copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
