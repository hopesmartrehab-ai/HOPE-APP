import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/session_provider.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/result_card.dart';
import 'assess_waiting_screen.dart';
import 'questionnaire_screen.dart';

class AssessmentResultsScreen extends StatelessWidget {
  const AssessmentResultsScreen({super.key});

  Future<void> _redo(BuildContext context) async {
    await context.read<SessionProvider>().redoAssessment();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AssessWaitingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final assessment = provider.currentSession?.assessmentResults;
    final t = AppLocalizations.of(context);

    if (assessment == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final results = assessment.functionResults;
    final passedCount = results.values.where((v) => v == 'PASS').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.assessmentResults),
        actions: const [LanguageToggle()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  t.functionsPassed(passedCount, results.length),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: results.entries
                    .map((e) => ResultCard(
                          functionName: e.key,
                          passed: e.value == 'PASS',
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(t.redoAssessment),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () => _redo(context),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const QuestionnaireScreen()),
              ),
              child: Text(t.continueToCheckin),
            ),
          ],
        ),
      ),
    );
  }
}
