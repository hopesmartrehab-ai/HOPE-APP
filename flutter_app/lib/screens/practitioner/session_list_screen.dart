import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../l10n/gen/app_localizations.dart';
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

  String _statusLabel(AppLocalizations t, String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return t.statusCreated;
      case 'questionnaire_done':
        return t.statusQuestionnaireDone;
      case 'assessed':
        return t.statusAssessed;
      case 'exercised':
        return t.statusExercised;
      case 'completed':
        return t.statusCompleted;
      case 'in_progress':
        return t.statusInProgress;
      case 'accumulating_assessment':
        return t.statusAccumulatingAssessment;
      case 'accumulating_exercise':
        return t.statusAccumulatingExercise;
      default:
        return t.statusUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.sessionHistory),
        actions: const [
          LanguageToggle(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<SessionProvider>().loadSessionHistory(),
        child: provider.sessionHistory.isEmpty
            ? Center(child: Text(t.noSessionsFound))
            : ListView.builder(
                itemCount: provider.sessionHistory.length,
                itemBuilder: (context, index) {
                  final s = provider.sessionHistory[index];
                  String dateStr = s.createdAt;
                  try {
                    final dt = DateTime.parse(s.createdAt);
                    dateStr =
                        DateFormat('MMM d, yyyy — h:mm a', locale).format(dt);
                  } catch (_) {}
                  final assessText = s.assessmentPassed != null
                      ? t.assessSummary(s.assessmentPassed!, s.assessmentTotal ?? 0)
                      : t.noAssessment;
                  final exerciseText = s.exerciseOverallPercent != null
                      ? t.exerciseSummary(
                          s.exerciseOverallPercent!.toStringAsFixed(1))
                      : '';
                  return ListTile(
                    title: Text(dateStr),
                    subtitle: Text(
                      [assessText, if (exerciseText.isNotEmpty) exerciseText]
                          .join(' | '),
                    ),
                    trailing: Chip(
                      label: Text(_statusLabel(t, s.status)),
                      backgroundColor:
                          _statusColor(s.status).withValues(alpha: 0.15),
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
