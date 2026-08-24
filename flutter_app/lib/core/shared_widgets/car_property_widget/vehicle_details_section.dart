import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_filter_option.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_range_text_field.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_text_title.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class VehicleDetailsSection extends StatelessWidget {
  final String sectionNumber;
  const VehicleDetailsSection({required this.sectionNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(
          text: "$sectionNumber${LocaleKeys.vehicleDetails.tr()}",
          isSectionTitle: true,
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.bodyType.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomFilterOption(
              title: LocaleKeys.sedan.tr(),
              unselectedSvgIcon: Assets.assetsImagesSedanUnSelect,
              selectedSvgIcon: Assets.assetsImagesSedanSelected,
            ),
            CustomFilterOption(
              title: LocaleKeys.hatchback.tr(),
              unselectedSvgIcon: Assets.assetsImagesHatchbackUnSelect,
              selectedSvgIcon: Assets.assetsImagesHatchbackSelected,
            ),
            CustomFilterOption(
              title: LocaleKeys.coupe.tr(),
              unselectedSvgIcon: Assets.assetsImagesCoupeUnSelect,
              selectedSvgIcon: Assets.assetsImagesCoupeSelected,
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.modelYearRange.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomRangeTextField(
              label: LocaleKeys.from.tr(),
              borderColor: context.lightDarkColor,
            ),
            CustomRangeTextField(
              label: LocaleKeys.to.tr(),
              borderColor: context.lightDarkColor,
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.transmission.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomFilterOption(title: LocaleKeys.all.tr()),
            CustomFilterOption(
              title: LocaleKeys.manual.tr(),
              unselectedSvgIcon: Assets.assetsIconsManualIconLight,
              // selectedSvgIcon: Assets.assetsIconsManualIconDark,
            ),
            CustomFilterOption(
              title: LocaleKeys.automatic.tr(),
              unselectedSvgIcon: Assets.assetsIconsAutomaticIconLight,
              // selectedSvgIcon: Assets.assetsIconsAutomaticIconDark,
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.kilometersRange.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomRangeTextField(
              label: LocaleKeys.from.tr(),
              borderColor: context.lightDarkColor,
              suffixText: LocaleKeys.km.tr(),
            ),
            CustomRangeTextField(
              label: LocaleKeys.to.tr(),
              borderColor: context.lightDarkColor,
              suffixText: LocaleKeys.km.tr(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.fuelType.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomFilterOption(title: LocaleKeys.gasoline.tr()),
            CustomFilterOption(title: LocaleKeys.hybrid.tr()),
            CustomFilterOption(title: LocaleKeys.diesel.tr()),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.engineCapacity.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomFilterOption(title: LocaleKeys.from800To1300.tr()),
            CustomFilterOption(title: LocaleKeys.from1300To1500.tr()),
            CustomFilterOption(title: LocaleKeys.from1500To2000.tr()),
          ],
        ),
      ],
    );
  }
}
