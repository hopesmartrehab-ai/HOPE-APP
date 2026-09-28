import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.dart';

class PracticeLevelPage extends StatelessWidget {
  const PracticeLevelPage({
    required this.level,
    required this.onComplete,
    super.key,
  });

  final int level;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final progressValue = (level / 5) * 100;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFDCE8F2),
              Color(0xFFF2F6F9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(5, (index) {
                    final active = index < level;
                    return Container(
                      width: active ? 16 : 6,
                      height: 6,
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF59C583)
                            : const Color(0xFFC4D4E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Text(
                  LocaleKeys.levelXOf5.tr(args: [level.toString()]),
                  style: const TextStyle(
                    color: Color(0xFF4A80A3),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _levelTitle(level),
                  style: const TextStyle(
                    color: Color(0xFF15314B),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF152A3D),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF152A3D).withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.currentTask.tr(),
                        style: const TextStyle(
                          color: Color(0xFF86A3B8),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _taskDescription(level),
                        style: const TextStyle(
                          color: Color(0xFF15314B),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.progress.tr(),
                            style: const TextStyle(
                              color: Color(0xFF86A3B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${progressValue.round()}%',
                            style: const TextStyle(
                              color: Color(0xFF15314B),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progressValue / 100,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE8EFF3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF59C583),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onComplete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF59C583),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            LocaleKeys.completeLevel.tr(args: [level.toString()]),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _levelTitle(int level) {
    switch (level) {
      case 1:
        return LocaleKeys.levelTitleReachGrasp.tr();
      case 2:
        return LocaleKeys.levelTitleGripStrength.tr();
      case 3:
        return LocaleKeys.levelTitleCoordination.tr();
      case 4:
        return LocaleKeys.levelTitleManipulation.tr();
      default:
        return LocaleKeys.levelTitleReleaseControl.tr();
    }
  }

  String _taskDescription(int level) {
    switch (level) {
      case 1:
        return LocaleKeys.taskDescReachGrasp.tr();
      case 2:
        return LocaleKeys.taskDescGripStrength.tr();
      case 3:
        return LocaleKeys.taskDescCoordination.tr();
      case 4:
        return LocaleKeys.taskDescManipulation.tr();
      default:
        return LocaleKeys.taskDescReleaseControl.tr();
    }
  }
}
