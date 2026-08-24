import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope_app/core/theme/theme_extension.dart';

import '../theme/styles/app_text_styles.dart';

class CustomEmptyScreen extends StatelessWidget {
  const CustomEmptyScreen({
    required this.title,
    required this.subtitle,
    required this.image,
    super.key,
    this.imageHeight,
    this.imageWidth,
    this.imageColor,
    this.children,
  });
  final String title;
  final String subtitle;
  final String image;
  final double? imageHeight;
  final double? imageWidth;
  final Color? imageColor;
  final List<Widget>? children;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SvgPicture.asset(
              image,
              height: imageHeight,
              width: imageWidth,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Styles.s18(context).copyWith(
              color: context.darkDarkColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Styles.s14(context).copyWith(
              color: context.darkLightColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          ...?children,
        ],
      ),
    );
  }
}
