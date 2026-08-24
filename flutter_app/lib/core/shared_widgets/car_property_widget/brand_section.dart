import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_filter_option.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_text_title.dart';
import 'package:tara_car/core/utils/app_route.dart';
import 'package:tara_car/feature/search_module/advanced_search/presentation/widgets/custom_dotted_border.dart';

class BrandSection extends StatelessWidget {
  final String? sectionNumber;
  const BrandSection({this.sectionNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(
          text: sectionNumber != null
              ? "$sectionNumber${LocaleKeys.brandAndModel.tr()}"
              : LocaleKeys.brandAndModel.tr(),
          isSectionTitle: true,
        ),
        const SizedBox(height: 24),
        CustomDottedBorder(
          onPressed: () {
            AppRoute.goToSelectBrandScreen(context: context);
          },
        ),
        const SizedBox(height: 24),
        CustomTextTitle(text: LocaleKeys.condition.tr()),
        const SizedBox(height: 12),
        Row(
          spacing: 12,
          children: [
            //add empty space for post ad screen
            if (sectionNumber != null)
              CustomFilterOption(title: LocaleKeys.all.tr()),

            CustomFilterOption(title: LocaleKeys.newCar.tr()),
            CustomFilterOption(title: LocaleKeys.used.tr()),
            if (sectionNumber == null) const Spacer(),
          ],
        ),
      ],
    );
  }
}
