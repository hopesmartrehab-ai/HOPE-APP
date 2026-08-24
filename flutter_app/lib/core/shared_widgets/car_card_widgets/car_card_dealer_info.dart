import 'package:flutter/material.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CarCardDealerInfo extends StatelessWidget {
  final String dealerName;

  const CarCardDealerInfo({required this.dealerName, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      //make text direction show base on language
      textDirection: Localizations.localeOf(context).languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        const CircleAvatar(radius: 8, backgroundColor: Colors.grey),
        const SizedBox(width: 4),
        Text(
          dealerName,
          style: Styles.s10(context).copyWith(color: context.darkMediumColor),
        ),
      ],
    );
  }
}
