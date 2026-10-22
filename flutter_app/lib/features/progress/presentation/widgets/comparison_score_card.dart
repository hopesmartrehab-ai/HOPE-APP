import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class ComparisonScoreCard extends StatelessWidget {
  const ComparisonScoreCard({
    required this.title,
    required this.date,
    required this.score,
    this.scoreColor,
    super.key,
  });

  final String title;
  final String date;
  final double score;
  final Color? scoreColor;

  @override
  Widget build(BuildContext context) {
    return ProgressCard(
      child: Column(
        children: [
          Text(
            title.tr(),
            textAlign: TextAlign.center,
            style: Styles.s12(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: Styles.s10(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${(score * 100).round()}%',
            style: Styles.s24(context).copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: scoreColor ?? const Color(0xFF2F6FB0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.progressOverallScore.tr(),
            style: Styles.s10(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
