import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/shared_widgets/app_svg.dart';
import 'package:tara_car/core/shared_widgets/clicked_widget.dart';
import 'package:tara_car/core/shared_widgets/custom_radio_button.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';
import 'package:tara_car/core/utils/app_route.dart';
import 'package:easy_localization/easy_localization.dart';

class SortSheetContent extends StatefulWidget {
  final List<String> items;
  final int initialIndex;
  final ValueChanged<int> onSelected;

  const SortSheetContent({
    required this.items,
    required this.initialIndex,
    required this.onSelected,
    super.key,
  });

  @override
  State<SortSheetContent> createState() => _SortSheetContentState();
}

class _SortSheetContentState extends State<SortSheetContent> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 4),
            Text(
              LocaleKeys.sortBy.tr(),
              style: Styles.s14(context).copyWith(
                color: context.darkDarkColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: ClickedWidget(
                onTap: () => AppRoute.goBack(context: context),
                child: AppSvg(
                  darkColor: context.darkDarkColor,
                  assetName: Assets.assetsIconsCloseIconLight,
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return ListTile(
              visualDensity: const VisualDensity(vertical: -2),
              contentPadding: EdgeInsets.zero,
              title: Text(
                widget.items[index],
                style: Styles.s12(context).copyWith(
                  color: context.darkDarkColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: CustomRadioButton(
                isSelected: _selectedIndex == index,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onSelected(index);
                  AppRoute.goBack(context: context);
                },
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onSelected(index);
               AppRoute.goBack(context: context);
              },
            );
          },
        ),
      ],
    );
  }
}
