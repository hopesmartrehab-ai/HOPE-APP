import 'package:flutter/material.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CustomTextTitle extends StatelessWidget {
  const CustomTextTitle({
    required this.text,
    this.isSectionTitle = false,
    super.key,
  });
  final String text;
  final bool isSectionTitle;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: isSectionTitle
          ? Styles.s16(context).copyWith(
              color: context.darkDarkColor,
              fontWeight: FontWeight.w700,
            )
          : Styles.s14(context).copyWith(
              color: context.darkMediumColor,
              fontWeight: FontWeight.w700,
            ),
    );
  }
}
