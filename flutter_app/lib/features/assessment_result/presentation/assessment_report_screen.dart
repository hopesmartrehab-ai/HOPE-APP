import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/locale_keys.dart';
import '../../../core/utils/app_route.dart';
import '../domain/entities/assessment_result.dart';
import '../domain/entities/level_outcome.dart';
import 'logic/assessment_result_cubit.dart';
import 'logic/score_palette.dart';
import 'widgets/area_card_widget.dart';
import 'widgets/overall_summary_card_widget.dart';
import 'widgets/pathway_banner_widget.dart';
import 'widgets/performance_bar_widget.dart';

class AssessmentReportPage extends StatelessWidget {
  const AssessmentReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssessmentResultCubit()..loadLatest(),
      child: const _AssessmentReportView(),
    );
  }
}

class _AssessmentReportView extends StatelessWidget {
  const _AssessmentReportView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      body: SafeArea(
        child: BlocBuilder<AssessmentResultCubit, AssessmentResultState>(
          builder: (context, state) {
            switch (state) {
              case AssessmentResultInitial():
              case AssessmentResultLoading():
                return const _ReportLoading();
              case AssessmentResultFailure():
                return _ReportFailure(
                  onRetry: () => context.read<AssessmentResultCubit>().retry(),
                );
              case AssessmentResultSuccess(:final result, :final isStale):
                if (result.outcomes.isEmpty) {
                  return _ReportFailure(
                    onRetry: () => context.read<AssessmentResultCubit>().retry(),
                  );
                }
                return _ReportContent(result: result, isStale: isStale);
            }
          },
        ),
      ),
    );
  }
}

class _ReportLoading extends StatelessWidget {
  const _ReportLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF59C583),
            strokeWidth: 4,
          ),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.assessmentResultsLoading.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B8296),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportFailure extends StatelessWidget {
  const _ReportFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Color(0xFF86A3B8),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.assessmentResultsError.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF15314B),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF59C583),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  LocaleKeys.assessmentResultsRetry.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportContent extends StatelessWidget {
  const _ReportContent({required this.result, required this.isStale});

  final AssessmentResult result;
  final bool isStale;

  @override
  Widget build(BuildContext context) {
    final ranked = result.byScoreDescending;

    // With four or more levels the two best and two weakest are worth naming;
    // in a short session one each avoids the cards repeating the same level.
    final areaCount = ranked.length >= 4 ? 2 : 1;
    final strengths = ranked.take(areaCount).toList();
    final focus = ranked.length >= 2
        ? ranked.reversed.take(areaCount).toList()
        : <LevelOutcome>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF59C583),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assessment_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.assessmentReportHeader.tr(),
                style: const TextStyle(
                  color: Color(0xFF6B8296),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            LocaleKeys.yourAssessmentResults.tr(),
            style: const TextStyle(
              color: Color(0xFF15314B),
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.completedTodayCount.tr(
              args: [
                result.levelCount.toString(),
                result.totalMinutes.toString(),
              ],
            ),
            style: const TextStyle(
              color: Color(0xFF6B8296),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          OverallSummaryCardWidget(
            score: result.overallScorePercent,
            bandLabelKey: result.bandLabelKey,
            bandDescriptionKey: result.bandDescriptionKey,
            passedCount: result.passedCount,
            levelCount: result.levelCount,
          ),
          if (isStale) ...[
            const SizedBox(height: 16),
            const _StaleNotice(),
          ],
          const SizedBox(height: 20),
          PathwayBannerWidget(pathway: result.pathway),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
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
                  LocaleKeys.performanceByArea.tr(),
                  style: const TextStyle(
                    color: Color(0xFF15314B),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(result.outcomes.length, (i) {
                  final outcome = result.outcomes[i];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i == result.outcomes.length - 1 ? 0 : 16,
                    ),
                    child: PerformanceBarWidget(
                      title: (outcome.titleKey ?? outcome.levelKey).tr(),
                      percentage: outcome.scorePercent,
                      color: scoreAccentColor(outcome.scorePercent),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AreaCardWidget(
                  icon: '💪',
                  title: LocaleKeys.strengthAreas.tr(),
                  items: strengths
                      .map((o) => o.titleKey ?? o.levelKey)
                      .toList(),
                  dotColor: const Color(0xFF59C583),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AreaCardWidget(
                  icon: '🎯',
                  title: LocaleKeys.focusAreas.tr(),
                  items: focus.map((o) => o.titleKey ?? o.levelKey).toList(),
                  dotColor: const Color(0xFFFF8B49),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () =>
                  AppRoute.goToDetailedPerformance(context: context, result: result),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF15314B),
                side: const BorderSide(color: Color(0xFF15314B), width: 1.5),
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                LocaleKeys.viewDetailedResults.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// Shown when the newest session on the server was still older than the one
/// that just finished, so the numbers may belong to an earlier session.
class _StaleNotice extends StatelessWidget {
  const _StaleNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0DCB4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFE8A33D),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              LocaleKeys.assessmentResultsStaleNotice.tr(),
              style: const TextStyle(
                color: Color(0xFF8A6520),
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
