enum ExerciseRating { good, excellent }

class ExerciseItemModel {
  const ExerciseItemModel({
    required this.name,
    required this.device,
    required this.duration,
    required this.rating,
  });

  final String name;
  final String device;
  final String duration;
  final ExerciseRating rating;

  factory ExerciseItemModel.fromJson(Map<String, dynamic> json) {
    return ExerciseItemModel(
      name: json['name'] as String,
      device: json['device'] as String,
      duration: json['duration'] as String,
      rating: ExerciseRating.values.byName(json['rating'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'device': device,
    'duration': duration,
    'rating': rating.name,
  };
}
