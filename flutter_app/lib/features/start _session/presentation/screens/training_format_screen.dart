import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/start%20_session/presentation/screens/training_setup_screen.dart';

enum TrainingFormatType { game, video }

class TrainingFormatScreen extends StatefulWidget {
  final TrainingApproach selectedApproach;
  const TrainingFormatScreen({required this.selectedApproach, super.key});

  @override
  State<TrainingFormatScreen> createState() => _TrainingFormatScreenState();
}

class _TrainingFormatScreenState extends State<TrainingFormatScreen> {
  TrainingFormatType? _selectedFormat;

  @override
  Widget build(BuildContext context) {
    final bool isGlove = widget.selectedApproach == TrainingApproach.smartGlove;
    final String iconEmoji = isGlove ? '🧤' : '📱';
    final String deviceName = isGlove
        ? 'HOPE Smart Glove'
        : LocaleKeys.mobileDevice.tr();
    final String deviceStatus = isGlove
        ? 'Connected • 87% battery'
        : LocaleKeys.mobileDeviceDesc.tr();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 90,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: Color(0xFF1E3A5F),
          ),
          label: Text(
            'Back',
            style: Styles.s16(context).copyWith(color: const Color(0xFF1E3A5F)),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.trainingFormat.tr(),
                    style: Styles.s12(context).copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.chooseTrainingFormat.tr(),
                    style: Styles.s26(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.chooseTrainingFormatDesc.tr(),
                    style: Styles.s14(
                      context,
                    ).copyWith(color: Colors.grey[600], height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // كارت اللعبة
                  _FormatCard(
                    title: LocaleKeys.playGame.tr(),
                    description: LocaleKeys.playGameDesc.tr(),
                    iconEmoji: '🎮',
                    isSelected: _selectedFormat == TrainingFormatType.game,
                    onTap: () => setState(
                      () => _selectedFormat = TrainingFormatType.game,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // كارت الفيديو
                  _FormatCard(
                    title: LocaleKeys.followVideoExercise.tr(),
                    description: LocaleKeys.followVideoDesc.tr(),
                    iconEmoji: '▶️',
                    isSelected: _selectedFormat == TrainingFormatType.video,
                    onTap: () => setState(
                      () => _selectedFormat = TrainingFormatType.video,
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Fixed Device Info Card (Now Dynamic)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.trainingWith.tr(),
                          style: Styles.s12(
                            context,
                          ).copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F4F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                iconEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deviceName,
                                  style: Styles.s14(context).copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  deviceStatus,
                                  style: Styles.s12(
                                    context,
                                  ).copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // الزرار السفلي
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4F8),
              border: Border(
                top: BorderSide(color: Colors.black12, width: 0.5),
              ),
            ),
            child: CustomButton(
              title: 'Continue',
              isLoading: false,
              backgroundColor: _selectedFormat != null
                  ? const Color(0xFF4ADE80)
                  : Colors.grey[300],
              foregroundColor: _selectedFormat != null
                  ? Colors.white
                  : Colors.grey[500],
              borderRadius: 16.0,
              onPressed: _selectedFormat != null
                  ? () {
                      // Navigate to actual game/video session
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconEmoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatCard({
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(iconEmoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Styles.s16(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Styles.s12(
                      context,
                    ).copyWith(color: Colors.grey[600], height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
