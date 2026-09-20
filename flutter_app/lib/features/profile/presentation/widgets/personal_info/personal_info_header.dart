import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class PersonalInfoHeader extends StatelessWidget {
  const PersonalInfoHeader({this.onBack, this.onEdit, super.key});

  final VoidCallback? onBack;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          LocaleKeys.profile.tr(),
          style: Styles.s16(
            context,
          ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class PersonalInfoTitleRow extends StatelessWidget {
  const PersonalInfoTitleRow({this.onEdit, super.key});

  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            LocaleKeys.personalInformation.tr(),
            style: Styles.s28(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Text(
            LocaleKeys.edit.tr(),
            style: Styles.s16(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
