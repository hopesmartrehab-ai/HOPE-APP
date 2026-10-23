import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/training/data/models/training_result_model.dart';

class TrainingResultsScreen extends StatelessWidget {
  const TrainingResultsScreen({
    required this.result,
    required this.onFinish,
    super.key,
  }) : _isGameCompletion = false;

  const TrainingResultsScreen.game({super.key})
    : result = null,
      onFinish = null,
      _isGameCompletion = true;

  final TrainingResultModel? result;
  final VoidCallback? onFinish;
  final bool _isGameCompletion;

  @override
  Widget build(BuildContext context) {
    final levelTitles = [
      LocaleKeys.levelTitleReachGrasp.tr(),
      LocaleKeys.levelTitleGripStrength.tr(),
      LocaleKeys.levelTitleCoordination.tr(),
      LocaleKeys.levelTitleManipulation.tr(),
      LocaleKeys.levelTitleReleaseControl.tr(),
    ];
    final trainingResult = result;
    final completedLevels = trainingResult?.normalizedCompletedLevels ?? 0;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: GradientBackground(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.navIndicator,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.insights_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.trainingResultsTitle.tr(),
                                  style: Styles.s20(context).copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  LocaleKeys.trainingResultsSubtitle.tr(),
                                  style: Styles.s12(
                                    context,
                                  ).copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_isGameCompletion)
                        const _GameCompletionCard()
                      else ...[
                        _TrainingSummaryCard(
                          result: trainingResult!,
                          completedLevels: completedLevels,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          LocaleKeys.trainingCompletedActivities.tr(),
                          style: Styles.s18(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.035),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              for (
                                var index = 0;
                                index < completedLevels &&
                                    index < levelTitles.length;
                                index++
                              ) ...[
                                _CompletedActivityRow(
                                  index: index + 1,
                                  title: levelTitles[index],
                                ),
                                if (index < completedLevels - 1 &&
                                    index < levelTitles.length - 1)
                                  const Divider(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: CustomButton(
                  title: LocaleKeys.trainingFinish.tr(),
                  isLoading: false,
                  backgroundColor: const Color(0xFF59C583),
                  foregroundColor: Colors.white,
                  borderRadius: 14,
                  onPressed: onFinish ?? () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCompletionCard extends StatelessWidget {
  const _GameCompletionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF59C583).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF32A86B),
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.trainingGameCompletedTitle.tr(),
            textAlign: TextAlign.center,
            style: Styles.s18(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.trainingGameCompletedSubtitle.tr(),
            textAlign: TextAlign.center,
            style: Styles.s14(
              context,
            ).copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _TrainingSummaryCard extends StatelessWidget {
  const _TrainingSummaryCard({
    required this.result,
    required this.completedLevels,
  });

  final TrainingResultModel result;
  final int completedLevels;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A53),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A53).withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 86,
            height: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 78,
                  height: 78,
                  child: CircularProgressIndicator(
                    value: result.completionPercentage / 100,
                    strokeWidth: 7,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF59C583),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${result.completionPercentage}%',
                      style: Styles.s16(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      LocaleKeys.progress.tr(),
                      style: Styles.s10(
                        context,
                      ).copyWith(color: Colors.white.withValues(alpha: 0.72)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.trainingCompletionGrade.tr(),
                  style: Styles.s12(context).copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.completionGrade,
                  style: Styles.s28(
                    context,
                  ).copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completedLevels/${result.totalLevels} '
                  '${LocaleKeys.trainingLevelsCompleted.tr()}',
                  style: Styles.s12(
                    context,
                  ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF59C583).withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF7DE0A0),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedActivityRow extends StatelessWidget {
  const _CompletedActivityRow({required this.index, required this.title});

  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF59C583).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: Styles.s12(context).copyWith(
                  color: const Color(0xFF298A52),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Styles.s14(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF59C583),
            size: 20,
          ),
        ],
      ),
    );
  }
}
