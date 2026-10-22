import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/session_details_model.dart';

class SessionDetailsMetrics extends StatelessWidget {
  const SessionDetailsMetrics({required this.details, super.key});

  final SessionDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Metric(
            icon: const Icon(Icons.check_circle, color: Color(0xFF3DAA6B)),
            value: '${details.completedExercises}/${details.totalExercises}',
            label: LocaleKeys.progressCompleted.tr(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Metric(
            icon: const Icon(
              Icons.timer_outlined,
              color: Color(0xFF6B7A90),
            ),
            value: '${details.durationMinutes} min',
            label: LocaleKeys.progressDuration.tr(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Metric(
            icon: const Icon(
              Icons.bar_chart_rounded,
              color: Color(0xFF2F6FB0),
            ),
            value: '${(details.performanceScore * 100).round()}%',
            label: LocaleKeys.progressPerformance.tr(),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final Widget icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 26, child: Center(child: icon)),
          const SizedBox(height: 8),
          Text(
            value,
            style: Styles.s14(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Styles.s10(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
