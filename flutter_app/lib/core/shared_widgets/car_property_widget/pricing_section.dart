import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_filter_option.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_range_text_field.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_text_title.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class PricingSection extends StatelessWidget {
  final String sectionNumber;
  const PricingSection({required this.sectionNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(
          text: "$sectionNumber${LocaleKeys.pricingHeader.tr()}",
          isSectionTitle: true,
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.priceRange.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomRangeTextField(
              label: LocaleKeys.minimum.tr(),
              borderColor: context.lightDarkColor,
              suffixText: LocaleKeys.egp.tr(),
            ),
            CustomRangeTextField(
              label: LocaleKeys.maximum.tr(),
              borderColor: context.lightDarkColor,
              suffixText: LocaleKeys.egp.tr(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.paymentType.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            CustomFilterOption(title: LocaleKeys.cash.tr()),
            CustomFilterOption(title: LocaleKeys.installments.tr()),
          ],
        ),
      ],
    );
  }
}
