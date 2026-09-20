import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/utils/app_route.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';

class TrainingSetupBottomBar extends StatelessWidget {
  final TrainingApproach? selectedApproach;

  const TrainingSetupBottomBar({required this.selectedApproach, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F4F8),
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: CustomButton(
        title: 'Continue',
        isLoading: false,
        backgroundColor: selectedApproach != null
            ? const Color(0xFF4ADE80)
            : Colors.grey[300],
        foregroundColor: selectedApproach != null
            ? Colors.white
            : Colors.grey[500],
        borderRadius: 16.0,
        onPressed: selectedApproach != null
            ? () {
                if (selectedApproach == TrainingApproach.smartGlove) {
                  AppRoute.goToConnectGlove(
                    context: context,
                    selectedApproach: selectedApproach!,
                  );
                } else {
                  AppRoute.goToTrainingFormat(
                    context: context,
                    selectedApproach: selectedApproach!,
                  );
                }
              }
            : null,
      ),
    );
  }
}
