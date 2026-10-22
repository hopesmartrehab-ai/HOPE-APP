import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class ConsistencyHeatmapCard extends StatelessWidget {
  const ConsistencyHeatmapCard({
    required this.matrix,
    required this.summary,
    super.key,
  });

  final List<List<int>> matrix;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.progressTrainingConsistency.tr(),
            style: Styles.s14(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: matrix.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: row.map((cell) {
                    return Expanded(
                      child: AspectRatio(
                        aspectRatio: 1.1,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: cell == 1
                                ? const Color(0xFF43A76C)
                                : const Color(0xFFE5ECEF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Text(
            summary.tr(),
            style: Styles.s12(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
