import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';
import 'package:hope_app/features/start%20_session/presentation/training_setup/widgets/approach_info_card.dart';
import 'package:hope_app/features/start%20_session/presentation/training_setup/widgets/selection_card.dart';
import 'package:hope_app/features/start%20_session/presentation/training_setup/widgets/training_setup_header.dart';

class TrainingSetupView extends StatelessWidget {
  const TrainingSetupView({
    required this.selectedApproach,
    required this.onApproachSelected,
    super.key,
  });

  final TrainingApproach? selectedApproach;
  final ValueChanged<TrainingApproach> onApproachSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TrainingSetupHeader(),
            const SizedBox(height: 24),
            SelectionCard(
              title: LocaleKeys.useSmartGlove.tr(),
              description: LocaleKeys.useSmartGloveDesc.tr(),
              iconEmoji: '🧤',
              isSelected: selectedApproach == TrainingApproach.smartGlove,
              onTap: () => onApproachSelected(TrainingApproach.smartGlove),
            ),
            const SizedBox(height: 16),
            SelectionCard(
              title: LocaleKeys.mobileOnly.tr(),
              description: LocaleKeys.mobileOnlyDesc.tr(),
              iconEmoji: '📱',
              isSelected: selectedApproach == TrainingApproach.mobileOnly,
              onTap: () => onApproachSelected(TrainingApproach.mobileOnly),
            ),
            ApproachInfoCard(selectedApproach: selectedApproach),
          ],
        ),
      ),
    );
  }
}
