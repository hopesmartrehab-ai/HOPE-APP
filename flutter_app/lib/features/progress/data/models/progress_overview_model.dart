class ProgressOverviewModel {
  const ProgressOverviewModel({
    required this.overallScore,
    required this.streak,
    required this.completedSessionsCount,
    required this.improvementPercentage,
  });

  final double overallScore;
  final int streak;
  final int completedSessionsCount;
  final double improvementPercentage;

  factory ProgressOverviewModel.fromJson(Map<String, dynamic> json) {
    return ProgressOverviewModel(
      overallScore: (json['overallScore'] as num).toDouble(),
      streak: (json['streak'] as num).toInt(),
      completedSessionsCount: (json['completedSessionsCount'] as num).toInt(),
      improvementPercentage: (json['improvementPercentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'overallScore': overallScore,
    'streak': streak,
    'completedSessionsCount': completedSessionsCount,
    'improvementPercentage': improvementPercentage,
  };
}
