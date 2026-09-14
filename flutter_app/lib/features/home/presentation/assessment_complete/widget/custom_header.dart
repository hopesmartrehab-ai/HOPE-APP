import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/assets_constants.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final String name = "Ana G3an";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Transform.scale(
          scale: 2.5,
          child: const Image(
            image: AssetImage(Assets.assetsFlagsLogo),
            width: 32,
            height: 32,
          ),
        ),

        // Avatar Placeholder
        CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 20,
          child: Text(
            name.split('').toList().first,
            style: Styles.s20(context).copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
