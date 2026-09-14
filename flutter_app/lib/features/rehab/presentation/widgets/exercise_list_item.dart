import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/rehab/data/models/rehab_models.dart';

class ExerciseListItem extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseListItem({required this.exercise, super.key});

  @override
  Widget build(BuildContext context) {
    Color tagBgColor;
    Color tagTextColor;
    String tagText;

    switch (exercise.difficulty) {
      case ExerciseDifficulty.easy:
        tagBgColor = const Color(0xFFE6F4EA);
        tagTextColor = Colors.green;
        tagText = LocaleKeys.easy.tr();
        break;
      case ExerciseDifficulty.medium:
        tagBgColor = const Color(0xFFE3F2FD);
        tagTextColor = Colors.blue;
        tagText = LocaleKeys.medium.tr();
        break;
      case ExerciseDifficulty.hard:
        tagBgColor = const Color(0xFFFFEBEE);
        tagTextColor = Colors.red;
        tagText = LocaleKeys.hard.tr();
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 0.1, color: Colors.grey),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Text(
              exercise.id,
              style: Styles.s16(
                context,
              ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Text(exercise.iconEmoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.title,
                  style: Styles.s16(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${exercise.durationMin} min',
                  style: Styles.s12(context).copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tagBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tagText,
              style: Styles.s12(
                context,
              ).copyWith(color: tagTextColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
