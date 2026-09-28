import 'package:flutter/material.dart';

/// Accent for a level's score, so a bar's colour carries the same meaning as
/// its height instead of being fixed per level.
Color scoreAccentColor(int percent) {
  if (percent >= 80) return const Color(0xFF59C583);
  if (percent >= 60) return const Color(0xFF4A80A3);
  return const Color(0xFFFF8B49);
}
