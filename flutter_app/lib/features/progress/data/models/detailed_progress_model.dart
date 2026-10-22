import 'package:hope_app/features/progress/data/models/metric_item_model.dart';
import 'package:hope_app/features/progress/data/models/recovery_score_step.dart';

class DetailedProgressModel {
  const DetailedProgressModel({
    required this.recoveryHistory,
    required this.consistencyMatrix,
    required this.keyMetrics,
  });

  final List<RecoveryScoreStep> recoveryHistory;
  final List<List<int>> consistencyMatrix;
  final List<MetricItemModel> keyMetrics;

  factory DetailedProgressModel.fromJson(Map<String, dynamic> json) {
    return DetailedProgressModel(
      recoveryHistory: (json['recoveryHistory'] as List<dynamic>)
          .map(
            (item) =>
                RecoveryScoreStep.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      consistencyMatrix: (json['consistencyMatrix'] as List<dynamic>)
          .map(
            (row) => (row as List<dynamic>)
                .map((cell) => (cell as num).toInt())
                .toList(),
          )
          .toList(),
      keyMetrics: (json['keyMetrics'] as List<dynamic>)
          .map((item) => MetricItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'recoveryHistory': recoveryHistory.map((item) => item.toJson()).toList(),
    'consistencyMatrix': consistencyMatrix,
    'keyMetrics': keyMetrics.map((item) => item.toJson()).toList(),
  };
}
