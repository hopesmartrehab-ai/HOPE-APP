import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/constants/app_localization.dart';

/// Subtle pill-shaped language toggle. Designed to sit in an `AppBar.actions`
/// list, but can also be dropped anywhere (e.g. overlaid on AppBar-less
/// screens like the welcome screen).
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isEn = context.locale.languageCode == 'en';
    final label = isEn ? 'ع' : 'EN';
    final tooltip = LocaleKeys.languageToggleTooltip.tr();

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Center(
        child: Tooltip(
          message: tooltip,
          child: InkWell(
            onTap: () {
              final next = isEn ? AppLocalizations.arabicLocale : AppLocalizations.englishLocale;
              context.setLocale(next);
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating variant used on screens without an `AppBar` (e.g. welcome).
class FloatingLanguageToggle extends StatelessWidget {
  const FloatingLanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isEn = context.locale.languageCode == 'en';
    final label = isEn ? 'ع' : 'EN';
    final tooltip = LocaleKeys.languageToggleTooltip.tr();

    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      elevation: 1,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final next = isEn ? AppLocalizations.arabicLocale : AppLocalizations.englishLocale;
          context.setLocale(next);
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Tooltip(
            message: tooltip,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 16, color: Colors.black87),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
