import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/performance_area_model.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class PerformanceAreaComparisonCard extends StatelessWidget {
  const PerformanceAreaComparisonCard({required this.areas, super.key});

  final List<PerformanceAreaModel> areas;

  @override
  Widget build(BuildContext context) {
    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            children: [
              Text(
                LocaleKeys.progressPerformanceArea.tr(),
                style: Styles.s12(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  _LegendDot(
                    color: const Color(0xFF2F6FB0),
                    text: LocaleKeys.progressBefore.tr(),
                  ),
                  const SizedBox(width: 12),
                  _LegendDot(
                    color: const Color(0xFF3DAA6B),
                    text: LocaleKeys.progressAfter.tr(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...areas.map((area) => _AreaRow(area: area)),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text.tr(),
          style: Styles.s10(context).copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AreaRow extends StatelessWidget {
  const _AreaRow({required this.area});

  final PerformanceAreaModel area;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                area.name.tr(),
                style: Styles.s12(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${area.delta >= 0 ? '+' : ''}${(area.delta * 100).round()}%',
                style: Styles.s12(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3DAA6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _ScoreBar(
            score: area.initialScore,
            color: const Color(0xFF2F6FB0),
          ),
          const SizedBox(height: 4),
          _ScoreBar(
            score: area.currentScore,
            color: const Color(0xFF3DAA6B),
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.score, required this.color});

  final double score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            '${(score * 100).round()}%',
            style: Styles.s10(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score.clamp(0, 1),
              minHeight: 6,
              color: color,
              backgroundColor: const Color(0xFFE9F0F5),
            ),
          ),
        ),
      ],
    );
  }
}
