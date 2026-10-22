class MetricItemModel {
  const MetricItemModel({
    required this.title,
    required this.trend,
    required this.value,
  });

  final String title;
  final String trend;
  final String value;

  factory MetricItemModel.fromJson(Map<String, dynamic> json) {
    return MetricItemModel(
      title: json['title'] as String,
      trend: json['trend'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'trend': trend,
    'value': value,
  };
}
