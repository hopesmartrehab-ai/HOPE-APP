import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/exercise_item_model.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_card.dart';

class ExerciseDetailsCard extends StatelessWidget {
  const ExerciseDetailsCard({required this.exercises, super.key});

  final List<ExerciseItemModel> exercises;

  @override
  Widget build(BuildContext context) {
    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.progressExerciseDetails.tr(),
            style: Styles.s16(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...exercises.asMap().entries.map((entry) {
            final isLast = entry.key == exercises.length - 1;
            final exercise = entry.value;
            final excellent = exercise.rating == ExerciseRating.excellent;
            final bg = excellent
                ? const Color(0xFFE4F7EC)
                : const Color(0xFFE8F1FA);
            final fg = excellent
                ? const Color(0xFF2E8555)
                : const Color(0xFF357ABD);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name.tr(),
                              style: Styles.s14(context).copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${exercise.device.tr()} · ${exercise.duration}',
                              style: Styles.s12(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          (excellent
                                  ? LocaleKeys.progressExcellent
                                  : LocaleKeys.progressGood)
                              .tr(),
                          style: Styles.s10(context).copyWith(
                            color: fg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    color: Colors.black.withValues(alpha: 0.06),
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
