import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/weekly_activity_model.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class WeeklyActivityCard extends StatelessWidget {
  const WeeklyActivityCard({
    required this.activity,
    required this.totalHoursLabel,
    super.key,
  });

  final List<WeeklyActivityModel> activity;
  final String totalHoursLabel;

  @override
  Widget build(BuildContext context) {
    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.progressWeeklyActivity.tr(),
                style: Styles.s16(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                totalHoursLabel,
                style: Styles.s12(context).copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: activity.map((item) {
                final height = 80.0 * item.value.clamp(0.0, 1.0);
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 24,
                        height: height,
                        decoration: BoxDecoration(
                          color: item.isCurrentDay
                              ? AppColors.secondary
                              : AppColors.secondary.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.day.tr(),
                        style: Styles.s12(context).copyWith(
                          fontWeight: item.isCurrentDay
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: item.isCurrentDay
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
