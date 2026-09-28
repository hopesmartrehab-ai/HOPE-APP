import '../../domain/entities/assessment_result.dart';
import '../../domain/entities/level_outcome.dart';
import '../../domain/entities/rehab_pathway.dart';

/// Parses the payload of `GET /api/v1/sessions/latest`.
///
/// Every field is read defensively: a missing or malformed value degrades to a
/// safe default rather than throwing, so one changed server field cannot blank
/// out the whole results screen.
abstract class AssessmentResultModel {
  AssessmentResultModel._();

  static AssessmentResult fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      sessionId: _string(json['sessionId']),
      patientId: _string(json['patientId']),
      pathway: RehabPathway.fromApi(json['pathway']),
      sessionFinalized: json['sessionFinalized'] == true,
      receivedAtUtc: _dateTime(json['receivedAtUtc']),
      outcomes: _outcomes(json['outcomes']),
    );
  }

  static List<LevelOutcome> _outcomes(Object? value) {
    if (value is! List) return const [];

    final outcomes = <LevelOutcome>[];
    for (final entry in value) {
      if (entry is Map) {
        outcomes.add(
          LevelOutcome(
            levelKey: _string(entry['levelKey']),
            score01: _double(entry['score01']),
            accuracy: _double(entry['accuracy']),
            averageReactionTime: _double(entry['averageReactionTime']),
            missRate: _double(entry['missRate']),
            completionTime: _double(entry['completionTime']),
            passed: entry['passed'] == true,
            attempts: _int(entry['attempts']),
            successes: _int(entry['successes']),
          ),
        );
      }
    }
    return outcomes;
  }

  static String _string(Object? value) => value?.toString() ?? '';

  static double _double(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(_string(value)) ?? 0;
  }

  static int _int(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(_string(value)) ?? 0;
  }

  /// Falls back to the epoch, which reads as "not fresh" and so makes the
  /// caller retry rather than show a stale session as the current one.
  static DateTime _dateTime(Object? value) {
    final parsed = DateTime.tryParse(_string(value));
    return parsed?.toUtc() ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
