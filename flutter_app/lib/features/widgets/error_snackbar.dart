import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';

import '../state/session_provider.dart';

/// Show the SessionProvider's last error as a SnackBar, mapping the
/// `errorNoNetwork` sentinel to the localized "no internet" string. Returns
/// without doing anything if there's nothing to show.
void showSessionError(BuildContext context, String? raw) {
  if (raw == null || raw.isEmpty) return;
  
  final msg = raw == SessionProvider.errorNoNetwork ? LocaleKeys.noInternet.tr() : raw;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
