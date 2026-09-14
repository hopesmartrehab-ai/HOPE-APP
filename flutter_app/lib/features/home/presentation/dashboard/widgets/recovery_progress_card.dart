import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/home/presentation/model/home_models.dart';

class RecoveryProgressCard extends StatelessWidget {
  final RecoveryProgressModel progressData;

  const RecoveryProgressCard({required this.progressData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 0.1, color: Colors.grey),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.recoveryProgress.tr(),
                style: Styles.s16(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  LocaleKeys.details.tr(),
                  style: Styles.s12(context).copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ProgressBarRow(
            label: LocaleKeys.overallProgress.tr(),
            percentage: progressData.overallProgress,
            color: const Color(0xFF4ADE80),
          ),
          const SizedBox(height: 16),
          _ProgressBarRow(
            label: LocaleKeys.gripStrength.tr(),
            percentage: progressData.gripStrength,
            color: const Color(0xFF4ADE80),
          ),
          const SizedBox(height: 16),
          _ProgressBarRow(
            label: LocaleKeys.coordination.tr(),
            percentage: progressData.coordination,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class _ProgressBarRow extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;

  const _ProgressBarRow({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Styles.s12(
                context,
              ).copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
            Text(
              '$percentage%',
              style: Styles.s12(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: const Color(0xFFE0E0E0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
