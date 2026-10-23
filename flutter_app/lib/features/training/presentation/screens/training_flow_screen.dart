import 'package:flutter/material.dart';
import 'package:hope_app/features/training/data/models/training_result_model.dart';
import 'package:hope_app/features/training/presentation/screens/training_results_screen.dart';
import 'package:hope_app/features/training/presentation/widgets/all_levels_complete_page.dart';
import 'package:hope_app/features/training/presentation/widgets/training_level_page.dart';

class TrainingFlowScreen extends StatefulWidget {
  const TrainingFlowScreen({this.onComplete, super.key});

  final VoidCallback? onComplete;

  @override
  State<TrainingFlowScreen> createState() => _TrainingFlowScreenState();
}

class _TrainingFlowScreenState extends State<TrainingFlowScreen> {
  var _currentLevel = 1;
  var _isComplete = false;
  var _showResults = false;

  void _completeLevel() {
    setState(() {
      if (_currentLevel < 5) {
        _currentLevel++;
      } else {
        _isComplete = true;
      }
    });
  }

  void _finishFlow() {
    final onComplete = widget.onComplete;
    if (onComplete != null) {
      onComplete();
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return TrainingResultsScreen(
        result: const TrainingResultModel(completedLevels: 5, totalLevels: 5),
        onFinish: _finishFlow,
      );
    }

    if (_isComplete) {
      return AllLevelsCompletePage(
        onContinue: () {
          final onComplete = widget.onComplete;
          if (onComplete != null) {
            onComplete();
          } else {
            setState(() => _showResults = true);
          }
        },
      );
    }

    return TrainingLevelPage(level: _currentLevel, onComplete: _completeLevel);
  }
}
