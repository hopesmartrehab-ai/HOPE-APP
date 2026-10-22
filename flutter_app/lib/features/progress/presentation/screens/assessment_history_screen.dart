import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/features/progress/data/models/assessment_comparison_model.dart';
import 'package:hope_app/features/progress/data/models/assessment_model.dart';
import 'package:hope_app/features/progress/data/models/performance_area_model.dart';
import 'package:hope_app/features/progress/presentation/screens/assessment_comparison_screen.dart';
import 'package:hope_app/features/progress/presentation/widgets/assessment_summary_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/next_assessment_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_action_tile.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_page_header.dart';

class AssessmentHistoryScreen extends StatelessWidget {
  const AssessmentHistoryScreen({super.key});

  static const _assessment = AssessmentModel(
    id: 'assessment-001',
    code: 'A1',
    title: LocaleKeys.progressAssessmentInitial,
    date: 'Sept 1, 2026',
    location: LocaleKeys.progressLocationHopePlanet,
    durationMinutes: 12,
    score: 0.63,
    potential: 0.78,
    path: LocaleKeys.progressPathOnline,
  );

  static const _comparison = AssessmentComparisonModel(
    initialScore: 0.63,
    currentScore: 0.76,
    overallDelta: 0.13,
    areas: [
      PerformanceAreaModel(
        name: LocaleKeys.progressAreaReachGrasp,
        initialScore: 0.72,
        currentScore: 0.85,
      ),
      PerformanceAreaModel(
        name: LocaleKeys.progressAreaGripStrength,
        initialScore: 0.58,
        currentScore: 0.71,
      ),
      PerformanceAreaModel(
        name: LocaleKeys.progressAreaCoordination,
        initialScore: 0.65,
        currentScore: 0.78,
      ),
      PerformanceAreaModel(
        name: LocaleKeys.progressAreaManipulation,
        initialScore: 0.48,
        currentScore: 0.63,
      ),
      PerformanceAreaModel(
        name: LocaleKeys.progressAreaReleaseControl,
        initialScore: 0.70,
        currentScore: 0.82,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const ProgressPageHeader(
                title: LocaleKeys.progressAssessmentHistory,
                subtitle: LocaleKeys.progressAllAssessmentsCompleted,
                backLabel: LocaleKeys.back,
              ),
              const SizedBox(height: 20),
              const AssessmentSummaryCard(
                assessment: _assessment,
                isLatest: true,
              ),
              const SizedBox(height: 14),
              ProgressActionTile(
                icon: Icons.assignment_outlined,
                title: LocaleKeys.progressViewFullReport.tr(),
                onTap: () {},
              ),
              const SizedBox(height: 14),
              ProgressActionTile(
                icon: Icons.bar_chart_rounded,
                title: LocaleKeys.progressCompareAssessments.tr(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AssessmentComparisonScreen(
                      comparison: _comparison,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              NextAssessmentCard(
                dateLabel:
                    '${LocaleKeys.progressAssessmentScheduledDate.tr()} · ${LocaleKeys.progressAssessmentFollowup.tr()}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
