import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class TrainingFormatHeader extends StatelessWidget {
  const TrainingFormatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.trainingFormat.tr(),
          style: Styles.s12(context).copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.chooseTrainingFormat.tr(),
          style: Styles.s26(
            context,
          ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.chooseTrainingFormatDesc.tr(),
          style: Styles.s14(
            context,
          ).copyWith(color: Colors.grey[600], height: 1.4),
        ),
      ],
    );
  }
}
