import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.dart';
import '../../../../core/utils/app_route.dart';

class AnalyzingPerformancePage extends StatefulWidget {
  const AnalyzingPerformancePage({super.key});

  @override
  State<AnalyzingPerformancePage> createState() =>
      _AnalyzingPerformancePageState();
}

class _AnalyzingPerformancePageState extends State<AnalyzingPerformancePage> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        AppRoute.goToAssessmentReport(context: context);
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDCE8F2), Color(0xFFF2F6F9)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF59C583,
                        ).withOpacity(0.15),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 116,
                        height: 116,
                        child: CircularProgressIndicator(
                          value: 0.7,
                          strokeWidth: 8,
                          backgroundColor: Color(0xFFE8EFF3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF59C583),
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Icon(
                        Icons.insights_rounded,
                        size: 48,
                        color: const Color(0xFF59C583).withOpacity(0.9),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  LocaleKeys.analyzingYourPerformanceTitle.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF15314B),
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.preparingInsightsDesc.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6B8296),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.analyzingProgressHeader.tr(),
                            style: const TextStyle(
                              color: Color(0xFF86A3B8),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            '70%',
                            style: TextStyle(
                              color: Color(0xFF15314B),
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(
                          value: 0.7,
                          minHeight: 8,
                          backgroundColor: Color(0xFFE8EFF3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF59C583),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF59C583),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              LocaleKeys.comparingWithBenchmarks.tr(),
                              style: const TextStyle(
                                color: Color(0xFF15314B),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
