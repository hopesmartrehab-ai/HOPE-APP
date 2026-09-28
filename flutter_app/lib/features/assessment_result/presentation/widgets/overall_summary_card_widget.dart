import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.dart';

/// Overall result summary: derived score, its band, and how many levels passed.
class OverallSummaryCardWidget extends StatelessWidget {
  const OverallSummaryCardWidget({
    required this.score,
    required this.bandLabelKey,
    required this.bandDescriptionKey,
    required this.passedCount,
    required this.levelCount,
    super.key,
  });

  /// Mean of the level scores, 0..100.
  final int score;

  /// Locale key naming the functional band for [score].
  final String bandLabelKey;

  /// Locale key for the paragraph explaining [bandLabelKey].
  final String bandDescriptionKey;

  final int passedCount;
  final int levelCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A53),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A53).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: score / 100),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 7,
                        backgroundColor: const Color(0xFFE8EFF3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      LocaleKeys.scoreLabel.tr(),
                      style: const TextStyle(
                        color: Color(0xFF86A3B8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bandLabelKey.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bandDescriptionKey.tr(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF59C583).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    LocaleKeys.levelsPassedBadgeCount.tr(
                      args: [passedCount.toString(), levelCount.toString()],
                    ),
                    style: const TextStyle(
                      color: Color(0xFF59C583),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
