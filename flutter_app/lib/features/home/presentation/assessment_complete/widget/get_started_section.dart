import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class GetStartedSection extends StatelessWidget {
  const GetStartedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.getStarted.tr(),
          style: Styles.s18(
            context,
          ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 0.1, color: Colors.grey),
            // boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1)],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.assignment_outlined, color: Colors.brown),
            ),
            title: Text(
              LocaleKeys.viewAssessmentReport.tr(),
              style: Styles.s16(context).copyWith(
                color: AppColors.appBarBg,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              LocaleKeys.detailedPerformanceBreakdown.tr(),
              style: Styles.s12(
                context,
              ).copyWith(color: Colors.grey, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // TODO: Navigate to report
            },
          ),
        ),
      ],
    );
  }
}
