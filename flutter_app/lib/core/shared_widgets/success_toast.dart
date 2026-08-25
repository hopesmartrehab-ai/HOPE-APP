import 'package:easy_localization/easy_localization.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/theme_extension.dart';

import '../theme/styles/app_text_styles.dart';

void showSuccessToast(
  String message,
  BuildContext ctx, {
  double? height,
  int? delay,
}) {
  ElegantNotification.success(
    title: Text(LocaleKeys.success.tr(), style: Styles.s16(ctx)),
    description: Text(message.tr(), style: Styles.s14(ctx)),
    icon: Icon(
      Icons.check_circle,
      // color: Theme.of(ctx).indicatorColor,
      color: ctx.successColor,
      size: 28,
    ),
    background: ctx.white,
    width: MediaQuery.sizeOf(ctx).width * 0.9,
    height: height ?? 70,
    borderRadius: BorderRadius.circular(12),
    animationDuration: const Duration(milliseconds: 600),
    toastDuration: Duration(seconds: delay ?? 5),
    autoDismiss: true,
    progressIndicatorBackground: ctx.bordersColor,
    verticalDividerColor: ctx.bordersColor,
  ).show(ctx);
}
