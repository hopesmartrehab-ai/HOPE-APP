class FunctionalProgressModel {
  const FunctionalProgressModel({
    required this.skillName,
    required this.percentage,
    required this.scoreLabel,
  });

  final String skillName;
  final double percentage;
  final String scoreLabel;

  factory FunctionalProgressModel.fromJson(Map<String, dynamic> json) {
    return FunctionalProgressModel(
      skillName: json['skillName'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      scoreLabel: json['scoreLabel'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'skillName': skillName,
    'percentage': percentage,
    'scoreLabel': scoreLabel,
  };
}
