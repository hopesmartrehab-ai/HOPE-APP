import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.dart';

class LevelScoreCardWidget extends StatelessWidget {
  const LevelScoreCardWidget({
    required this.levelNumber,
    required this.levelCount,
    required this.title,
    required this.score,
    required this.passed,
    required this.color,
    super.key,
  });

  /// This level's position in the session, starting at 1.
  final int levelNumber;

  /// How many levels the session contained.
  final int levelCount;

  final String title;
  final int score;
  final bool passed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final badgeColor = passed
        ? const Color(0xFF43A047)
        : const Color(0xFFE8A33D);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
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
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score%',
                      style: const TextStyle(
                        color: Color(0xFF15314B),
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
                  LocaleKeys.levelXOfTotal.tr(
                    args: [levelNumber.toString(), levelCount.toString()],
                  ),
                  style: const TextStyle(
                    color: Color(0xFF86A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF15314B),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (passed
                                ? LocaleKeys.levelPassed
                                : LocaleKeys.levelNotPassed)
                            .tr(),
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: score / 100),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 4,
                        backgroundColor: const Color(0xFFE8EFF3),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
