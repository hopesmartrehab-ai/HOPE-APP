import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/shared_widgets/app_svg.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CarCardLocation extends StatelessWidget {
  final String location;

  const CarCardLocation({required this.location, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSvg(
          assetName: Assets.assetsIconsLocationIconLight,
          darkColor: context.darkDarkColor,
        ),
        const SizedBox(width: 2),
        Text(
          location,
          style: Styles.s12(context).copyWith(color: context.darkMediumColor),
        ),
      ],
    );
  }
}
