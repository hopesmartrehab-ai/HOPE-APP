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
import 'exercise_results_screen.dart';

class ExerciseWaitingScreen extends StatefulWidget {
  const ExerciseWaitingScreen({super.key});

  @override
  State<ExerciseWaitingScreen> createState() => _ExerciseWaitingScreenState();
}

class _ExerciseWaitingScreenState extends State<ExerciseWaitingScreen> {
  bool _navigated = false;
  // Local-only counter for the tutorial carousel. The backend always scores
  // needed_training[0] regardless of what the user is watching here — this
  // index just drives which YouTube video and label are shown.
  int _currentIndex = 0;
  // Index into the list of videos for the current exercise category.
  int _videoIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start polling immediately — the backend accumulates exercise data
    // automatically after the assessment phase completes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().startPollingForExercise();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final t = AppLocalizations.of(context);
    final neededTraining =
        provider.currentSession?.assessmentResults?.neededTraining ?? [];
    final hasList = neededTraining.isNotEmpty;
    // Clamp in case the list shrinks underneath us (e.g. redo-assessment).
    final safeIndex = hasList
        ? _currentIndex.clamp(0, neededTraining.length - 1)
        : 0;
    final exerciseName = hasList ? neededTraining[safeIndex] : 'General';
    final isLast = !hasList || safeIndex >= neededTraining.length - 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.errorMessage != null) {
        showSessionError(context, provider.errorMessage);
        provider.clearError();
      }
      if (provider.state == SessionState.exerciseDone && !_navigated) {
        _navigated = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ExerciseResultsScreen()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(t.exercise),
        actions: const [LanguageToggle()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.fitness_center, size: 64, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              hasList
                  ? t.exerciseProgress(
                      safeIndex + 1,
                      neededTraining.length,
                      exerciseName,
                    )
                  : t.exerciseLabel(exerciseName),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              t.exerciseDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (_) {
                final videos = allVideoUrlsFor(exerciseName);
                final safeVideoIdx = _videoIndex.clamp(0, videos.length - 1);
                return Column(
                  children: [
                    ExerciseVideoPlayer(videoUrl: videos[safeVideoIdx]),
                    if (videos.length > 1) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            onPressed: safeVideoIdx > 0
                                ? () => setState(
                                    () => _videoIndex = safeVideoIdx - 1,
                                  )
                                : null,
                          ),
                          Text(
                            '${safeVideoIdx + 1} / ${videos.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            onPressed: safeVideoIdx < videos.length - 1
                                ? () => setState(
                                    () => _videoIndex = safeVideoIdx + 1,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
            if (hasList && !isLast) ...[
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  icon: const Icon(Icons.skip_next),
                  label: Text(t.nextExercise),
                  onPressed: () => setState(() {
                    _currentIndex = safeIndex + 1;
                    _videoIndex = 0;
                  }),
                ),
              ),
            ],
            const SizedBox(height: 16),
            const VideoRecorderWidget(),
            const SizedBox(height: 16),
            // ---- Accumulation progress / waiting UI ----
            ..._buildAccumulationUI(provider, t),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              t.noGloveSimulate,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            provider.isSimulating
                ? const SizedBox(
                    height: 36,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : OutlinedButton.icon(
                    icon: const Icon(Icons.science_outlined),
                    label: Text(t.simulateGloveExercise),
                    onPressed: () {
                      context.read<SessionProvider>().simulateGlove();
                    },
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

    final List<Widget> widgets = [];

    // Device disconnection warning banner
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
      // Accumulation hasn't started yet — show waiting message
      widgets.addAll([
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 16),
        Text(
          t.waitingForDevice,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          t.exerciseDesc,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ]);
    }

    return widgets;
  }
}
