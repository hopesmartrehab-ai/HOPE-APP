import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/features/progress/data/models/exercise_item_model.dart';
import 'package:hope_app/features/progress/data/models/session_details_model.dart';
import 'package:hope_app/features/progress/data/models/session_model.dart';
import 'package:hope_app/features/progress/data/models/therapist_note_model.dart';
import 'package:hope_app/features/progress/presentation/screens/session_details_screen.dart';
import 'package:hope_app/features/progress/presentation/widgets/progress_page_header.dart';
import 'package:hope_app/features/progress/presentation/widgets/session_history_card.dart';

class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({super.key});

  static const _sessions = [
    SessionModel(
      id: 'session-001',
      dateLabel: LocaleKeys.progressToday,
      title: LocaleKeys.progressSessionGrip,
      subtitle: LocaleKeys.progressThreeExercises18,
      durationMinutes: 18,
      status: SessionStatus.completed,
      isCurrent: true,
    ),
    SessionModel(
      id: 'session-002',
      dateLabel: LocaleKeys.progressToday,
      title: LocaleKeys.progressSessionReach,
      subtitle: LocaleKeys.progressFourExercises22,
      durationMinutes: 22,
      status: SessionStatus.completed,
      isCurrent: true,
    ),
    SessionModel(
      id: 'session-003',
      dateLabel: 'Sep 1',
      title: LocaleKeys.progressSessionFineMotor,
      subtitle: LocaleKeys.progressThreeExercises16,
      durationMinutes: 16,
      status: SessionStatus.completed,
    ),
    SessionModel(
      id: 'session-004',
      dateLabel: 'Aug 31',
      title: LocaleKeys.progressSessionGripStrength,
      subtitle: LocaleKeys.progressThreeExercises20,
      durationMinutes: 20,
      status: SessionStatus.partial,
    ),
    SessionModel(
      id: 'session-005',
      dateLabel: 'Aug 30',
      title: LocaleKeys.progressSessionCoordination,
      subtitle: LocaleKeys.progressFourExercises25,
      durationMinutes: 25,
      status: SessionStatus.completed,
    ),
    SessionModel(
      id: 'session-006',
      dateLabel: 'Aug 28',
      title: LocaleKeys.progressSessionWrist,
      subtitle: LocaleKeys.progressThreeExercises18,
      durationMinutes: 18,
      status: SessionStatus.completed,
    ),
  ];

  static const _sessionDetails = SessionDetailsModel(
    id: 'session-001',
    completedExercises: 3,
    totalExercises: 3,
    durationMinutes: 18,
    performanceScore: 0.84,
    exercises: [
      ExerciseItemModel(
        name: LocaleKeys.progressExerciseWristRotation,
        device: LocaleKeys.progressDeviceMobile,
        duration: '3:12',
        rating: ExerciseRating.good,
      ),
      ExerciseItemModel(
        name: LocaleKeys.progressExercisePowerGrip,
        device: LocaleKeys.progressDeviceSmartGlove,
        duration: '5:48',
        rating: ExerciseRating.excellent,
      ),
      ExerciseItemModel(
        name: LocaleKeys.progressExercisePinchRelease,
        device: LocaleKeys.progressDeviceVideo,
        duration: '5:22',
        rating: ExerciseRating.good,
      ),
    ],
    therapistNote: TherapistNoteModel(
      note: LocaleKeys.progressTherapistNoteContent,
      therapistName: 'Dr. Amina Hassan',
      reviewedDate: 'Sept 2',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: ProgressPageHeader(
                  title: LocaleKeys.progressSessionHistory,
                  subtitle: LocaleKeys.progressSessionsCompleted.tr(
                    args: ['28'],
                  ),
                  backLabel: LocaleKeys.back,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: _sessions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final session = _sessions[index];
                    return SessionHistoryCard(
                      session: session,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => SessionDetailsScreen(
                            session: session,
                            details: _sessionDetails,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
