import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/features/home/presentation/assessment_complete/widget/custom_header.dart';
import 'package:hope_app/features/home/presentation/dashboard/widgets/home_welcome_section.dart';
import 'package:hope_app/features/home/presentation/dashboard/widgets/recovery_progress_card.dart';
import 'package:hope_app/features/home/presentation/dashboard/widgets/this_week_section.dart';
import 'package:hope_app/features/home/presentation/dashboard/widgets/today_session_card.dart';
import 'package:hope_app/features/home/presentation/dashboard/widgets/your_path_card.dart';
import 'package:hope_app/features/home/presentation/model/home_models.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const mockData = HomeDataModel(
      userName: 'Mohamed ',
      todaySession: TodaySessionModel(
        currentDay: 12,
        totalDays: 84,
        title: 'Grip & Coordination',
        focus: 'Grasp strength and finger coordination',
        exercisesCount: 3,
        durationMinutes: 20,
        streakDays: 12,
      ),
      pathData: PathModel(
        pathName: 'Online Rehabilitation',
        nextFollowUpDate: 'Sept 28',
        currentWeek: 2,
        totalWeeks: 12,
      ),
      weeklyStats: WeeklyStatsModel(
        sessionsDone: 4,
        totalSessions: 5,
        improvementPercentage: 8,
        dayStreak: 12,
      ),
      progressData: RecoveryProgressModel(
        overallProgress: 23,
        gripStrength: 35,
        coordination: 28,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(),
                const SizedBox(height: 24),
                HomeWelcomeSection(userName: mockData.userName),
                const SizedBox(height: 24),
                TodaySessionCard(sessionData: mockData.todaySession),
                const SizedBox(height: 16),
                YourPathCard(pathData: mockData.pathData),
                const SizedBox(height: 24),
                ThisWeekSection(statsData: mockData.weeklyStats),
                const SizedBox(height: 24),
                RecoveryProgressCard(progressData: mockData.progressData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
