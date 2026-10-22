import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/metric_item_model.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class KeyMetricsCard extends StatelessWidget {
  const KeyMetricsCard({required this.metrics, super.key});

  final List<MetricItemModel> metrics;

  @override
  Widget build(BuildContext context) {
    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.progressKeyMetrics.tr(),
            style: Styles.s14(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          ...metrics.asMap().entries.map((entry) {
            final isLast = entry.key == metrics.length - 1;
            final metric = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metric.title.tr(),
                              style: Styles.s14(context).copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              metric.trend.tr(),
                              style: Styles.s12(context).copyWith(
                                color: const Color(0xFF3DAA6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        metric.value,
                        style: Styles.s16(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    color: Colors.black.withValues(alpha: 0.05),
                    height: 1,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
