import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';

class DeviceConnectionInfoCard extends StatelessWidget {
  final TrainingApproach selectedApproach;

  const DeviceConnectionInfoCard({required this.selectedApproach, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isGlove = selectedApproach == TrainingApproach.smartGlove;
    final String iconEmoji = isGlove ? '🧤' : '📱';
    final String deviceName = isGlove
        ? 'HOPE Smart Glove'
        : LocaleKeys.mobileDevice.tr();
    final String deviceStatus = isGlove
        ? 'Connected • 87% battery'
        : LocaleKeys.mobileDeviceDesc.tr();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.trainingWith.tr(),
            style: Styles.s12(context).copyWith(color: Colors.grey[600]),
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
                child: Text(iconEmoji, style: const TextStyle(fontSize: 24)),
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
    );
  }
}
