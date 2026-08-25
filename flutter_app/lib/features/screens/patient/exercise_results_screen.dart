import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:provider/provider.dart';

import '../../state/session_provider.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/result_card.dart';
import '../../widgets/score_bar.dart';

class ExerciseResultsScreen extends StatelessWidget {
  const ExerciseResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final exercise = provider.currentSession?.exerciseResults;

    if (exercise == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.exerciseResults.tr()),
        actions: const [LanguageToggle()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    exercise.exercise,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${exercise.overallPercent.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    exercise.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.featureScores.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...exercise.features.entries.map(
            (e) => ScoreBar(label: e.key, percent: e.value),
          ),
          // Show assessment context
          if (provider.currentSession?.assessmentResults != null) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.assessmentResults.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...provider
                .currentSession!
                .assessmentResults!
                .functionResults
                .entries
                .map(
                  (e) => ResultCard(
                    functionName: e.key,
                    passed: e.value == 'PASS',
                  ),
                ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              context.read<SessionProvider>().resetSession();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text(LocaleKeys.finishSession.tr()),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
