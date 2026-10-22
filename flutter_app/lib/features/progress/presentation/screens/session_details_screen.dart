import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/session_details_model.dart';
import 'package:hope_app/features/progress/data/models/session_model.dart';
import 'package:hope_app/features/progress/presentation/widgets/exercise_details_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/session_details_metrics.dart';
import 'package:hope_app/features/progress/presentation/widgets/therapist_note_card.dart';

class SessionDetailsScreen extends StatelessWidget {
  const SessionDetailsScreen({
    required this.session,
    required this.details,
    super.key,
  });

  final SessionModel session;
  final SessionDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    LocaleKeys.progressBackToHistory.tr(),
                    style: Styles.s14(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${session.dateLabel == LocaleKeys.progressToday ? LocaleKeys.progressToday.tr() : session.dateLabel} · ${session.dateLabel == LocaleKeys.progressToday ? 'Sept 2, 2026' : session.dateLabel}',
                style: Styles.s12(context).copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                session.title.tr(),
                style: Styles.s24(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              SessionDetailsMetrics(details: details),
              const SizedBox(height: 20),
              ExerciseDetailsCard(exercises: details.exercises),
              const SizedBox(height: 20),
              TherapistNoteCard(note: details.therapistNote),
            ],
          ),
        ),
      ),
    );
  }
}
