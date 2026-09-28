import '../../../../core/constants/locale_keys.dart';

/// One level's result inside an assessment session.
class LevelOutcome {
  const LevelOutcome({
    required this.levelKey,
    required this.score01,
    required this.accuracy,
    required this.averageReactionTime,
    required this.missRate,
    required this.completionTime,
    required this.passed,
    required this.attempts,
    required this.successes,
  });

  /// Server identifier, e.g. `Level1`.
  final String levelKey;

  /// Normalised score, 0..1.
  final double score01;

  /// Fraction of successful attempts, 0..1.
  final double accuracy;

  /// Average reaction time in seconds. The server sends `0` when it has no
  /// reaction-time data for the level.
  final double averageReactionTime;

  /// Fraction of missed attempts, 0..1.
  final double missRate;

  /// Time taken to complete the level, in seconds.
  final double completionTime;

  final bool passed;
  final int attempts;
  final int successes;

  /// `Level1` -> `1`. `0` when the key carries no number.
  int get levelNumber {
    final digits = RegExp(r'\d+').firstMatch(levelKey)?.group(0);
    if (digits == null) return 0;
    return int.tryParse(digits) ?? 0;
  }

  int get scorePercent => _toPercent(score01);
  int get accuracyPercent => _toPercent(accuracy);
  int get missRatePercent => _toPercent(missRate);

  /// Locale key naming this level, or `null` when the server sends a level
  /// number this build has no name for.
  String? get titleKey {
    switch (levelNumber) {
      case 1:
        return LocaleKeys.levelTitleReachGrasp;
      case 2:
        return LocaleKeys.levelTitleGripStrength;
      case 3:
        return LocaleKeys.levelTitleCoordination;
      case 4:
        return LocaleKeys.levelTitleManipulation;
      case 5:
        return LocaleKeys.levelTitleReleaseControl;
      default:
        return null;
    }
  }

  static int _toPercent(double value) =>
      (value * 100).round().clamp(0, 100).toInt();
}
