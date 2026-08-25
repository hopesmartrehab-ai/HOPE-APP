import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hope_app/core/theme/logic/theme_cubit.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';

/// Context extension providing theme-aware color getters.
/// Usage: `context.primaryColor`, `context.scaffoldBg`, etc.
extension ThemeColors on BuildContext {
  bool get isDarkMode => read<ThemeCubit>().isDarkMode;

  // ── Brand ─────────────────────────────────────────────────────────────────

  /// Main brand color. AppBar bg, primary buttons, key accents.
  Color get primaryColor =>
      isDarkMode ? AppDarkColors.primary : AppColors.primary;

  /// Secondary accent (teal). Nav indicators, outlined buttons, icons.
  Color get secondaryColor =>
      isDarkMode ? AppDarkColors.secondary : AppColors.secondary;

  /// Soft green accent. Success highlights, subtle backgrounds.
  Color get sageColor =>
      isDarkMode ? AppDarkColors.sage : AppColors.sage;

  // ── Backgrounds ───────────────────────────────────────────────────────────

  /// Main screen (Scaffold) background color.
  Color get scaffoldBg =>
      isDarkMode ? AppDarkColors.scaffoldBg : AppColors.scaffoldBg;

  /// Card / modal / bottom-sheet surface color.
  Color get surfaceColor =>
      isDarkMode ? AppDarkColors.surface : AppColors.surface;

  /// Warm off-white page background variant (e.g., list page backgrounds).
  Color get surfaceVariant =>
      isDarkMode ? AppDarkColors.surfaceVariant : AppColors.surfaceVariant;

  /// Input fills, section container backgrounds.
  Color get containerBg =>
      isDarkMode ? AppDarkColors.containerBg : AppColors.containerBg;

  /// AppBar background.
  Color get appBarBg =>
      isDarkMode ? AppDarkColors.appBarBg : AppColors.appBarBg;

  /// Bottom navigation bar background.
  Color get navBarBg =>
      isDarkMode ? AppDarkColors.navBarBg : AppColors.navBarBg;

  /// Bottom nav active tab indicator color.
  Color get navIndicator =>
      isDarkMode ? AppDarkColors.navIndicator : AppColors.navIndicator;

  // ── Text ──────────────────────────────────────────────────────────────────

  /// Primary text — headings, titles, body copy.
  Color get textPrimary =>
      isDarkMode ? AppDarkColors.textPrimary : AppColors.textPrimary;

  /// Secondary text — subtitles, card descriptions.
  Color get textSecondary =>
      isDarkMode ? AppDarkColors.textSecondary : AppColors.textSecondary;

  /// Placeholder / hint text inside input fields.
  Color get textHint =>
      isDarkMode ? AppDarkColors.textHint : AppColors.textHint;

  /// Muted meta text — timestamps, captions, fine print.
  Color get textMuted =>
      isDarkMode ? AppDarkColors.textMuted : AppColors.textMuted;

  /// Text/icon placed on top of a colored (primary/secondary) background.
  Color get textOnPrimary =>
      isDarkMode ? AppDarkColors.textOnPrimary : AppColors.textOnPrimary;

  // ── Borders & Dividers ────────────────────────────────────────────────────

  /// Border lines, card strokes, dividers.
  Color get borderColor =>
      isDarkMode ? AppDarkColors.border : AppColors.border;

  // ── Buttons ───────────────────────────────────────────────────────────────

  /// Disabled button background.
  Color get buttonDisabledBg =>
      isDarkMode ? AppDarkColors.buttonDisabledBg : AppColors.buttonDisabledBg;

  /// Disabled button text / icon color.
  Color get buttonDisabledFg =>
      isDarkMode ? AppDarkColors.buttonDisabledFg : AppColors.buttonDisabledFg;

  // ── Status & Feedback ─────────────────────────────────────────────────────

  /// Success / completed state color.
  Color get statusSuccess =>
      isDarkMode ? AppDarkColors.statusSuccess : AppColors.statusSuccess;

  /// Warning / pending state color (gold).
  Color get statusWarning =>
      isDarkMode ? AppDarkColors.statusWarning : AppColors.statusWarning;

  /// Error state color.
  Color get statusError =>
      isDarkMode ? AppDarkColors.statusError : AppColors.statusError;

  /// Destructive action color (delete / remove).
  Color get statusDestructive =>
      isDarkMode ? AppDarkColors.statusDestructive : AppColors.statusDestructive;

  // ── Legacy aliases (kept for backward-compat with shared_widgets) ─────────

  /// @deprecated Use [textPrimary].
  Color get textBlack => textPrimary;

  /// @deprecated Use [textHint].
  Color get textHintLight => textHint;

  /// @deprecated Use [textMuted].
  Color get textHintBold => textMuted;

  /// @deprecated Use [borderColor].
  Color get bordersColor => borderColor;

  /// @deprecated Use [borderColor].
  Color get dividerColor => borderColor;

  /// @deprecated Use [borderColor].
  Color get lightGray => borderColor;

  /// @deprecated Use [surfaceColor].
  Color get white => surfaceColor;

  /// @deprecated Use [statusDestructive].
  Color get redColor => statusDestructive;

  /// @deprecated Use [surfaceVariant].
  Color get buttomSheetTopColor => surfaceVariant;

  /// @deprecated Use [textOnPrimary].
  Color get lightLightnessColor => textOnPrimary;

  /// @deprecated Use [textPrimary].
  Color get darkDarkColor => textPrimary;

  /// @deprecated Use [textSecondary].
  Color get darkLightColor => textSecondary;

  /// @deprecated Use [textMuted].
  Color get darkLightestColor => textMuted;

  /// @deprecated Use [textSecondary].
  Color get darkMediumColor => textSecondary;

  /// @deprecated Use [statusError].
  Color get errorDarkColor => statusError;

  /// @deprecated Use [statusSuccess].
  Color get successColor => statusSuccess;

  /// @deprecated Use [statusWarning].
  Color get pendingColor => statusWarning;

  /// @deprecated Use [statusSuccess].
  Color get completedColor => statusSuccess;

  /// @deprecated Use [primaryColor].
  Color get blackColor =>
      isDarkMode ? const Color(0xff1C1C1C) : const Color(0xff000000);
}