import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/theme_extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/styles/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.title,
    required this.isLoading,
    required this.isBackgroundPrimary,
    super.key,
    this.borderRadius,
    this.foregroundColor,
    this.backgroundColor,
    this.onPressed,
    this.width,
    this.height,
    this.borderSide = BorderSide.none,
    this.isStroked = false,
    this.padding,
    this.style,
    this.child,
  });
  final Color? foregroundColor;
  final Color? backgroundColor;
  final String title;
  final Function()? onPressed;
  final bool isLoading;
  final bool isBackgroundPrimary;
  final double? width;
  final double? height;
  final BorderSide borderSide;
  final bool isStroked;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final Widget? child;
  final double? borderRadius;

  Color _foreground(BuildContext context) {
    if (isStroked) {
      return context.primaryColor;
    }

    if (onPressed == null && !isLoading) {
      return context.textHintBold;
    }

    return foregroundColor ?? context.lightLightnessColor;
  }

  @override
  Widget build(BuildContext context) {
    final foreground = _foreground(context);
    final isRightToLeft = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: ElevatedButton(
        onPressed: (onPressed == null || isLoading)
            ? null
            : () => onPressed?.call(),

        style: ElevatedButton.styleFrom(
          padding: padding,
          alignment: Alignment.center,

          backgroundColor: isStroked
              ? context.white
              : backgroundColor ?? context.primaryColor,

          disabledBackgroundColor: context.buttonDisabledBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 80),
            side: isStroked
                ? BorderSide(color: context.primaryColor)
                : borderSide,
          ),
        ),
        child: isLoading
            ? Center(
                child: ExcludeSemantics(
                  child: Transform.flip(
                    flipX: isRightToLeft,
                    child: LoadingAnimationWidget.progressiveDots(
                      color: foreground,
                      size: 30,
                    ),
                  ),
                ),
              )
            : child ??
                  Center(
                    child: Text(
                      title,
                      style: (style ?? Styles.s14(context)).copyWith(
                        fontWeight: FontWeight.w600,
                        color: foreground,
                      ),
                    ),
                  ),
      ),
    );
  }
}
