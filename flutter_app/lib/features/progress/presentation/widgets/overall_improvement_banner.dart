import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class OverallImprovementBanner extends StatelessWidget {
  const OverallImprovementBanner({required this.delta, super.key});

  final double delta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2EFE7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '${delta >= 0 ? '+' : ''}${(delta * 100).round()}%',
            style: Styles.s24(context).copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E8555),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.progressOverallImprovement.tr(),
            style: Styles.s12(context).copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E8555),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            LocaleKeys.progressProgramPeriod.tr(),
            style: Styles.s10(context).copyWith(
              color: const Color(0xFF5E8570),
            ),
          ),
        ],
      ),
    );
  }
}
