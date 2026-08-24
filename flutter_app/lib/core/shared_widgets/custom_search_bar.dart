import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/shared_widgets/app_svg.dart';
import 'package:tara_car/core/shared_widgets/clicked_widget.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CustomSearchBar extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool isAdvancedSearch;
  const CustomSearchBar({
    required this.isAdvancedSearch,
    required this.title,
    required this.onPressed,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            controller: controller,
            elevation: const WidgetStatePropertyAll(0),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            leading: SvgPicture.asset(
              Assets.assetsIconsInactiveSearchIcon,
              height: 16,
              width: 16,
            ),
            constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
            side: WidgetStatePropertyAll(
              BorderSide(color: context.lightMediumColor, width: 1),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),

            textStyle: WidgetStatePropertyAll(
              Styles.s12(context).copyWith(color: context.darkMediumColor),
            ),
            hintText: title,
            hintStyle: WidgetStatePropertyAll(
              Styles.s12(context).copyWith(color: context.darkLightColor),
            ),
          ),
        ),
        if (isAdvancedSearch) const SizedBox(width: 8),
        if (isAdvancedSearch)
          ClickedWidget(
            onTap: onPressed,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: context.naturalLightLightColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.lightMediumColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppSvg(
                  darkColor: context.darkDarkColor,
                  assetName: Assets.assetsIconsSearchSettingIconLight,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
