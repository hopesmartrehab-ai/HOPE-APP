import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/helper/app_helper.dart';
import 'package:tara_car/feature/home/data/data_source/car_card_list.dart';

import '../../constants/locale_keys.dart';
import 'car_card_view.dart';

class BuildCarCard extends StatelessWidget {
  final bool showPremiumOnly;

  const BuildCarCard({required this.showPremiumOnly, super.key});

  @override
  Widget build(BuildContext context) {
    final filteredCars = showPremiumOnly
        ? cars.where((car) => car.isPremium).toList()
        : cars;

    return SizedBox(
      height: 310,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filteredCars.length,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final car = filteredCars[index];
          return GestureDetector(
            onTap: () {
              AppHelper.successSnackBar(
                context: context,
                message: '${car.carName} tapped',
              );
            },
            child: CarCarView(
              carId: car.id,
              isHorizontal: false,
              imageUrl: car.imageUrl,
              isPremium: car.isPremium,
              premiumLabel: car.isPremium ? LocaleKeys.premium.tr() : null,
              price: car.price,
              carName: car.carName,
              dealerName: car.dealerName,
              mileage: car.mileage,
              transmission: car.transmission,
              year: car.year,
              location: car.location,
            ),
          );
        },
      ),
    );
  }
}
