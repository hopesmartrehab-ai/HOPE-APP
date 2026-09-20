import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';
import 'package:hope_app/features/start%20_session/presentation/training_format_screen/widgets/device_connection_info_card.dart';
import 'package:hope_app/features/start%20_session/presentation/training_format_screen/widgets/format_selection_card.dart';
import 'package:hope_app/features/start%20_session/presentation/training_format_screen/widgets/training_format_header.dart';

class TrainingFormatView extends StatelessWidget {
  const TrainingFormatView({
    required this.selectedApproach,
    required this.selectedFormat,
    required this.onFormatSelected,
    super.key,
  });

  final TrainingApproach selectedApproach;
  final TrainingFormatType? selectedFormat;
  final ValueChanged<TrainingFormatType> onFormatSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TrainingFormatHeader(),
            const SizedBox(height: 24),
            FormatSelectionCard(
              title: LocaleKeys.playGame.tr(),
              description: LocaleKeys.playGameDesc.tr(),
              iconEmoji: '🎮',
              isSelected: selectedFormat == TrainingFormatType.game,
              onTap: () => onFormatSelected(TrainingFormatType.game),
            ),
            const SizedBox(height: 16),
            FormatSelectionCard(
              title: LocaleKeys.followVideoExercise.tr(),
              description: LocaleKeys.followVideoDesc.tr(),
              iconEmoji: '▶️',
              isSelected: selectedFormat == TrainingFormatType.video,
              onTap: () => onFormatSelected(TrainingFormatType.video),
            ),
            const SizedBox(height: 24),
            DeviceConnectionInfoCard(selectedApproach: selectedApproach),
          ],
        ),
      ),
    );
  }
}
