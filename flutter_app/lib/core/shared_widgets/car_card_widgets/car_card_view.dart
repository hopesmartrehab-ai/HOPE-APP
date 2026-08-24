import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tara_car/core/local_storage/local_storage.dart';
import 'package:tara_car/core/theme/theme_extension.dart';
import 'package:tara_car/feature/favorites/presentation/bloc/favorite_bloc.dart';

import 'car_card_body.dart';
import 'car_card_header.dart';

class CarCarView extends StatelessWidget {
  final String imageUrl;
  final bool isPremium;
  final String? premiumLabel;
  final String price;
  final String carName;
  final String carId;
  final String dealerName;
  final String mileage;
  final String transmission;
  final String year;
  final String location;
  final bool isHorizontal;

  const CarCarView({
    required this.carId,
    required this.isHorizontal,
    required this.price,
    required this.carName,
    required this.dealerName,
    required this.mileage,
    required this.transmission,
    required this.year,
    required this.location,
    required this.imageUrl,
    required this.isPremium,
    this.premiumLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        bool isFav = false;
        if (state is LoadedFavoriteCarsState) {
          isFav = state.favoriteCars.any((car) => car.id == carId);
        } else {
          final favs = LocalStorage.getFavoriteCars();
          isFav = favs.contains(carId);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Container(
            width: isHorizontal ? double.infinity : 250,
            decoration: BoxDecoration(
              color: context.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.lightMediumColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CarCardHeader(
                  isFavorite: isFav,
                  toggleFavorite: () {
                    context.read<FavoriteBloc>().add(
                      ToggleToFavoriteEvent(carId: carId),
                    );
                  },
                  imageUrl: imageUrl,
                  isPremium: isPremium,
                  premiumLabel: premiumLabel,
                ),
                CarCardBody(
                  price: price,
                  carName: carName,
                  dealerName: dealerName,
                  mileage: mileage,
                  transmission: transmission,
                  year: year,
                  location: location,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
