import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/features/progress/data/models/detailed_progress_model.dart';
import 'package:hope_app/features/progress/data/models/metric_item_model.dart';
import 'package:hope_app/features/progress/data/models/recovery_score_step.dart';
import 'package:hope_app/features/progress/presentation/widgets/consistency_heatmap_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/key_metrics_card.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_filter_selector.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_page_header.dart';
import 'package:hope_app/features/progress/presentation/widgets/recovery_history_card.dart';
import 'package:easy_localization/easy_localization.dart';

const _sampleDetailedProgress = DetailedProgressModel(
  recoveryHistory: [
    RecoveryScoreStep(score: 0.20, label: 'Start'),
    RecoveryScoreStep(score: 0.35, label: ''),
    RecoveryScoreStep(score: 0.48, label: ''),
    RecoveryScoreStep(score: 0.55, label: ''),
    RecoveryScoreStep(score: 0.63, label: ''),
    RecoveryScoreStep(score: 0.72, label: 'Now', isCurrent: true),
  ],
  consistencyMatrix: [
    [1, 1, 1, 1, 0, 0, 1],
    [1, 0, 1, 1, 1, 1, 0],
    [1, 0, 0, 0, 1, 1, 1],
    [0, 1, 1, 0, 1, 1, 1],
  ],
  keyMetrics: [
    MetricItemModel(
      title: LocaleKeys.progressMetricSessionsTitle,
      trend: LocaleKeys.progressMetricSessionsTrend,
      value: '28',
    ),
    MetricItemModel(
      title: LocaleKeys.progressMetricDurationTitle,
      trend: LocaleKeys.progressMetricDurationTrend,
      value: '18 min',
    ),
    MetricItemModel(
      title: LocaleKeys.progressMetricConsistencyTitle,
      trend: LocaleKeys.progressMetricConsistencyTrend,
      value: '82%',
    ),
    MetricItemModel(
      title: LocaleKeys.progressMetricImprovementTitle,
      trend: LocaleKeys.progressMetricImprovementTrend,
      value: '+23%',
    ),
  ],
);

class DetailedProgressScreen extends StatefulWidget {
  const DetailedProgressScreen({
    this.progress = _sampleDetailedProgress,
    super.key,
  });

  final DetailedProgressModel progress;

  @override
  State<DetailedProgressScreen> createState() => _DetailedProgressScreenState();
}

class _DetailedProgressScreenState extends State<DetailedProgressScreen> {
  int _selectedFilterIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const ProgressPageHeader(
                title: LocaleKeys.progressDetailedProgress,
                backLabel: LocaleKeys.back,
              ),
              const SizedBox(height: 16),
              ProgressFilterSelector(
                selectedIndex: _selectedFilterIndex,
                onChanged: (index) =>
                    setState(() => _selectedFilterIndex = index),
              ),
              const SizedBox(height: 16),
              RecoveryHistoryCard(steps: widget.progress.recoveryHistory),
              const SizedBox(height: 16),
              ConsistencyHeatmapCard(
                matrix: widget.progress.consistencyMatrix,
                summary: LocaleKeys.progressConsistencySummary.tr(),
              ),
              const SizedBox(height: 16),
              KeyMetricsCard(metrics: widget.progress.keyMetrics),
            ],
          ),
        ),
      ),
    );
  }
}
