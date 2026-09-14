import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/home/presentation/model/home_models.dart';

class YourPathCard extends StatelessWidget {
  final PathModel pathData;

  const YourPathCard({required this.pathData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 0.1, color: Colors.grey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.laptop_chromebook,
              color: Color(0xFF234468),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.yourPath.tr(),
                  style: Styles.s11(context).copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pathData.pathName,
                  style: Styles.s14(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  LocaleKeys.nextFollowUp.tr(args: [pathData.nextFollowUpDate]),
                  style: Styles.s12(context).copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            LocaleKeys.weekOf.tr(
              args: [
                pathData.currentWeek.toString(),
                pathData.totalWeeks.toString(),
              ],
            ),
            textAlign: TextAlign.center,
            style: Styles.s14(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
