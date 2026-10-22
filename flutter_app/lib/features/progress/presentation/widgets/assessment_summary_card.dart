import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/assessment_model.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class AssessmentSummaryCard extends StatelessWidget {
  const AssessmentSummaryCard({
    required this.assessment,
    this.isLatest = false,
    super.key,
  });

  final AssessmentModel assessment;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    return ProgressCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2A4A),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  assessment.code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          assessment.title.tr(),
                          style: Styles.s14(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (isLatest)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F6EC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              LocaleKeys.progressLatest.tr(),
                              style: Styles.s10(context).copyWith(
                                color: const Color(0xFF2E8555),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${assessment.date} · ${assessment.location.tr()} · ${assessment.durationMinutes} ${LocaleKeys.progressMinutes.tr()}',
                      style: Styles.s12(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _AssessmentStat(
                value: '${(assessment.score * 100).round()}%',
                label: LocaleKeys.progressScore.tr(),
              ),
              _AssessmentStat(
                value: '${(assessment.potential * 100).round()}%',
                label: LocaleKeys.progressPotential.tr(),
              ),
              _AssessmentStat(
                value: assessment.path.tr(),
                label: LocaleKeys.progressPath.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssessmentStat extends StatelessWidget {
  const _AssessmentStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Styles.s14(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.tr(),
            style: Styles.s10(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
