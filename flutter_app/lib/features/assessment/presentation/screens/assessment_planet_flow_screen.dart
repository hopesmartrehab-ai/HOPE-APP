import 'package:flutter/material.dart';
import 'package:hope_app/features/assessment/presentation/widgets/analyzing_performance_page.dart';
import 'package:hope_app/features/assessment/presentation/widgets/planet_intro_page.dart';
import 'package:hope_app/features/training/presentation/screens/training_flow_screen.dart';

class AssessmentPlanetFlowScreen extends StatefulWidget {
  const AssessmentPlanetFlowScreen({super.key});

  @override
  State<AssessmentPlanetFlowScreen> createState() =>
      _AssessmentPlanetFlowScreenState();
}

class _AssessmentPlanetFlowScreenState
    extends State<AssessmentPlanetFlowScreen> {
  var _currentStep = 0;

  void _startTraining() {
    setState(() => _currentStep = 1);
  }

  void _finishTraining() {
    setState(() => _currentStep = 2);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return PlanetIntroPage(onContinue: _startTraining);
      case 1:
        return TrainingFlowScreen(onComplete: _finishTraining);
      default:
        return const AnalyzingPerformancePage();
    }
  }
}
