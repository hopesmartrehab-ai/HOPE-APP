class AssessmentModel {
  const AssessmentModel({
    required this.id,
    required this.code,
    required this.title,
    required this.date,
    required this.location,
    required this.durationMinutes,
    required this.score,
    required this.potential,
    required this.path,
  });

  final String id;
  final String code;
  final String title;
  final String date;
  final String location;
  final int durationMinutes;
  final double score;
  final double potential;
  final String path;

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      location: json['location'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      score: (json['score'] as num).toDouble(),
      potential: (json['potential'] as num).toDouble(),
      path: json['path'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'title': title,
    'date': date,
    'location': location,
    'durationMinutes': durationMinutes,
    'score': score,
    'potential': potential,
    'path': path,
  };
}
