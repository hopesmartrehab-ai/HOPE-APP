import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/home/presentation/model/home_models.dart';

class TodaySessionCard extends StatelessWidget {
  final TodaySessionModel sessionData;

  const TodaySessionCard({required this.sessionData, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.todaysSession.tr(),
          style: Styles.s18(
            context,
          ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      LocaleKeys.dayOf.tr(
                        args: [
                          sessionData.currentDay.toString(),
                          sessionData.totalDays.toString(),
                        ],
                      ),
                      style: Styles.s12(context).copyWith(color: Colors.green),
                    ),
                  ),
                  const Text('👋', style: TextStyle(fontSize: 24)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                sessionData.title,
                style: Styles.s20(
                  context,
                ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.focus.tr(args: [sessionData.focus]),
                style: Styles.s14(
                  context,
                ).copyWith(color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _SessionStatBox(
                    icon: '💪',
                    value: sessionData.exercisesCount.toString(),
                    label: LocaleKeys.exercises.tr(),
                  ),
                  const SizedBox(width: 8),
                  _SessionStatBox(
                    icon: '⏱️',
                    value: '${sessionData.durationMinutes} min',
                    label: LocaleKeys.duration.tr(),
                  ),
                  const SizedBox(width: 8),
                  _SessionStatBox(
                    icon: '🔥',
                    value: '${sessionData.streakDays} day',
                    label: LocaleKeys.streak.tr(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                title: LocaleKeys.startSession.tr(),
                isLoading: false,
                backgroundColor: const Color(0xFF4ADE80),
                foregroundColor: Colors.white,
                borderRadius: 16.0,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SessionStatBox extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _SessionStatBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              value,
              style: Styles.s16(
                context,
              ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Styles.s11(context).copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
