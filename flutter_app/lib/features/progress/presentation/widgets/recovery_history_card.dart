import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/recovery_score_step.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class RecoveryHistoryCard extends StatelessWidget {
  const RecoveryHistoryCard({required this.steps, super.key});

  final List<RecoveryScoreStep> steps;

  @override
  Widget build(BuildContext context) {
    final maxScore = steps.fold<double>(
      0,
      (maximum, step) => step.score > maximum ? step.score : maximum,
    );
    final scale = maxScore > 0 ? maxScore : 1;

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.progressRecoveryScore.tr(),
            style: Styles.s14(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: steps.map((step) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 70 * (step.score / scale),
                          decoration: BoxDecoration(
                            color: step.isCurrent
                                ? const Color(0xFF2E8555)
                                : const Color(0xFF90CCA6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(step.score * 100).round()}%',
                          style: Styles.s10(context).copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.progressStart.tr(),
                style: Styles.s10(context).copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                LocaleKeys.progressNow.tr(),
                style: Styles.s10(context).copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
