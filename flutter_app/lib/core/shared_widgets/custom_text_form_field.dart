import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope_app/core/theme/theme_extension.dart';

import '../theme/styles/app_text_styles.dart';
import 'clicked_widget.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.maxLines,
    this.obscuretxt,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly,
    this.onTap,
    this.keyboardType,
    this.validation,
    this.borderColor,
    this.onChanged,
    this.isPassword = false,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.style,
    this.onFieldSubmitted,
    this.textInputAction,
    this.borderRadius = 12,
  });
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final bool? obscuretxt;
  final Widget? suffixIcon, prefixIcon;
  final bool? readOnly;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validation;
  final Color? borderColor;
  final Function(String)? onChanged;
  final bool isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextStyle? style;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final double? borderRadius;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool viewPassword;
  @override
  void initState() {
    widget.isPassword ? viewPassword = true : viewPassword = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      obscureText: viewPassword,
      obscuringCharacter: '*',
      maxLines: widget.maxLines ?? 1,
      onChanged: widget.onChanged,
      controller: widget.controller,
      readOnly: widget.readOnly ?? false,
      cursorColor: context.primaryColor,
      focusNode: widget.focusNode,
      onTap: widget.onTap,
      textInputAction: widget.textInputAction,
      style: widget.style ?? Styles.s16(context),
      maxLength: widget.maxLength,
      validator: widget.validation,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(
            color: widget.borderColor ?? context.primaryColor,
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(
            color: widget.borderColor ?? context.bordersColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(
            color: widget.borderColor ?? context.bordersColor,
          ),
        ),
        filled: true,
        suffixIcon: widget.isPassword
            ? ClickedWidget(
                onTap: () {
                  setState(() {
                    viewPassword = !viewPassword;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    viewPassword
                        ? "Assets.assetsIconsEyeVisable"                     // =============change the ""=================
                        : "Assets.assetsIconsEyeNotVisable",                  // =============change the ""=================

                    // color: context.textHintLight,
                  ),
                ),
              )
            : widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        hintStyle:
            widget.style ??
            Styles.s14(context).copyWith(color: context.darkLightestColor),
        hintText: widget.hintText,
        fillColor: context.white,

        label: widget.labelText != null
            ? Text(
                widget.labelText!,
                style:
                    widget.style ??
                    Styles.s14(context).copyWith(color: context.darkLightColor),
              )
            : null,
      ),
    );
  }
}
