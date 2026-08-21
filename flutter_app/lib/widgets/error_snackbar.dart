import 'package:flutter/material.dart';
import '../l10n/gen/app_localizations.dart';
import '../state/session_provider.dart';

/// Show the SessionProvider's last error as a SnackBar, mapping the
/// `errorNoNetwork` sentinel to the localized "no internet" string. Returns
/// without doing anything if there's nothing to show.
void showSessionError(BuildContext context, String? raw) {
  if (raw == null || raw.isEmpty) return;
  final t = AppLocalizations.of(context);
  final msg = raw == SessionProvider.errorNoNetwork ? t.noInternet : raw;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
