import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/locale_keys.dart';
import '../helper/app_helper.dart';

void copyWithFeedback(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));

  AppHelper.successSnackBar(
    context: context,
    message: LocaleKeys.copiedToClipboard.tr(),
  );
}
