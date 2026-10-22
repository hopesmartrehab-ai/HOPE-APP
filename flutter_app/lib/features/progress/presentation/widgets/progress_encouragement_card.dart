import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class ProgressEncouragementCard extends StatelessWidget {
  const ProgressEncouragementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC7E6D3)),
      ),
      child: Text(
        LocaleKeys.progressEncouragement.tr(),
        style: Styles.s12(context).copyWith(
          color: const Color(0xFF334E3F),
          height: 1.45,
        ),
      ),
    );
  }
}
