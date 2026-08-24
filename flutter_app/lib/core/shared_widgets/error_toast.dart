import 'package:easy_localization/easy_localization.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

import '../constants/locale_keys.dart';
import '../theme/styles/app_text_styles.dart';

void showErrorToast(
  String message,
  BuildContext ctx, {
  double? height,
  String? title,
}) {
  final normalizedMessage = message.trim();
  final estimatedLines = (normalizedMessage.length / 34).ceil().clamp(1, 6);
  final toastHeight =
      height ?? (92 + ((estimatedLines - 1) * 18)).toDouble().clamp(96, 188);
  final toastDuration = Duration(
    seconds: estimatedLines >= 5
        ? 8
        : estimatedLines >= 3
        ? 7
        : 5,
  );

  ElegantNotification.error(
    title: Text(
      title ?? LocaleKeys.error.tr(),
      style: Styles.s16(ctx).copyWith(color: ctx.errorDarkColor),
    ),
    description: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: toastHeight - 48),
      child: SingleChildScrollView(
        child: Text(
          normalizedMessage,
          softWrap: true,
          style: Styles.s14(
            ctx,
          ).copyWith(color: ctx.errorDarkColor, height: 1.45),
        ),
      ),
    ),
    icon: Icon(Icons.error, color: ctx.errorDarkColor, size: 28),
    background: ctx.white,
    height: toastHeight,
    width: MediaQuery.of(ctx).size.width * 0.9,
    borderRadius: BorderRadius.circular(12),
    animationDuration: const Duration(milliseconds: 600),
    toastDuration: toastDuration,
    autoDismiss: true,
    progressIndicatorBackground: ctx.bordersColor,
    verticalDividerColor: ctx.bordersColor,
  ).show(ctx);
}
