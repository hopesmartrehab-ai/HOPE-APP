import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/rehab/data/models/rehab_models.dart';

class RehabOverviewCard extends StatelessWidget {
  final RehabSessionModel session;

  const RehabOverviewCard({required this.session, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0.1, color: Colors.grey),
      ),
      child: Row(
        children: [
          _OverviewItem(
            icon: '💪',
            value: session.exercisesCount.toString(),
            label: LocaleKeys.exercises.tr(),
          ),
          _OverviewItem(
            icon: '⏱️',
            value: '~${session.estDurationMin} min',
            label: LocaleKeys.estDuration.tr(),
          ),
          _OverviewItem(
            icon: '🎯',
            value: session.focusArea,
            label: LocaleKeys.focus.tr(),
          ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _OverviewItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Styles.s16(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Styles.s11(context).copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
