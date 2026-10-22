class RecoveryScoreStep {
  const RecoveryScoreStep({
    required this.score,
    required this.label,
    this.isCurrent = false,
  });

  final double score;
  final String label;
  final bool isCurrent;

  factory RecoveryScoreStep.fromJson(Map<String, dynamic> json) {
    return RecoveryScoreStep(
      score: (json['score'] as num).toDouble(),
      label: json['label'] as String,
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'score': score,
    'label': label,
    'isCurrent': isCurrent,
  };
}
