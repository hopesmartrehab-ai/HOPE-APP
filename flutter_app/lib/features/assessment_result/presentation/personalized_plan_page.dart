import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_route.dart';

import '../../../core/constants/locale_keys.dart';
import '../domain/entities/assessment_result.dart';
import 'logic/rehab_pathway_ui.dart';
import 'widgets/step_item_widget.dart';

class PersonalizedPlanPage extends StatelessWidget {
  const PersonalizedPlanPage({required this.result, super.key});

  final AssessmentResult result;

  @override
  Widget build(BuildContext context) {
    final pathway = result.pathway;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF15314B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.yourPersonalizedPlan.tr(),
                      style: const TextStyle(
                        color: Color(0xFF15314B),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      LocaleKeys.basedOnPlanetResults.tr(),
                      style: const TextStyle(
                        color: Color(0xFF6B8296),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2A7C4B), Color(0xFF15314B)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF15314B).withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(pathway.icon, color: Colors.white, size: 32),
                          const SizedBox(height: 20),
                          Text(
                            LocaleKeys.recommendedPathTag.tr(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pathway.titleKey.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pathway.followUpKey.tr(),
                            style: TextStyle(
                              color: pathway.accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            pathway.descriptionKey.tr(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            LocaleKeys.yourNextSteps.tr(),
                            style: const TextStyle(
                              color: Color(0xFF15314B),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 20),
                          StepItemWidget(
                            number: '1',
                            text: LocaleKeys.step1Desc.tr(),
                          ),
                          const SizedBox(height: 16),
                          StepItemWidget(
                            number: '2',
                            text: LocaleKeys.step2Desc.tr(),
                          ),
                          const SizedBox(height: 16),
                          StepItemWidget(
                            number: '3',
                            text: LocaleKeys.step3Desc.tr(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8EFF3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F6F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.assignment_outlined,
                              color: Color(0xFF6B8296),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.fullAssessmentReportBoxTitle.tr(),
                                  style: const TextStyle(
                                    color: Color(0xFF15314B),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  LocaleKeys.fullAssessmentReportBoxSub.tr(),
                                  style: const TextStyle(
                                    color: Color(0xFF86A3B8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            },
                            child: Text(
                              LocaleKeys.viewAction.tr(),
                              style: const TextStyle(
                                color: Color(0xFF4A80A3),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AppRoute.goToMainLayout(context: context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF59C583),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    LocaleKeys.exploreMyRehabilitationPlan.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
