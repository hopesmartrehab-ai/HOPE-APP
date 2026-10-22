import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/functional_progress_model.dart';
import 'package:hope_app/features/progress/data/models/progress_overview_model.dart';
import 'package:hope_app/features/progress/data/models/weekly_activity_model.dart';
import 'package:hope_app/features/progress/detailed_progress_screen.dart';
import 'package:hope_app/features/progress/presentation/screens/assessment_history_screen.dart';
import 'package:hope_app/features/progress/presentation/screens/session_history_screen.dart';
import 'package:hope_app/features/progress/presentation/widgets/functional_progress_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_insight_tile.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_overview_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/weekly_activity_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const _overview = ProgressOverviewModel(
    overallScore: 0.63,
    streak: 5,
    completedSessionsCount: 28,
    improvementPercentage: 14,
  );

  static const _weeklyActivity = [
    WeeklyActivityModel(
      day: LocaleKeys.progressMonday,
      value: 0.45,
      isCurrentDay: false,
    ),
    WeeklyActivityModel(
      day: LocaleKeys.progressTuesday,
      value: 0.70,
      isCurrentDay: false,
    ),
    WeeklyActivityModel(
      day: LocaleKeys.progressWednesday,
      value: 0.30,
      isCurrentDay: false,
    ),
    WeeklyActivityModel(
      day: LocaleKeys.progressThursday,
      value: 0.85,
      isCurrentDay: false,
    ),
    WeeklyActivityModel(
      day: LocaleKeys.progressFriday,
      value: 0.60,
      isCurrentDay: false,
    ),
    WeeklyActivityModel(
      day: LocaleKeys.progressSaturday,
      value: 0.90,
      isCurrentDay: true,
    ),
    WeeklyActivityModel(
      day: LocaleKeys.progressSunday,
      value: 0.20,
      isCurrentDay: false,
    ),
  ];

  static const _functionalSkills = [
    FunctionalProgressModel(
      skillName: LocaleKeys.progressMobility,
      percentage: 0.78,
      scoreLabel: '78%',
    ),
    FunctionalProgressModel(
      skillName: LocaleKeys.progressStrength,
      percentage: 0.65,
      scoreLabel: '65%',
    ),
    FunctionalProgressModel(
      skillName: LocaleKeys.progressBalance,
      percentage: 0.52,
      scoreLabel: '52%',
    ),
    FunctionalProgressModel(
      skillName: LocaleKeys.progressPainReduction,
      percentage: 0.84,
      scoreLabel: '84%',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(
                LocaleKeys.progressYourProgress.tr(),
                style: Styles.s12(context).copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.tabProgress.tr(),
                style: Styles.s24(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const ProgressOverviewCard(overview: _overview),
              const SizedBox(height: 20),
              WeeklyActivityCard(
                activity: _weeklyActivity,
                totalHoursLabel: LocaleKeys.progressHoursTotal.tr(
                  args: ['4.2'],
                ),
              ),
              const SizedBox(height: 20),
              const FunctionalProgressCard(skills: _functionalSkills),
              const SizedBox(height: 24),
              Text(
                LocaleKeys.progressHistoryInsights.tr(),
                style: Styles.s18(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              ProgressInsightTile(
                icon: Icons.calendar_today_rounded,
                title: LocaleKeys.progressSessionHistory.tr(),
                subtitle: LocaleKeys.progressSessionsCompleted.tr(args: ['28']),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SessionHistoryScreen(),
                  ),
                ),
              ),
              ProgressInsightTile(
                icon: Icons.assignment_outlined,
                title: LocaleKeys.progressAssessmentHistory.tr(),
                subtitle: LocaleKeys.progressSessionsCompleted.tr(args: ['1']),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AssessmentHistoryScreen(),
                  ),
                ),
              ),
              ProgressInsightTile(
                icon: Icons.bar_chart_rounded,
                title: LocaleKeys.progressDetailedProgress.tr(),
                subtitle: LocaleKeys.progressTrendsAnalytics.tr(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const DetailedProgressScreen(),
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
