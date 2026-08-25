import 'package:easy_localization/easy_localization.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/theme_extension.dart';

import '../constants/locale_keys.dart';
import '../theme/styles/app_text_styles.dart';

void showInfoToast(
  String message,
  BuildContext ctx, {
  double? height,
  int? delay,
}) {
  ElegantNotification.info(
    title: Text(LocaleKeys.info.tr(), style: Styles.s16(ctx)),
    description: Text(
      message.tr(),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: Styles.s14(ctx),
    ),
    icon: Icon(Icons.info, size: 28, color: ctx.textHintBold),
    background: ctx.white,
    width: MediaQuery.sizeOf(ctx).width * 0.9,
    height: height ?? 80,
    borderRadius: BorderRadius.circular(12),
    animationDuration: const Duration(milliseconds: 600),
    toastDuration: Duration(seconds: delay ?? 2),
    autoDismiss: true,
    progressIndicatorBackground: ctx.bordersColor,
    verticalDividerColor: ctx.bordersColor,
  ).show(ctx);
}
