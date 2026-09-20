import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/home/presentation/model/home_models.dart';

class ThisWeekSection extends StatelessWidget {
  final WeeklyStatsModel statsData;

  const ThisWeekSection({required this.statsData, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.thisWeek.tr(),
              style: Styles.s18(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                LocaleKeys.viewAll.tr(),
                style: Styles.s14(context).copyWith(color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _WeekStatCard(
              icon: Icons.task_alt,
              value: '${statsData.sessionsDone}/${statsData.totalSessions}',
              label: LocaleKeys.sessionsDone.tr(),
            ),
            const SizedBox(width: 12),
            _WeekStatCard(
              icon: Icons.trending_up,
              value: '+${statsData.improvementPercentage}%',
              label: LocaleKeys.improvement.tr(),
            ),
            const SizedBox(width: 12),
            _WeekStatCard(
              icon: Icons.local_fire_department,
              value: statsData.dayStreak.toString(),
              label: LocaleKeys.dayStreak.tr(),
            ),
          ],
        ),
      ],
    );
  }
}

class _WeekStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _WeekStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 125),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 0.5,
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: icon == Icons.local_fire_department
                    ? Colors.orange
                    : icon == Icons.task_alt
                    ? Colors.green
                    : AppColors.primary,
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: Styles.s18(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Styles.s11(context).copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
