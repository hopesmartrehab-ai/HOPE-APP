import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/locale_keys.dart';
import '../../../core/utils/app_route.dart';
import '../domain/entities/assessment_result.dart';
import '../domain/entities/level_outcome.dart';
import 'logic/level_metric.dart';
import 'logic/score_palette.dart';
import 'widgets/insights_card_widget.dart';
import 'widgets/level_score_card_widget.dart';
import 'widgets/opportunity_card_widget.dart';

/// Placeholder for a metric the backend sent no value for.
const String _noValue = '—';

class DetailedPerformancePage extends StatefulWidget {
  const DetailedPerformancePage({required this.result, super.key});

  final AssessmentResult result;

  @override
  State<DetailedPerformancePage> createState() =>
      _DetailedPerformancePageState();
}

class _DetailedPerformancePageState extends State<DetailedPerformancePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final levels = widget.result.outcomes;

    if (levels.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF2F6F9),
        appBar: _buildAppBar(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              LocaleKeys.assessmentResultsError.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6B8296),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    final index = _selectedIndex < levels.length
        ? _selectedIndex
        : levels.length - 1;
    final outcome = levels[index];
    final color = scoreAccentColor(outcome.scorePercent);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                LocaleKeys.detailedPerformance.tr(),
                style: const TextStyle(
                  color: Color(0xFF15314B),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: levels.length,
                itemBuilder: (context, i) {
                  final level = levels[i];
                  final isSelected = index == i;
                  final levelName = (level.titleKey ?? level.levelKey).tr();

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF15314B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF15314B)
                              : const Color(0xFFE8EFF3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'L${_displayNumber(level, i)}: $levelName',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6B8296),
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    LevelScoreCardWidget(
                      levelNumber: _displayNumber(outcome, index),
                      levelCount: levels.length,
                      title: (outcome.titleKey ?? outcome.levelKey).tr(),
                      score: outcome.scorePercent,
                      passed: outcome.passed,
                      color: color,
                    ),
                    const SizedBox(height: 16),
                    InsightsCardWidget(
                      metrics: _buildMetrics(outcome),
                      color: color,
                    ),
                    const SizedBox(height: 16),
                    OpportunityCardWidget(
                      opportunityText: (outcome.titleKey ?? outcome.levelKey)
                          .tr(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AppRoute.goToPotentialRecovery(
                    context: context,
                    result: widget.result,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF59C583),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    LocaleKeys.viewPotentialRecovery.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The measured numbers behind the level's score.
  List<LevelMetric> _buildMetrics(LevelOutcome outcome) {
    return [
      LevelMetric(
        label: LocaleKeys.metricAccuracy.tr(),
        value: '${outcome.accuracyPercent}%',
      ),
      LevelMetric(
        label: LocaleKeys.metricReactionTime.tr(),
        // The server sends 0 when it has no reaction-time data for the level.
        value: outcome.averageReactionTime <= 0
            ? _noValue
            : outcome.averageReactionTime.toStringAsFixed(2),
      ),
      LevelMetric(
        label: LocaleKeys.metricMissRate.tr(),
        value: '${outcome.missRatePercent}%',
      ),
      LevelMetric(
        label: LocaleKeys.metricCompletionTime.tr(),
        value: outcome.completionTime.toStringAsFixed(1),
      ),
      LevelMetric(
        label: LocaleKeys.metricAttempts.tr(),
        value: outcome.attempts.toString(),
      ),
      LevelMetric(
        label: LocaleKeys.metricSuccesses.tr(),
        value: outcome.successes.toString(),
      ),
    ];
  }

  /// The level's own number, falling back to its position when the server key
  /// carries none.
  int _displayNumber(LevelOutcome outcome, int index) =>
      outcome.levelNumber > 0 ? outcome.levelNumber : index + 1;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF6B8296),
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: -8,
      title: Text(
        LocaleKeys.back.tr(),
        style: const TextStyle(
          color: Color(0xFF6B8296),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
