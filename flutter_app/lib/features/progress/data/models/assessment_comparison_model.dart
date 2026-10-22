import 'package:hope_app/features/progress/data/models/performance_area_model.dart';

class AssessmentComparisonModel {
  const AssessmentComparisonModel({
    required this.initialScore,
    required this.currentScore,
    required this.overallDelta,
    required this.areas,
  });

  final double initialScore;
  final double currentScore;
  final double overallDelta;
  final List<PerformanceAreaModel> areas;

  factory AssessmentComparisonModel.fromJson(Map<String, dynamic> json) {
    return AssessmentComparisonModel(
      initialScore: (json['initialScore'] as num).toDouble(),
      currentScore: (json['currentScore'] as num).toDouble(),
      overallDelta: (json['overallDelta'] as num).toDouble(),
      areas: (json['areas'] as List<dynamic>)
          .map(
            (item) => PerformanceAreaModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'initialScore': initialScore,
    'currentScore': currentScore,
    'overallDelta': overallDelta,
    'areas': areas.map((item) => item.toJson()).toList(),
  };
}
