class AssessmentResult {
  final Map<String, String> functionResults;
  final List<String> neededTraining;

  const AssessmentResult({
    required this.functionResults,
    required this.neededTraining,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    const excludedKeys = {'needed_training'};
    final functionResults = <String, String>{};
    for (final entry in json.entries) {
      if (!excludedKeys.contains(entry.key)) {
        functionResults[entry.key] = entry.value as String;
      }
    }
    final neededTraining = (json['needed_training'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];
    return AssessmentResult(
      functionResults: functionResults,
      neededTraining: neededTraining,
    );
  }
}
