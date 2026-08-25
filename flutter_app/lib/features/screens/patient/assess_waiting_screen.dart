import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/old_core/l10n/gen/app_localizations.dart';
import '../../../core/old_core/services/exercise_videos.dart';
import '../../state/session_provider.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/exercise_video_player.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/video_recorder_widget.dart';
import 'assessment_results_screen.dart';

class AssessWaitingScreen extends StatefulWidget {
  const AssessWaitingScreen({super.key});

  @override
  State<AssessWaitingScreen> createState() => _AssessWaitingScreenState();
}

class _AssessWaitingScreenState extends State<AssessWaitingScreen> {
  bool _navigated = false;
  int _assessIndex = 0;

  static const _assessCategories = [
    'Reach',
    'Grasp',
    'Manipulation',
    'Release',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().startPollingForAssessment();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final t = AppLocalizations.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.errorMessage != null) {
        showSessionError(context, provider.errorMessage);
        provider.clearError();
      }
      if (provider.state == SessionState.assessmentDone && !_navigated) {
        _navigated = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AssessmentResultsScreen()),
        );
      }
    });

    final simulating = provider.isSimulating;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.assessment),
        actions: const [LanguageToggle()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Assessment tutorial video carousel ----
            Text(
              _assessCategories[_assessIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ExerciseVideoPlayer(
              videoUrl: assessmentVideoUrlFor(_assessCategories[_assessIndex]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: _assessIndex > 0
                      ? () => setState(() => _assessIndex--)
                      : null,
                ),
                Text(
                  '${_assessIndex + 1} of ${_assessCategories.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: _assessIndex < _assessCategories.length - 1
                      ? () => setState(() => _assessIndex++)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // ---- Accumulation progress / waiting UI ----
            ..._buildAccumulationUI(provider, t),
            const SizedBox(height: 16),
            const VideoRecorderWidget(),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              t.noGloveSimulate,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            simulating
                ? const SizedBox(
                    height: 36,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : OutlinedButton.icon(
                    icon: const Icon(Icons.science_outlined),
                    label: Text(t.simulateGloveAssessment),
                    onPressed: () =>
                        context.read<SessionProvider>().simulateGlove(),
                  ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAccumulationUI(
    SessionProvider provider,
    AppLocalizations t,
  ) {
    final startedAt = provider.accumulationStartedAt;
    final secondsReq = provider.secondsRequired;
    final batches = provider.batchCount;
    final disconnected = provider.deviceDisconnected;

    // Device disconnection warning banner
    final List<Widget> widgets = [];

    if (disconnected) {
      widgets.add(
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.deviceDisconnectedWarning,
                  style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (startedAt != null) {
      // Accumulation is in progress — show countdown
      final elapsed = DateTime.now().toUtc().difference(startedAt).inSeconds;
      final remaining = max(0, secondsReq - elapsed);
      final mins = (remaining ~/ 60).toString();
      final secs = (remaining % 60).toString().padLeft(2, '0');
      final progress = secondsReq > 0
          ? ((secondsReq - remaining) / secondsReq).clamp(0.0, 1.0)
          : 0.0;

      if (remaining > 0) {
        widgets.addAll([
          Text(
            t.accumulationProgress,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 12),
          Text(
            t.accumulationTimeRemaining(mins, secs),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            t.batchesReceived(batches),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ]);
      } else {
        // Timer expired, waiting for backend to finish scoring
        widgets.addAll([
          const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 16),
          Text(
            t.dataCollectionComplete,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ]);
      }
    } else {
      // Accumulation hasn't started yet — show original waiting UI
      widgets.addAll([
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 24),
        Text(
          t.waitingForDevice,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          t.assessmentDesc,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ]);
    }

    return widgets;
  }
}
