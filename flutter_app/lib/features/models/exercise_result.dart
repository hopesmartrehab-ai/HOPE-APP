class ExerciseResult {
  final String exercise;
  final Map<String, double> features;
  final double overallPercent;
  final String message;
  final String timestamp;

  const ExerciseResult({
    required this.exercise,
    required this.features,
    required this.overallPercent,
    required this.message,
    required this.timestamp,
  });

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    final featuresRaw = json['features'] as Map<String, dynamic>;
    final features = featuresRaw.map(
      (k, v) => MapEntry(k, (v as num).toDouble()),
    );
    return ExerciseResult(
      exercise: json['exercise'] as String,
      features: features,
      overallPercent: (json['overall_percent'] as num).toDouble(),
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );
  }
}
