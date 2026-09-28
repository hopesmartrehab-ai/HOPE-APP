import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.dart';
import '../logic/level_metric.dart';

/// The measured numbers behind one level's score.
class InsightsCardWidget extends StatelessWidget {
  const InsightsCardWidget({
    required this.metrics,
    required this.color,
    super.key,
  });

  final List<LevelMetric> metrics;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.performanceInsights.tr(),
            style: const TextStyle(
              color: Color(0xFF15314B),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(metrics.length, (i) {
            final metric = metrics[i];
            final isLast = i == metrics.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      metric.label,
                      style: const TextStyle(
                        color: Color(0xFF6B8296),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    metric.value,
                    style: const TextStyle(
                      color: Color(0xFF15314B),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
