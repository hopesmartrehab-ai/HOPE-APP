import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tara_car/core/shared_widgets/clicked_widget.dart';
import 'package:tara_car/core/theme/logic/theme_cubit.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CustomFilterOption extends StatefulWidget {
  final String title;
  final String? unselectedSvgIcon;
  final String? selectedSvgIcon;

  const CustomFilterOption({
    required this.title,
    this.unselectedSvgIcon,
    this.selectedSvgIcon,
    super.key,
  });

  @override
  State<CustomFilterOption> createState() => _CustomFilterOptionState();
}

class _CustomFilterOptionState extends State<CustomFilterOption> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().isDarkMode;

    Color textColor() {
      if (isSelected) return context.white;

      return isDark ? Colors.white : context.darkDarkestColor;
    }

    Color iconColor() {
      if (isSelected) return context.white;

      return isDark ? Colors.white : context.darkDarkColor;
    }

    return Expanded(
      child: ClickedWidget(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? context.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor
                  : isDark
                  //edit it again
                  ? const Color.fromARGB(255, 87, 85, 85)
                  : context.lightMediumColor,
            ),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.unselectedSvgIcon != null) ...[
                    SvgPicture.asset(
                      height: 16,
                      width: 16,
                      isSelected && widget.selectedSvgIcon != null
                          ? widget.selectedSvgIcon!
                          : widget.unselectedSvgIcon!,
                      colorFilter: widget.selectedSvgIcon == null
                          ? ColorFilter.mode(iconColor(), BlendMode.srcIn)
                          : null,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: widget.unselectedSvgIcon != null ? 8 : 0,
                    ),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: Styles.s12(context).copyWith(
                        color: textColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
