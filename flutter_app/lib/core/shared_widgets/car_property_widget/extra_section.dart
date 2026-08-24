import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_filter_option.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_text_title.dart';

class ExtraSection extends StatelessWidget {
  final String? sectionNumber;
  const ExtraSection({this.sectionNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(
          text: "$sectionNumber${LocaleKeys.extrasHeader.tr()}",
          isSectionTitle: true,
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.sellerType.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomFilterOption(title: LocaleKeys.all.tr()),
            CustomFilterOption(title: LocaleKeys.owner.tr()),
            CustomFilterOption(title: LocaleKeys.showroom.tr()),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.features.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomFilterOption(title: LocaleKeys.sunroof.tr()),
            CustomFilterOption(title: LocaleKeys.leatherSeats.tr()),
            CustomFilterOption(title: LocaleKeys.rearCamera.tr()),
          ],
        ),
      ],
    );
  }
}
