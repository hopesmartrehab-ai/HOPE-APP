import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:provider/provider.dart';

import '../../models/session.dart';
import '../../state/session_provider.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/result_card.dart';
import '../../widgets/score_bar.dart';
import '../../widgets/video_player_widget.dart';

class SessionDetailScreen extends StatelessWidget {
  final String sessionId;

  const SessionDetailScreen({required this.sessionId, super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.deleteSessionConfirmTitle.tr()),
        content: Text(LocaleKeys.deleteSessionConfirmBody.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final ok = await context.read<SessionProvider>().deleteSession(sessionId);
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(LocaleKeys.deletedConfirm.tr())));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.sessionDetail.tr()),
        actions: [
          IconButton(
            tooltip: LocaleKeys.deleteSession.tr(),
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
          const LanguageToggle(),
        ],
      ),
      body: FutureBuilder<Session?>(
        future: context.read<SessionProvider>().loadSessionDetail(sessionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final session = snapshot.data;
          if (session == null) {
            return Center(child: Text(LocaleKeys.failedToLoadSession.tr()));
          }
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: LocaleKeys.tabAssessment.tr()),
                    Tab(text: LocaleKeys.tabExercise.tr()),
                    Tab(text: LocaleKeys.tabInfo.tr()),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _AssessmentTab(session: session),
                      _ExerciseTab(session: session),
                      _InfoTab(session: session),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AssessmentTab extends StatelessWidget {
  final Session session;
  const _AssessmentTab({required this.session});

  @override
  Widget build(BuildContext context) {
    final results = session.assessmentResults;
    if (results == null) {
      return Center(child: Text(LocaleKeys.noAssessmentData.tr()));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: results.functionResults.entries
          .map(
            (e) => ResultCard(functionName: e.key, passed: e.value == 'PASS'),
          )
          .toList(),
    );
  }
}

class _ExerciseTab extends StatelessWidget {
  final Session session;
  const _ExerciseTab({required this.session});

  @override
  Widget build(BuildContext context) {
    final exercise = session.exerciseResults;
    if (exercise == null) {
      return Center(child: Text(LocaleKeys.noExerciseData.tr()));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          exercise.exercise,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.overallPercent.tr(args: [exercise.overallPercent.toStringAsFixed(1)]),
          style: const TextStyle(fontSize: 18, color: Colors.teal),
        ),
        const SizedBox(height: 4),
        Text(exercise.message),
        const SizedBox(height: 16),
        ...exercise.features.entries.map(
          (e) => ScoreBar(label: e.key, percent: e.value),
        ),
      ],
    );
  }
}

class _InfoTab extends StatelessWidget {
  final Session session;
  const _InfoTab({required this.session});

  String _label(String key) {
    switch (key) {
      case 'sleep_hours':
        return LocaleKeys.labelSleepHours.tr();
      case 'body_temperature':
        return LocaleKeys.labelBodyTemperature.tr();
      case 'blood_sugar':
        return LocaleKeys.labelBloodSugar.tr();
      case 'blood_pressure':
        return LocaleKeys.labelBloodPressure.tr();
      case 'headache':
        return LocaleKeys.labelHeadache.tr();
      case 'dizzy':
        return LocaleKeys.labelDizzy.tr();
      case 'fatigue':
        return LocaleKeys.labelFatigue.tr();
      case 'arm_pain':
        return LocaleKeys.labelArmPain.tr();
      case 'hand_movement':
        return LocaleKeys.labelHandMovement.tr();
      case 'falls_injuries':
        return LocaleKeys.labelFallsInjuries.tr();
      default:
        return key;
    }
  }

  String _formatValue(String key, dynamic value) {
    if (value is bool) return value ? LocaleKeys.yes.tr() : LocaleKeys.no.tr();
    if (key == 'blood_pressure' && value is Map) {
      return '${value['systolic']}/${value['diastolic']}';
    }
    if (value is num) return value.toString();
    return value?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final q = session.questionnaire;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          LocaleKeys.questionnaire.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (q == null)
          Text(
            LocaleKeys.questionnaireSkipped.tr(),
            style: const TextStyle(color: Colors.grey),
          )
        else
          ...q.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      _label(e.key),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(child: Text(_formatValue(e.key, e.value))),
                ],
              ),
            ),
          ),
        const Divider(height: 32),
        if (session.videoUrl != null) ...[
          Text(
            LocaleKeys.sessionVideo.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          VideoPlayerWidget(videoUrl: session.videoUrl!),
        ],
      ],
    );
  }
}
