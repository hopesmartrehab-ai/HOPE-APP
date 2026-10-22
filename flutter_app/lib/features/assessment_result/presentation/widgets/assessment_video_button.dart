import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/features/assessment/presentation/screens/assessment_planet_flow_screen.dart';

class AssessmentVideoButton extends StatelessWidget {
  const AssessmentVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const AssessmentPlanetFlowScreen(),
        ),
      ),
      icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
      label: Text(LocaleKeys.assessmentPlayVideo.tr()),
    );
  }
}
