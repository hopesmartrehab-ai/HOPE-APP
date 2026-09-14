import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/rehab/data/models/rehab_models.dart';
import 'package:hope_app/features/rehab/presentation/widgets/exercise_list_item.dart';
import 'package:hope_app/features/rehab/presentation/widgets/rehab_overview_card.dart';
import 'package:hope_app/features/rehab/presentation/widgets/rehab_tip_card.dart';

class RehabScreen extends StatelessWidget {
  const RehabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockSession = RehabSessionModel(
      title: 'Grip & Coordination',
      exercisesCount: 3,
      estDurationMin: 20,
      focusArea: 'Grip & Coord',
      tipText: LocaleKeys.rehabTipDescription.tr(),
      exercises: const [
        ExerciseModel(
          id: '1',
          title: 'Wrist Rotation Warm-Up',
          durationMin: 3,
          difficulty: ExerciseDifficulty.easy,
          iconEmoji: '🔄',
        ),
        ExerciseModel(
          id: '2',
          title: 'Power Grip Hold',
          durationMin: 5,
          difficulty: ExerciseDifficulty.medium,
          iconEmoji: '✊',
        ),
        ExerciseModel(
          id: '3',
          title: 'Pinch & Release Seq...',
          durationMin: 5,
          difficulty: ExerciseDifficulty.medium,
          iconEmoji: '🤏',
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.todaysSessionUpper.tr(),
                      style: Styles.s12(context).copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mockSession.title,
                      style: Styles.s26(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    RehabOverviewCard(session: mockSession),
                    const SizedBox(height: 24),
                    Text(
                      LocaleKeys.sessionExercises.tr(),
                      style: Styles.s18(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...mockSession.exercises.map(
                      (exercise) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ExerciseListItem(exercise: exercise),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RehabTipCard(tipText: mockSession.tipText),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),

                  child: CustomButton(
                    title: LocaleKeys.startSession.tr(),
                    isLoading: false,
                    backgroundColor: const Color(0xFF4ADE80),
                    foregroundColor: Colors.white,
                    borderRadius: 16.0,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
