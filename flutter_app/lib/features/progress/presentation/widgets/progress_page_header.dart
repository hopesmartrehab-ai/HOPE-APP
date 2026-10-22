import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class ProgressPageHeader extends StatelessWidget {
  const ProgressPageHeader({
    required this.title,
    this.subtitle,
    this.backLabel,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? backLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (backLabel != null)
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            label: Text(
              backLabel!.tr(),
              style: Styles.s14(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        if (backLabel != null) const SizedBox(height: 8),
        Text(
          title.tr(),
          style: Styles.s24(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!.tr(),
            style: Styles.s14(context).copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}
