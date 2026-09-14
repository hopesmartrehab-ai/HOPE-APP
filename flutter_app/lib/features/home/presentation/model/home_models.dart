class HomeDataModel {
  final String userName;
  final TodaySessionModel todaySession;
  final PathModel pathData;
  final WeeklyStatsModel weeklyStats;
  final RecoveryProgressModel progressData;

  const HomeDataModel({
    required this.userName,
    required this.todaySession,
    required this.pathData,
    required this.weeklyStats,
    required this.progressData,
  });
}

class TodaySessionModel {
  final int currentDay;
  final int totalDays;
  final String title;
  final String focus;
  final int exercisesCount;
  final int durationMinutes;
  final int streakDays;

  const TodaySessionModel({
    required this.currentDay,
    required this.totalDays,
    required this.title,
    required this.focus,
    required this.exercisesCount,
    required this.durationMinutes,
    required this.streakDays,
  });
}

class PathModel {
  final String pathName;
  final String nextFollowUpDate;
  final int currentWeek;
  final int totalWeeks;

  const PathModel({
    required this.pathName,
    required this.nextFollowUpDate,
    required this.currentWeek,
    required this.totalWeeks,
  });
}

class WeeklyStatsModel {
  final int sessionsDone;
  final int totalSessions;
  final int improvementPercentage;
  final int dayStreak;

  const WeeklyStatsModel({
    required this.sessionsDone,
    required this.totalSessions,
    required this.improvementPercentage,
    required this.dayStreak,
  });
}

class RecoveryProgressModel {
  final int overallProgress;
  final int gripStrength;
  final int coordination;

  const RecoveryProgressModel({
    required this.overallProgress,
    required this.gripStrength,
    required this.coordination,
  });
}
