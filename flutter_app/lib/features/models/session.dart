import 'assessment_result.dart';
import 'exercise_result.dart';

class SessionSummary {
  final String sessionId;
  final String createdAt;
  final String status;
  final int? assessmentPassed;
  final int? assessmentTotal;
  final List<String>? neededTraining;
  final String? exerciseName;
  final double? exerciseOverallPercent;

  const SessionSummary({
    required this.sessionId,
    required this.createdAt,
    required this.status,
    this.assessmentPassed,
    this.assessmentTotal,
    this.neededTraining,
    this.exerciseName,
    this.exerciseOverallPercent,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    final summary = json['assessment_summary'] as Map<String, dynamic>?;
    return SessionSummary(
      sessionId: json['session_id'] as String,
      createdAt: json['created_at'] as String,
      status: json['status'] as String,
      assessmentPassed:
          summary != null ? (summary['passed'] as num?)?.toInt() : null,
      assessmentTotal:
          summary != null ? (summary['total'] as num?)?.toInt() : null,
      neededTraining: summary != null
          ? (summary['needed_training'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
          : null,
      exerciseName: json['exercise_name'] as String?,
      exerciseOverallPercent:
          (json['exercise_overall_percent'] as num?)?.toDouble(),
    );
  }
}

class Session {
  final String sessionId;
  final String createdAt;
  final String status;
  final String? deviceId;
  final Map<String, dynamic>? questionnaire;
  final AssessmentResult? assessmentResults;
  final Map<String, String>? assessmentFeatures;
  final ExerciseResult? exerciseResults;
  final String? videoUrl;

  // Accumulation fields (backend sends these during data collection)
  final String? ingestStartedAt;
  final String? lastBatchAt;
  final int? batchCount;
  final String? accumulationPhase; // "assessment" or "exercise" or null
  final int? secondsRequired; // 180 or 300 or null

  const Session({
    required this.sessionId,
    required this.createdAt,
    required this.status,
    this.deviceId,
    this.questionnaire,
    this.assessmentResults,
    this.assessmentFeatures,
    this.exerciseResults,
    this.videoUrl,
    this.ingestStartedAt,
    this.lastBatchAt,
    this.batchCount,
    this.accumulationPhase,
    this.secondsRequired,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    final assessmentJson = json['assessment_results'] as Map<String, dynamic>?;
    final exerciseJson = json['exercise_results'] as Map<String, dynamic>?;
    final featuresRaw = json['assessment_features'] as Map<String, dynamic>?;

    return Session(
      sessionId: json['session_id'] as String,
      createdAt: json['created_at'] as String,
      status: json['status'] as String,
      deviceId: json['device_id'] as String?,
      questionnaire: json['questionnaire'] as Map<String, dynamic>?,
      assessmentResults: assessmentJson != null
          ? AssessmentResult.fromJson(assessmentJson)
          : null,
      assessmentFeatures:
          featuresRaw?.map((k, v) => MapEntry(k, v.toString())),
      exerciseResults:
          exerciseJson != null ? ExerciseResult.fromJson(exerciseJson) : null,
      videoUrl: json['video_url'] as String?,
      ingestStartedAt: json['ingest_started_at'] as String?,
      lastBatchAt: json['last_batch_at'] as String?,
      batchCount: (json['batch_count'] as num?)?.toInt(),
      accumulationPhase: json['accumulation_phase'] as String?,
      secondsRequired: (json['seconds_required'] as num?)?.toInt(),
    );
  }
}
