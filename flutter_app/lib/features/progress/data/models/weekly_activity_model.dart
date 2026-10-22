class WeeklyActivityModel {
  const WeeklyActivityModel({
    required this.day,
    required this.value,
    required this.isCurrentDay,
  });

  final String day;
  final double value;
  final bool isCurrentDay;

  factory WeeklyActivityModel.fromJson(Map<String, dynamic> json) {
    return WeeklyActivityModel(
      day: json['day'] as String,
      value: (json['value'] as num).toDouble(),
      isCurrentDay: json['isCurrentDay'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'value': value,
    'isCurrentDay': isCurrentDay,
  };
}
