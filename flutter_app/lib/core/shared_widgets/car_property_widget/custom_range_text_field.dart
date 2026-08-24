import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CustomRangeTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final TextInputType keyboardType;
  final double? borderRadius;
  final Color? borderColor;
  final String? suffixText;

  const CustomRangeTextField({
    required this.label,
    this.initialValue,
    this.keyboardType = TextInputType.number,
    this.borderRadius,
    this.borderColor,
    this.suffixText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsetsDirectional.only(
          start: 16,
          end: 16,
          top: 8,
          bottom: 4,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? context.lightMediumColor),
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Styles.s10(
                context,
              ).copyWith(color: context.darkLightColor),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    initialValue: initialValue,
                    keyboardType: keyboardType,
                    cursorColor: context.primaryColor,
                    style: Styles.s12(
                      context,
                    ).copyWith(color: context.darkDarkColor),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                if (suffixText != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8, start: 4),
                    child: Text(
                      suffixText!,
                      style: Styles.s12(context).copyWith(
                        color: context.darkDarkColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
