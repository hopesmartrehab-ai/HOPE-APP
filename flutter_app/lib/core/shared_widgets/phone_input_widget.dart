import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class PhoneInputWidget extends StatelessWidget {
  const PhoneInputWidget({
    required this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: context.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.bordersColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.assetsFlagsEgyptIcon,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Text(
                  "+20",
                  style: Styles.s14(
                    context,
                  ).copyWith(color: context.darkLightColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Directionality(
              textDirection: context.locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: TextFormField(
                readOnly: readOnly,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                controller: controller,
                onChanged: onChanged,
                validator: validator,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                style: Styles.s14(context),
                textAlign: context.locale.languageCode == 'ar'
                    ? TextAlign.right
                    : TextAlign.left,
                decoration: InputDecoration(
                  hintText: hintText ?? "1x xxxx xxxx",
                  labelText: LocaleKeys.phoneNumber.tr(),
                  labelStyle: Styles.s14(
                    context,
                  ).copyWith(color: context.darkLightColor),

                  hintStyle: Styles.s14(
                    context,
                  ).copyWith(color: context.darkLightColor),
                  filled: true,
                  fillColor: context.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: _buildBorder(context),
                  enabledBorder: _buildBorder(context),
                  focusedBorder: _buildBorder(context, isFocused: true),
                  errorBorder: _buildBorder(context, isError: true),
                  focusedErrorBorder: _buildBorder(context, isError: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildBorder(
    BuildContext context, {
    bool isFocused = false,
    bool isError = false,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: isError
            ? context.redColor
            : (isFocused ? context.primaryColor : context.bordersColor),
        width: isFocused ? 1.5 : 1,
      ),
    );
  }
}

//old phone input widget code is in the file lib/core/shared_widgets/phone_input_widget.dart
/*import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart'; 
import 'package:intl_phone_field/countries.dart';       
import '../styles/app_colors.dart'; 
import '../styles/styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart'; 
class PhoneInputWidget extends StatefulWidget {
  const PhoneInputWidget({
    required this.controller,
    this.initialCountryCode = 'EG',
    this.hintText,
    this.validator,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String initialCountryCode;
  final String? hintText;
  final String? Function(PhoneNumber?)? validator;
  final void Function(PhoneNumber)? onChanged;

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  late String _initialCountryCode;

  @override
  void initState() {
    super.initState();
    _initialCountryCode = _resolveCountryCode();
  }

  String _resolveCountryCode() {
    final text = widget.controller.text.trim();
    if (text.startsWith('+')) {
      
      final sorted = [...countries]
        ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));
      
      for (final country in sorted) {
        final dialCode = '+${country.dialCode}';
        if (text.startsWith(dialCode) && text.length > dialCode.length) {
          widget.controller.text = text.substring(dialCode.length);
          return country.code;
        }
      }
    }
    return widget.initialCountryCode;
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: widget.controller,
      initialCountryCode: _initialCountryCode,
      disableLengthCheck: false,
      showDropdownIcon: true,
      dropdownIconPosition: IconPosition.trailing,
      flagsButtonPadding: const EdgeInsetsDirectional.only(start: 12),
      dropdownIcon: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 18,
        color: context.darkLightColor, 
      ),
      style: Styles.s16(context),
      dropdownTextStyle: Styles.s14(context),
      onChanged: widget.onChanged,
      validator: (phone) {
        if (widget.validator != null) {
          return widget.validator!(phone);
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      textAlign: context.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Styles.s14(context).copyWith(color: context.darkLightColor),
        filled: true,
        fillColor: context.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.bordersColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.bordersColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}*/
