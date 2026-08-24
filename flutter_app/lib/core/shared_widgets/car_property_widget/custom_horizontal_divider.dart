import 'package:flutter/material.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CustomHorizontalDivider extends StatelessWidget {
  final Color? color;
  const CustomHorizontalDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Divider(color: color ?? context.lightDarkColor, thickness: 1),
        const SizedBox(height: 24),
      ],
    );
  }
}
