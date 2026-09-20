import 'package:flutter/material.dart';

class RehabSessionModel {
  final String title;
  final int exercisesCount;
  final int estDurationMin;
  final String focusArea;
  final List<ExerciseModel> exercises;
  final String tipText;

  const RehabSessionModel({
    required this.title,
    required this.exercisesCount,
    required this.estDurationMin,
    required this.focusArea,
    required this.exercises,
    required this.tipText,
  });
}

class ExerciseModel {
  final String id;
  final String title;
  final int durationMin;
  final ExerciseDifficulty difficulty;
  final IconData icon;

  const ExerciseModel({
    required this.id,
    required this.title,
    required this.durationMin,
    required this.difficulty,
    required this.icon,
  });
}

enum ExerciseDifficulty { easy, medium, hard }
