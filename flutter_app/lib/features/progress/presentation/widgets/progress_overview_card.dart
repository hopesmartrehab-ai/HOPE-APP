import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/progress_overview_model.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class ProgressOverviewCard extends StatelessWidget {
  const ProgressOverviewCard({required this.overview, super.key});

  final ProgressOverviewModel overview;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ProgressCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: overview.overallScore.clamp(0, 1),
                            strokeWidth: 8,
                            color: AppColors.secondary,
                            backgroundColor:
                                AppColors.secondary.withValues(alpha: 0.15),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(overview.overallScore * 100).round()}%',
                              style: Styles.s18(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              LocaleKeys.progressOverall.tr(),
                              style: Styles.s10(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    LocaleKeys.progressProgress.tr(),
                    style: Styles.s12(context).copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: _ProgressMiniMetric(
                    icon: Icons.local_fire_department_rounded,
                    value: '${overview.streak}',
                    label: LocaleKeys.progressDayStreak.tr(),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _ProgressMiniMetric(
                    icon: Icons.check_circle_rounded,
                    value: '${overview.completedSessionsCount}',
                    label: LocaleKeys.progressSessions.tr(),
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _ProgressMiniMetric(
                    icon: Icons.trending_up_rounded,
                    value: '+${overview.improvementPercentage.round()}%',
                    label: LocaleKeys.progressImprovement.tr(),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressMiniMetric extends StatelessWidget {
  const _ProgressMiniMetric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: Styles.s14(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.s10(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
