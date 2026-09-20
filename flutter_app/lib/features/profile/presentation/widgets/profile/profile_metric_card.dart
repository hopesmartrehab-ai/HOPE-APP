import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/profile/models/profile_models.dart';

class ProfileMetricsRow extends StatelessWidget {
  const ProfileMetricsRow({required this.metrics, super.key});

  final List<ProfileMetricModel> metrics;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: metrics
          .map(
            (metric) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ProfileMetricCard(metric: metric),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ProfileMetricCard extends StatelessWidget {
  const ProfileMetricCard({required this.metric, super.key});

  final ProfileMetricModel metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAEF)),
      ),
      child: Column(
        children: [
          Icon(metric.icon, color: metric.color, size: 22),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: Styles.s20(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            metric.label,
            textAlign: TextAlign.center,
            style: Styles.s12(context).copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
