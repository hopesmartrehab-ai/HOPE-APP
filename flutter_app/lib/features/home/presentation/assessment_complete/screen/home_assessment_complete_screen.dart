import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/local_storage/local_storage.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/utils/app_route.dart';
import 'package:hope_app/features/home/presentation/assessment_complete/widget/assessment_complete_card.dart';
import 'package:hope_app/features/home/presentation/assessment_complete/widget/custom_header.dart';
import 'package:hope_app/features/home/presentation/assessment_complete/widget/get_started_section.dart';
import 'package:hope_app/features/home/presentation/assessment_complete/widget/recommendation_card.dart';
import 'package:hope_app/features/home/presentation/assessment_complete/widget/welcome_texts.dart';
import 'package:hope_app/features/home/presentation/model/assessment_result_model.dart';

class AssessmentCompleteScreen extends StatefulWidget {
  const AssessmentCompleteScreen({super.key});

  @override
  State<AssessmentCompleteScreen> createState() =>
      _AssessmentCompleteScreenState();
}

class _AssessmentCompleteScreenState extends State<AssessmentCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(),
                const SizedBox(height: 24),
                const WelcomeTexts(),
                const SizedBox(height: 24),
                const AssessmentCompleteCard(
                  resultModel: AssessmentResultModel(
                    baselineScore: '63%',
                    recoveryPotential: '78%',
                    estimatedProgram: '12w',
                  ),
                ),
                const SizedBox(height: 16),
                const RecommendationCard(),
                const SizedBox(height: 24),
                const GetStartedSection(),
                const SizedBox(height: 24),
                CustomButton(
                  title: LocaleKeys.exploreMyPlan.tr(),
                  isLoading: false,
                  backgroundColor: AppColors.onboardingStart,
                  foregroundColor: Colors.white,
                  borderRadius: 16.0,
                  onPressed: () async {
                    await LocalStorage.setShouldShowAssessmentCompleteHome(
                      shouldShow: false,
                    );
                    if (context.mounted) {
                      AppRoute.goToMainLayout(context: context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
