import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/shared_widgets/clicked_widget.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class SortTriggerButton extends StatelessWidget {
  final VoidCallback onTap;
  const SortTriggerButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ClickedWidget(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            LocaleKeys.sortingBy.tr(),
            style: Styles.s12(context).copyWith(
              color: context.darkDarkestColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 20),
        ],
      ),
    );
  }
}
