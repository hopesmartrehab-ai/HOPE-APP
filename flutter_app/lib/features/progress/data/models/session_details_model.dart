import 'package:hope_app/features/progress/data/models/exercise_item_model.dart';
import 'package:hope_app/features/progress/data/models/therapist_note_model.dart';

class SessionDetailsModel {
  const SessionDetailsModel({
    required this.id,
    required this.completedExercises,
    required this.totalExercises,
    required this.durationMinutes,
    required this.performanceScore,
    required this.exercises,
    required this.therapistNote,
  });

  final String id;
  final int completedExercises;
  final int totalExercises;
  final int durationMinutes;
  final double performanceScore;
  final List<ExerciseItemModel> exercises;
  final TherapistNoteModel therapistNote;

  factory SessionDetailsModel.fromJson(Map<String, dynamic> json) {
    return SessionDetailsModel(
      id: json['id'] as String,
      completedExercises: (json['completedExercises'] as num).toInt(),
      totalExercises: (json['totalExercises'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      performanceScore: (json['performanceScore'] as num).toDouble(),
      exercises: (json['exercises'] as List<dynamic>)
          .map(
            (item) => ExerciseItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      therapistNote: TherapistNoteModel.fromJson(
        json['therapistNote'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'completedExercises': completedExercises,
    'totalExercises': totalExercises,
    'durationMinutes': durationMinutes,
    'performanceScore': performanceScore,
    'exercises': exercises.map((item) => item.toJson()).toList(),
    'therapistNote': therapistNote.toJson(),
  };
}
