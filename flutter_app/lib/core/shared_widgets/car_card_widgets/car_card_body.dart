import 'package:flutter/material.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

import 'car_card_dealer_info.dart';
import 'car_card_location.dart';
import 'car_card_specs_row.dart';

class CarCardBody extends StatelessWidget {
  final String price;
  final String carName;
  final String dealerName;
  final String mileage;
  final String transmission;
  final String year;
  final String location;

  const CarCardBody({
    required this.price,
    required this.carName,
    required this.dealerName,
    required this.mileage,
    required this.transmission,
    required this.year,
    required this.location,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8, top: 8, end: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: Styles.s14(context).copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CarCardDealerInfo(dealerName: dealerName),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            carName,
            style: Styles.s14(context).copyWith(
              color: context.darkDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          CarCardSpecsRow(
            mileage: mileage,
            transmission: transmission,
            year: year,
          ),
          const SizedBox(height: 8),
          CarCardLocation(location: location),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
