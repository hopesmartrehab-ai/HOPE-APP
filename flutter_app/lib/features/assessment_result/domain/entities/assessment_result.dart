import '../../../../core/constants/locale_keys.dart';
import 'level_outcome.dart';
import 'rehab_pathway.dart';

/// A finalized assessment session, as rendered by the results screens.
class AssessmentResult {
  const AssessmentResult({
    required this.sessionId,
    required this.patientId,
    required this.pathway,
    required this.sessionFinalized,
    required this.receivedAtUtc,
    required this.outcomes,
  });

  final String sessionId;
  final String patientId;

  /// How the patient continues rehabilitation.
  final RehabPathway pathway;

  final bool sessionFinalized;

  /// When the backend received this session.
  ///
  /// The `latest` endpoint returns the most recently received session for
  /// everyone, so this is what tells a result recorded just now apart from the
  /// one already sitting on the server.
  final DateTime receivedAtUtc;

  final List<LevelOutcome> outcomes;

  int get levelCount => outcomes.length;

  int get passedCount => outcomes.where((outcome) => outcome.passed).length;

  /// Mean of the level scores as a whole percentage.
  ///
  /// The backend sends no overall score, so it is derived here. `0` when there
  /// are no outcomes.
  int get overallScorePercent {
    if (outcomes.isEmpty) return 0;

    final total = outcomes.fold<double>(0, (sum, o) => sum + o.score01);
    return ((total / outcomes.length) * 100).round().clamp(0, 100).toInt();
  }

  /// Total time the patient spent across all levels, in whole minutes.
  int get totalMinutes {
    final seconds = outcomes.fold<double>(0, (sum, o) => sum + o.completionTime);
    return (seconds / 60).round();
  }

  /// Levels ordered best first, so the strength areas are at the front and the
  /// focus areas at the back.
  List<LevelOutcome> get byScoreDescending {
    final sorted = [...outcomes];
    sorted.sort((a, b) => b.score01.compareTo(a.score01));
    return sorted;
  }

  /// Locale key for the band label matching [overallScorePercent].
  String get bandLabelKey {
    if (overallScorePercent >= 80) return LocaleKeys.functionalLevelHigh;
    if (overallScorePercent >= 60) return LocaleKeys.moderateFunctionalLevel;
    return LocaleKeys.functionalLevelNeedsFocus;
  }

  /// Locale key for the paragraph explaining [bandLabelKey].
  String get bandDescriptionKey {
    if (overallScorePercent >= 80) return LocaleKeys.functionalLevelHighDesc;
    if (overallScorePercent >= 60) {
      return LocaleKeys.moderateFunctionalLevelDesc;
    }
    return LocaleKeys.functionalLevelNeedsFocusDesc;
  }
}
