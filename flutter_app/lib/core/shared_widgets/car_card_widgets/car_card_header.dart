import 'package:flutter/material.dart';

import '../custom_network_image.dart';
import 'car_card_favorite_button.dart';
import 'car_card_premium_badge.dart';

class CarCardHeader extends StatelessWidget {
  final String imageUrl;
  final bool isPremium;
  final String? premiumLabel;
  final VoidCallback? onFavoriteChanged;
  final bool isFavorite;
  final VoidCallback toggleFavorite;

  const CarCardHeader({
    required this.imageUrl,
    required this.isFavorite,
    required this.toggleFavorite,
    this.isPremium = false,
    this.onFavoriteChanged,
    super.key,
    this.premiumLabel,

  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomNetworkImage(
          borderRadiusGeometry: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          height: 160,
          width: double.infinity,
          imageUrl: imageUrl,
        ),
        if (isPremium) CarCardPremiumBadge(premiumLabel: premiumLabel!),
        PositionedDirectional(
          bottom: 12,
          start: 12,
          child: CarCardFavoriteButton(
            isFavorite: isFavorite,
            onTap: toggleFavorite,
          ),
        ),
      ],
    );
  }
}
