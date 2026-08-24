import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_car/core/shared_widgets/custom_network_image.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({required this.brand, super.key});
  final Map<String, String> brand;
  @override
  Widget build(BuildContext context) {
    final String name = brand['name'] ?? '';
    final String count = brand['count'] ?? '';
    final bool hasCount = count.trim().isNotEmpty;
    final bool isAsset = brand['logo']?.startsWith('assets/') ?? false;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.lightMediumColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: isAsset
                  ? EdgeInsets.zero
                  : EdgeInsetsDirectional.only(
                      top: hasCount ? 8.0 : 12.0,
                      bottom: hasCount ? 8.0 : 8,
                      start: hasCount ? 8.0 : 12.0,
                      end: hasCount ? 8.0 : 12.0,
                    ),
              child: isAsset
                  ? SvgPicture.asset(
                      width: 1000,
                      height: 1000,
                      brand['logo'] ?? '',
                      fit: BoxFit.contain,
                    )
                  : CustomNetworkImage(
                      imageUrl: brand['logo'] ?? '',
                      width: hasCount ? 40 : 48,
                      height: hasCount ? 40 : 48,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          Text(
            hasCount ? '$name ($count)' : name,
            style: Styles.s10(context).copyWith(
              color: context.darkMediumColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
