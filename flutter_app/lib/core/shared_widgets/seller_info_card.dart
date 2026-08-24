import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/shared_widgets/app_svg.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_text_title.dart';
import 'package:tara_car/core/shared_widgets/clicked_widget.dart';
import 'package:tara_car/core/shared_widgets/custom_network_image.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class SellerInfoCard extends StatelessWidget {
  final String name;
  final String image;
  final String joinDate;
  final bool isCompany;
  final String? location;
  final int? carStock;
  final bool? isProdcutScreen;
  final VoidCallback? onTap;

  const SellerInfoCard({
    required this.name,
    required this.image,
    required this.joinDate,
    this.isProdcutScreen = true,
    this.isCompany = false,
    this.location,
    this.onTap,
    this.carStock,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClickedWidget(
      onTap: () {
        isCompany ? onTap?.call() : null;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isProdcutScreen == true)
            CustomTextTitle(text: LocaleKeys.sellerInformation.tr()),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: context.lightLightestColor,
              border: Border.all(color: context.lightMediumColor, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 8,
                    top: 8,
                    bottom: 8,
                    end: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomNetworkImage(
                      imageUrl: image,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorWidget: SvgPicture.asset(Assets.assetsImagesNoImage),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 16),
                        child: Row(
                          children: [
                            Text(
                              name,
                              style: Styles.s14(context).copyWith(
                                color: context.darkMediumColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (isCompany)
                              Icon(
                                Icons.verified,
                                color: context.iconVerified,
                                size: 18,
                              )
                            else
                              Text(
                                LocaleKeys.personalAccount.tr(),
                                style: Styles.s12(
                                  context,
                                ).copyWith(color: context.darkLightColor),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildInfoItem(
                            context,
                            Assets.assetsIconsCalendarIconLight,
                            "${LocaleKeys.joinDate.tr()}: $joinDate",
                          ),
                          if (isCompany && carStock != null) ...[
                            const Spacer(flex: 2),
                            _buildInfoItem(
                              context,
                              Assets.assetsIconsCarStockIconLight,
                              "${LocaleKeys.carStock.tr()}: $carStock",
                            ),
                            const Spacer(flex: 1),
                          ],
                        ],
                      ),
                      if (isCompany && location != null) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 8),
                          child: _buildInfoItem(
                            context,
                            Assets.assetsIconsLocationIconLight,
                            location!,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String icon, String text) {
    return Row(
      children: [
        AppSvg(
          assetName: icon,
          darkColor: context.darkDarkColor,
          width: 14,
          height: 14,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Styles.s10(context).copyWith(color: context.darkMediumColor),
        ),
      ],
    );
  }
}
