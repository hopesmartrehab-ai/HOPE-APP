import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';

class ApproachInfoCard extends StatelessWidget {
  final TrainingApproach? selectedApproach;

  const ApproachInfoCard({required this.selectedApproach, super.key});

  @override
  Widget build(BuildContext context) {
    if (selectedApproach == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Text(
          selectedApproach == TrainingApproach.smartGlove
              ? LocaleKeys.smartGloveInfo.tr()
              : LocaleKeys.mobileOnlyInfo.tr(),
          style: Styles.s14(
            context,
          ).copyWith(color: Colors.grey[600], height: 1.4),
        ),
      ),
    );
  }
}
