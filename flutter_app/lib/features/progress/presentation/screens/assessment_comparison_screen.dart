import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/features/progress/data/models/assessment_comparison_model.dart';
import 'package:hope_app/features/progress/presentation/widgets/comparison_score_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/overall_improvement_banner.dart';
import 'package:hope_app/features/progress/presentation/widgets/performance_area_comparison_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_encouragement_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_page_header.dart';

class AssessmentComparisonScreen extends StatelessWidget {
  const AssessmentComparisonScreen({
    required this.comparison,
    super.key,
  });

  final AssessmentComparisonModel comparison;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const ProgressPageHeader(
                title: LocaleKeys.progressAssessmentComparison,
                backLabel: LocaleKeys.back,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ComparisonScoreCard(
                      title: LocaleKeys.progressInitialAssessment,
                      date: 'Sept 1, 2026',
                      score: comparison.initialScore,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ComparisonScoreCard(
                      title: LocaleKeys.progressCurrentProgress,
                      date: 'Sept 2, 2026',
                      score: comparison.currentScore,
                      scoreColor: const Color(0xFF3DAA6B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OverallImprovementBanner(delta: comparison.overallDelta),
              const SizedBox(height: 16),
              PerformanceAreaComparisonCard(areas: comparison.areas),
              const SizedBox(height: 16),
              const ProgressEncouragementCard(),
            ],
          ),
        ),
      ),
    );
  }
}
