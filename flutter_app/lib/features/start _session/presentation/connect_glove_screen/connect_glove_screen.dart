import 'package:flutter/material.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_flow_screen.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';

class ConnectGloveScreen extends StatelessWidget {
  const ConnectGloveScreen({required this.selectedApproach, super.key});

  final TrainingApproach selectedApproach;

  @override
  Widget build(BuildContext context) {
    return StartSessionFlowScreen(
      initialPage: 1,
      initialApproach: selectedApproach,
    );
  }
}
