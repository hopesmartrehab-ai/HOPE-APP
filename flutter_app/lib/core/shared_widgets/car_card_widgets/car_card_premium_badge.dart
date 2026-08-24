import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CarCardPremiumBadge extends StatelessWidget {
  final String premiumLabel;

  const CarCardPremiumBadge({required this.premiumLabel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8, start: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(Assets.assetsIconsStarIcon),
                const SizedBox(width: 4),
                Text(
                  premiumLabel,
                  style: Styles.s12(
                    context,
                  ).copyWith(color: context.premiumColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
