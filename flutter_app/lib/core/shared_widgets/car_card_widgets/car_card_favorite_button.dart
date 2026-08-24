import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/shared_widgets/clicked_widget.dart';

class CarCardFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const CarCardFavoriteButton({
    required this.isFavorite,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClickedWidget(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: isFavorite
              ? SvgPicture.asset(Assets.assetsIconsLikeIcon)
              : SvgPicture.asset(Assets.assetsIconsUnlikeIcon),
        ),
      ),
    );
  }
}
