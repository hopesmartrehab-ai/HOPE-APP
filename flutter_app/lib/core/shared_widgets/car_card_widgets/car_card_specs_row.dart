import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

import 'car_card_spec_item.dart';

class CarCardSpecsRow extends StatelessWidget {
  final String mileage;
  final String transmission;
  final String year;

  const CarCardSpecsRow({
    required this.mileage,
    required this.transmission,
    required this.year,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      children: [
        CarCardSpecItem(iconPath: Assets.assetsIconsKmIconLight, text: mileage),
        SizedBox(
          height: 12,
          child: VerticalDivider(
            color: context.lightDarkColor,
            thickness: 1,
            width: 8,
          ),
        ),
        CarCardSpecItem(
          iconPath: Assets.assetsIconsAutomaticIconLight,
          text: transmission,
        ),
        SizedBox(
          height: 14,
          child: VerticalDivider(
            color: context.lightDarkColor,
            thickness: 1,
            width: 8,
          ),
        ),
        CarCardSpecItem(
          iconPath: Assets.assetsIconsCalendarIconLight,
          text: year,
        ),
      ],
    );
  }
}
