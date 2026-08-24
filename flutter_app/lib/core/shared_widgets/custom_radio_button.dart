import 'package:flutter/material.dart';
import 'package:tara_car/core/shared_widgets/clicked_widget.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CustomRadioButton({
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClickedWidget(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        padding: const EdgeInsetsDirectional.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? context.primaryColor : const Color(0xFFD1D5DB),
            width: 2,
          ),
        ),
        child: isSelected
            ? Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF008080),
                ),
              )
            : null,
      ),
    );
  }
}
