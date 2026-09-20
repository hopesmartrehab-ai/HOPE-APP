import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/core/utils/app_route.dart';
import 'package:hope_app/features/start%20_session/presentation/screens/connect_glove_screen.dart';
import 'package:hope_app/features/start%20_session/presentation/screens/training_format_screen.dart';

enum TrainingApproach { smartGlove, mobileOnly }

class TrainingSetupScreen extends StatefulWidget {
  const TrainingSetupScreen({super.key});

  @override
  State<TrainingSetupScreen> createState() => _TrainingSetupScreenState();
}

class _TrainingSetupScreenState extends State<TrainingSetupScreen> {
  TrainingApproach? _selectedApproach;

  @override
  Widget build(BuildContext context) {
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
                    LocaleKeys.trainingSetup.tr(),
                    style: Styles.s12(context).copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.howWouldYouLikeToTrain.tr(),
                    style: Styles.s26(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.choosePreferredTraining.tr(),
                    style: Styles.s14(
                      context,
                    ).copyWith(color: Colors.grey[600], height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // كارت القفاز الذكي
                  _SelectionCard(
                    title: LocaleKeys.useSmartGlove.tr(),
                    description: LocaleKeys.useSmartGloveDesc.tr(),
                    iconEmoji: '🧤', // استبدلها بصورة القفاز من Assets
                    isSelected:
                        _selectedApproach == TrainingApproach.smartGlove,
                    onTap: () => setState(
                      () => _selectedApproach = TrainingApproach.smartGlove,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // كارت الموبايل
                  _SelectionCard(
                    title: LocaleKeys.mobileOnly.tr(),
                    description: LocaleKeys.mobileOnlyDesc.tr(),
                    iconEmoji: '📱',
                    isSelected:
                        _selectedApproach == TrainingApproach.mobileOnly,
                    onTap: () => setState(
                      () => _selectedApproach = TrainingApproach.mobileOnly,
                    ),
                  ),

                  // رسالة التوضيح (تظهر فقط عند اختيار القفاز أو الموبايل)
                  if (_selectedApproach != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _selectedApproach == TrainingApproach.smartGlove
                            ? LocaleKeys.smartGloveInfo.tr()
                            : LocaleKeys.mobileOnlyInfo.tr(),
                        style: Styles.s14(
                          context,
                        ).copyWith(color: Colors.grey[600], height: 1.4),
                      ),
                    ),
                  ],
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
              backgroundColor: _selectedApproach != null
                  ? const Color(0xFF4ADE80)
                  : Colors.grey[300],
              foregroundColor: _selectedApproach != null
                  ? Colors.white
                  : Colors.grey[500],
              borderRadius: 16.0,
              onPressed: _selectedApproach != null
                  ? () {
                      if (_selectedApproach == TrainingApproach.smartGlove) {
                        AppRoute.goToConnectGlove(
                          context: context,
                          selectedApproach: _selectedApproach!,
                        );
                      } else {
                        AppRoute.goToTrainingFormat(
                          context: context,
                          selectedApproach: _selectedApproach!,
                        );
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconEmoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
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
          color: isSelected ? const Color(0xFFE6F4EA) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.green
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1.0,
          ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Styles.s16(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
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
