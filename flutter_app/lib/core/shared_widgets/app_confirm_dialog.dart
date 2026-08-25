import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/theme_extension.dart';

import '../theme/styles/app_text_styles.dart';

/// A reusable confirmation dialog used for destructive actions (e.g. delete).
///
/// Usage:
/// ```dart
/// final confirmed = await AppConfirmDialog.show(
///   context: context,
///   description: LocaleKeys.areYouSureYouWantToDeleteThisDepartment.tr(),
/// );
/// if (confirmed) { ... }
/// ```
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.description,
    super.key,
    this.title,
    this.confirmLabel,
    this.cancelLabel,
  });

  final String description;
  final String? title;
  final String? confirmLabel;
  final String? cancelLabel;

  // ─── Static helper ────────────────────────────────────────────────────────

  static Future<bool> show({
    required BuildContext context,
    required String description,
    String? title,
    String? confirmLabel,
    String? cancelLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AppConfirmDialog(
        description: description,
        title: title,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
    );
    return result ?? false;
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title ?? LocaleKeys.delete.tr();
    final resolvedConfirm = confirmLabel ?? LocaleKeys.delete.tr();
    final resolvedCancel = cancelLabel ?? LocaleKeys.cancel.tr();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: context.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon badge ──
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: context.redColor.withValues(alpha: .10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 32,
                color: context.redColor,
              ),
            ),

            const SizedBox(height: 16),

            // ── Title ──
            Text(
              resolvedTitle,
              style: Styles.s18(context).copyWith(color: context.textBlack),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // ── Description ──
            Text(
              description,
              style: Styles.s14(context).copyWith(color: context.textHintBold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // ── Buttons ──
            Row(
              children: [
                // Cancel
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: context.bordersColor),
                      ),
                      child: Text(
                        resolvedCancel,
                        style: Styles.s14(
                          context,
                        ).copyWith(color: context.textBlack),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Confirm (destructive)
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.redColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        resolvedConfirm,
                        style: Styles.s14(
                          context,
                        ).copyWith(color: context.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
