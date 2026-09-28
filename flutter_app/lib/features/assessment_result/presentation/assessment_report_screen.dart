import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/locale_keys.dart';
import '../../../core/utils/app_route.dart';
import 'widgets/area_card_widget.dart';
import 'widgets/overall_summary_card_widget.dart';
import 'widgets/performance_bar_widget.dart';

class AssessmentReportPage extends StatelessWidget {
  const AssessmentReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF59C583),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assessment_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.assessmentReportHeader.tr(),
                    style: const TextStyle(
                      color: Color(0xFF6B8296),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                LocaleKeys.yourAssessmentResults.tr(),
                style: const TextStyle(
                  color: Color(0xFF15314B),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.completedTodaySub.tr(),
                style: const TextStyle(
                  color: Color(0xFF6B8296),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              const OverallSummaryCardWidget(),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.performanceByArea.tr(),
                      style: const TextStyle(
                        color: Color(0xFF15314B),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PerformanceBarWidget(
                      title: LocaleKeys.levelTitleReachGrasp.tr(),
                      percentage: 72,
                      color: const Color(0xFF59C583),
                    ),
                    const SizedBox(height: 16),
                    PerformanceBarWidget(
                      title: LocaleKeys.levelTitleGripStrength.tr(),
                      percentage: 58,
                      color: const Color(0xFF4A80A3),
                    ),
                    const SizedBox(height: 16),
                    PerformanceBarWidget(
                      title: LocaleKeys.levelTitleCoordination.tr(),
                      percentage: 65,
                      color: const Color(0xFF59C583),
                    ),
                    const SizedBox(height: 16),
                    PerformanceBarWidget(
                      title: LocaleKeys.levelTitleManipulation.tr(),
                      percentage: 48,
                      color: const Color(0xFFFF8B49),
                    ),
                    const SizedBox(height: 16),
                    PerformanceBarWidget(
                      title: LocaleKeys.levelTitleReleaseControl.tr(),
                      percentage: 70,
                      color: const Color(0xFF59C583),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AreaCardWidget(
                      icon: '💪',
                      title: LocaleKeys.strengthAreas.tr(),
                      items: const [
                        LocaleKeys.levelTitleReachGrasp,
                        LocaleKeys.levelTitleReleaseControl,
                      ],
                      dotColor: const Color(0xFF59C583),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AreaCardWidget(
                      icon: '🎯',
                      title: LocaleKeys.focusAreas.tr(),
                      items: const [
                        LocaleKeys.levelTitleManipulation,
                        LocaleKeys.levelTitleGripStrength,
                      ],
                      dotColor: const Color(0xFFFF8B49),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => AppRoute.goToDetailedPerformance(context: context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF15314B),
                    side: const BorderSide(
                      color: Color(0xFF15314B),
                      width: 1.5,
                    ),
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.viewDetailedResults.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
