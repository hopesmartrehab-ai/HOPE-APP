class TrainingResultModel {
  const TrainingResultModel({
    required this.completedLevels,
    required this.totalLevels,
  });

  final int completedLevels;
  final int totalLevels;

  int get normalizedCompletedLevels {
    if (totalLevels <= 0) return 0;
    return completedLevels.clamp(0, totalLevels).toInt();
  }

  int get completionPercentage {
    if (totalLevels <= 0) return 0;
    return ((normalizedCompletedLevels / totalLevels) * 100).round();
  }

  String get completionGrade {
    if (completionPercentage >= 90) return 'A';
    if (completionPercentage >= 80) return 'B';
    if (completionPercentage >= 70) return 'C';
    if (completionPercentage >= 60) return 'D';
    return 'F';
  }

  factory TrainingResultModel.fromJson(Map<String, dynamic> json) {
    return TrainingResultModel(
      completedLevels: json['completedLevels'] as int,
      totalLevels: json['totalLevels'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'completedLevels': completedLevels,
    'totalLevels': totalLevels,
  };
}
