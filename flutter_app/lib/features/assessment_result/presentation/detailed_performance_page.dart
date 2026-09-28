import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/locale_keys.dart';
import '../../../core/utils/app_route.dart';
import 'widgets/insights_card_widget.dart';
import 'widgets/level_score_card_widget.dart';
import 'widgets/opportunity_card_widget.dart';

class DetailedPerformancePage extends StatefulWidget {
  const DetailedPerformancePage({super.key});

  @override
  State<DetailedPerformancePage> createState() =>
      _DetailedPerformancePageState();
}

class _DetailedPerformancePageState extends State<DetailedPerformancePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _levelData = [
    {
      'titleKey': LocaleKeys.levelTitleReachGrasp,
      'score': 72,
      'color': const Color(0xFF59C583),
      'insights': [
        'Good reach extension observed',
        'Grasp pattern stable',
        'Minor tremor noted at full extension',
      ],
      'opportunityKey': LocaleKeys.levelTitleReachGrasp,
    },
    {
      'titleKey': LocaleKeys.levelTitleGripStrength,
      'score': 58,
      'color': const Color(0xFF4A80A3),
      'insights': [
        'Reduced grip force vs. norm',
        'Consistency improving',
        'Consider strengthening exercises',
      ],
      'opportunityKey': LocaleKeys.levelTitleGripStrength,
    },
    {
      'titleKey': LocaleKeys.levelTitleCoordination,
      'score': 65,
      'color': const Color(0xFF59C583),
      'insights': [
        'Opposition sequence performed well',
        'Speed within expected range',
        'Right hand dominance clear',
      ],
      'opportunityKey': LocaleKeys.levelTitleCoordination,
    },
    {
      'titleKey': LocaleKeys.levelTitleManipulation,
      'score': 48,
      'color': const Color(0xFFFF8B49),
      'insights': [
        'Rotation range slightly limited',
        'Fine motor precision needs support',
        'Targeted exercises recommended',
      ],
      'opportunityKey': LocaleKeys.levelTitleManipulation,
    },
    {
      'titleKey': LocaleKeys.levelTitleReleaseControl,
      'score': 70,
      'color': const Color(0xFF59C583),
      'insights': [
        'Good controlled release',
        'Individual finger isolation improving',
        'Continued practice beneficial',
      ],
      'opportunityKey': LocaleKeys.levelTitleReleaseControl,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentData = _levelData[_selectedIndex];
    final color = currentData['color'] as Color;
    final title = (currentData['titleKey'] as String).tr();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF6B8296),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: -8,
        title: Text(
          LocaleKeys.back.tr(),
          style: const TextStyle(
            color: Color(0xFF6B8296),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                LocaleKeys.detailedPerformance.tr(),
                style: const TextStyle(
                  color: Color(0xFF15314B),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _levelData.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  final itemTitle = (_levelData[index]['titleKey'] as String).tr();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF15314B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF15314B)
                              : const Color(0xFFE8EFF3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'L${index + 1}: $itemTitle',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6B8296),
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    LevelScoreCardWidget(
                      selectedIndex: _selectedIndex,
                      title: title,
                      score: currentData['score'] as int,
                      color: color,
                    ),
                    const SizedBox(height: 16),
                    InsightsCardWidget(
                      insights: (currentData['insights'] as List).cast<String>(),
                      color: color,
                    ),
                    const SizedBox(height: 16),
                    OpportunityCardWidget(
                      opportunityText: (currentData['opportunityKey'] as String).tr(),
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
                  onPressed: () => AppRoute.goToPotentialRecovery(context: context),
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
                    LocaleKeys.viewPotentialRecovery.tr(),
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
