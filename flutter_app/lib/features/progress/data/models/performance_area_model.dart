class PerformanceAreaModel {
  const PerformanceAreaModel({
    required this.name,
    required this.initialScore,
    required this.currentScore,
  });

  final String name;
  final double initialScore;
  final double currentScore;

  double get delta => currentScore - initialScore;

  factory PerformanceAreaModel.fromJson(Map<String, dynamic> json) {
    return PerformanceAreaModel(
      name: json['name'] as String,
      initialScore: (json['initialScore'] as num).toDouble(),
      currentScore: (json['currentScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'initialScore': initialScore,
    'currentScore': currentScore,
  };
}
