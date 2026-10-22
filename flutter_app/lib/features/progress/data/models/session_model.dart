enum SessionStatus { completed, partial }

class SessionModel {
  const SessionModel({
    required this.id,
    required this.dateLabel,
    required this.title,
    required this.subtitle,
    required this.durationMinutes,
    required this.status,
    this.isCurrent = false,
  });

  final String id;
  final String dateLabel;
  final String title;
  final String subtitle;
  final int durationMinutes;
  final SessionStatus status;
  final bool isCurrent;

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      dateLabel: json['dateLabel'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      status: SessionStatus.values.byName(json['status'] as String),
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateLabel': dateLabel,
    'title': title,
    'subtitle': subtitle,
    'durationMinutes': durationMinutes,
    'status': status.name,
    'isCurrent': isCurrent,
  };
}
