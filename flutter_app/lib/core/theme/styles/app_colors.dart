import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// LIGHT THEME PALETTE
// ─────────────────────────────────────────────────────────────
abstract class AppColors {
  // ── Brand ────────────────────────────────────────────────
  /// Main brand color. Used for AppBar bg, primary buttons, key accents.
  static const Color primary = Color(0xFF1A4663);

  /// Secondary / teal accent. Used for nav indicators, outlined buttons, icons.
  static const Color secondary = Color(0xFF357185);

  /// Soft green accent. Used for success states and subtle highlights.
  static const Color sage = Color(0xFF89B189);

  // ── Backgrounds ─────────────────────────────────────────
  /// Main screen background (Scaffold).
  static const Color scaffoldBg = Color(0xFFFFFFFF);

  /// Surface color — cards, modals, bottom sheets.
  static const Color surface = Color(0xFFFFFFFF);

  /// Slightly off-white. Used as page background when you want warmth.
  static const Color surfaceVariant = Color(0xFFE9E8E6);

  /// Container backgrounds (e.g., input fills, section backgrounds).
  static const Color containerBg = Color(0xFFF7F7F7);

  /// AppBar background.
  static const Color appBarBg = Color(0xFF1A4663);

  /// Bottom nav bar background.
  static const Color navBarBg = Color(0xFFFFFFFF);

  /// Bottom nav indicator (active tab highlight).
  static const Color navIndicator = Color(0x26357185); // teal 15%

  // ── Text ────────────────────────────────────────────────
  /// Primary text — headings, titles, body.
  static const Color textPrimary = Color(0xFF1F2933);

  /// Secondary text — subtitles, card descriptions.
  static const Color textSecondary = Color(0xFF5C6B77);

  /// Hint / placeholder text in inputs.
  static const Color textHint = Color(0xFFBFBFBF);

  /// Muted meta text — timestamps, captions.
  static const Color textMuted = Color(0xFF8C8C8C);

  /// White text — used on dark/colored backgrounds.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Borders & Dividers ──────────────────────────────────
  /// Border and divider lines.
  static const Color border = Color(0xFFE8E9F1);

  // ── Buttons ─────────────────────────────────────────────
  /// Disabled button background.
  static const Color buttonDisabledBg = Color(0xFFEDEDED);

  /// Disabled button text/icon.
  static const Color buttonDisabledFg = Color(0xFF8C8C8C);

  // ── Status ──────────────────────────────────────────────
  /// Success / completed status.
  static const Color statusSuccess = Color(0xFF2F80ED);

  /// Warning / pending status.
  static const Color statusWarning = Color(0xFFBC9658);

  /// Error / danger.
  static const Color statusError = Color(0xFFF13637);

  /// Destructive actions (delete, remove).
  static const Color statusDestructive = Color(0xFFC9372C);
}

// ─────────────────────────────────────────────────────────────
// DARK THEME PALETTE
// ─────────────────────────────────────────────────────────────
abstract class AppDarkColors {
  // ── Brand (same primary, everything else inverted) ───────
  static const Color primary = Color(0xFF1A4663);
  static const Color secondary = Color(0xFF357185);
  static const Color sage = Color(0xFF89B189);

  // ── Backgrounds ─────────────────────────────────────────
  static const Color scaffoldBg = Color(0xFF141414);
  static const Color surface = Color(0xFF1C1C1C);
  static const Color surfaceVariant = Color(0xFF232323);
  static const Color containerBg = Color(0xFF2A2A2A);
  static const Color appBarBg = Color(0xFF1A4663);
  static const Color navBarBg = Color(0xFF1C1C1C);
  static const Color navIndicator = Color(0x26357185);

  // ── Text ────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFEAEAEA);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textHint = Color(0xFF7A7A7A);
  static const Color textMuted = Color(0xFFC1C1C1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Borders & Dividers ──────────────────────────────────
  static const Color border = Color(0xFF333333);

  // ── Buttons ─────────────────────────────────────────────
  static const Color buttonDisabledBg = Color(0xFF4B4B4B);
  static const Color buttonDisabledFg = Color(0xFFA0A0A0);

  // ── Status ──────────────────────────────────────────────
  static const Color statusSuccess = Color(0xFF00C853);
  static const Color statusWarning = Color(0xFFE5B000);
  static const Color statusError = Color(0xFFCF2D2D);
  static const Color statusDestructive = Color(0xFFCF2D2D);
}