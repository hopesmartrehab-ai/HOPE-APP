import 'package:flutter/material.dart';
import 'package:tara_car/core/shared_widgets/app_svg.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CarCardSpecItem extends StatelessWidget {
  final String iconPath;
  final String text;

  const CarCardSpecItem({
    required this.iconPath,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSvg(
          assetName: iconPath,
          width: 16,
          height: 16,
          darkColor: context.darkMediumColor,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Styles.s12(context).copyWith(color: context.darkDarkestColor),
        ),
      ],
    );
  }
}
