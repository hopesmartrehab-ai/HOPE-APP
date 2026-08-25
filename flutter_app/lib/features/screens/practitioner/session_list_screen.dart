import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:provider/provider.dart';

import '../../state/session_provider.dart';
import '../../widgets/language_toggle.dart';
import 'session_detail_screen.dart';

class SessionListScreen extends StatefulWidget {
  const SessionListScreen({super.key});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().loadSessionHistory();
    });
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'exercised':
      case 'completed':
        return Colors.green;
      case 'assessed':
      case 'questionnaire_done':
        return Colors.teal;
      case 'created':
      case 'in_progress':
        return Colors.orange;
      case 'accumulating_assessment':
      case 'accumulating_exercise':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return LocaleKeys.statusCreated.tr();
      case 'questionnaire_done':
        return LocaleKeys.statusQuestionnaireDone.tr();
      case 'assessed':
        return LocaleKeys.statusAssessed.tr();
      case 'exercised':
        return LocaleKeys.statusExercised.tr();
      case 'completed':
        return LocaleKeys.statusCompleted.tr();
      case 'in_progress':
        return LocaleKeys.statusInProgress.tr();
      case 'accumulating_assessment':
        return LocaleKeys.statusAccumulatingAssessment.tr();
      case 'accumulating_exercise':
        return LocaleKeys.statusAccumulatingExercise.tr();
      default:
        return LocaleKeys.statusUnknown.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.sessionHistory.tr()),
        actions:  const [LanguageToggle()],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<SessionProvider>().loadSessionHistory(),
        child: provider.sessionHistory.isEmpty
            ? Center(child: Text(LocaleKeys.noSessionsFound.tr()))
            : ListView.builder(
                itemCount: provider.sessionHistory.length,
                itemBuilder: (context, index) {
                  final s = provider.sessionHistory[index];
                  String dateStr = s.createdAt;
                  try {
                    final dt = DateTime.parse(s.createdAt);
                    dateStr = DateFormat(
                      'MMM d, yyyy — h:mm a',
                      locale,
                    ).format(dt);
                  } catch (_) {}
                  final assessText = s.assessmentPassed != null
                      ? LocaleKeys.assessSummary.tr(
                          args: [
                            s.assessmentPassed!.toString(),
                            (s.assessmentTotal ?? 0).toString(),
                          ],
                        )
                      : LocaleKeys.noAssessment.tr();
                  final exerciseText = s.exerciseOverallPercent != null
                      ? LocaleKeys.exerciseSummary.tr(
                          args: [s.exerciseOverallPercent!.toStringAsFixed(1)],
                        )
                      : '';
                  return ListTile(
                    title: Text(dateStr),
                    subtitle: Text(
                      [
                        assessText,
                        if (exerciseText.isNotEmpty) exerciseText,
                      ].join(' | '),
                    ),
                    trailing: Chip(
                      label: Text(LocaleKeys.statusUnknown.tr()), // Replace with actual status label translation
                      backgroundColor: _statusColor(
                        s.status,
                      ).withValues(alpha: 0.15),
                      labelStyle: TextStyle(color: _statusColor(s.status)),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SessionDetailScreen(sessionId: s.sessionId),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
