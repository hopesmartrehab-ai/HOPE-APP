import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class ProfileMetricItem {
  const ProfileMetricItem({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  final String value;
  final String label;
  final Color color;
  final IconData icon;
}

class ProfileMetricsRow extends StatelessWidget {
  const ProfileMetricsRow({required this.metrics, super.key});

  final List<ProfileMetricItem> metrics;

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

  final ProfileMetricItem metric;

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
