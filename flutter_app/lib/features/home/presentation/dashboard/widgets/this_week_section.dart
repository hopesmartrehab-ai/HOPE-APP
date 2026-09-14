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
        Row(
          children: [
            _WeekStatCard(
              icon: '✅',
              value: '${statsData.sessionsDone}/${statsData.totalSessions}',
              label: LocaleKeys.sessionsDone.tr(),
            ),
            const SizedBox(width: 12),
            _WeekStatCard(
              icon: '📈',
              value: '+${statsData.improvementPercentage}%',
              label: LocaleKeys.improvement.tr(),
            ),
            const SizedBox(width: 12),
            _WeekStatCard(
              icon: '🔥',
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
  final String icon;
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
            border: Border.all(width: 0.1, color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              Text(
                value,
                style: Styles.s18(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Styles.s11(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
