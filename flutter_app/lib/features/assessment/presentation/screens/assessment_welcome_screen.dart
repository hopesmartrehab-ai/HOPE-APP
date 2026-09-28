import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/assessment/presentation/widgets/assessment_feature_card.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_flow_screen.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';

class AssessmentWelcomeScreen extends StatelessWidget {
  const AssessmentWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A4663),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'HOPE ASSESSMENT',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Before we begin your rehabilitation journey',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A quick assessment helps HOPE understand your current abilities and create a rehabilitation plan that is personalized to you.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              const AssessmentFeatureCard(
                icon: Icons.person_rounded,
                title: 'Personalized to You',
                subtitle:
                    'Your results guide every exercise and recommendation.',
                accentColor: Color(0xFFEAF3FF),
              ),
              const SizedBox(height: 10),
              const AssessmentFeatureCard(
                icon: Icons.sports_gymnastics_rounded,
                title: 'Engaging & Gamified',
                subtitle:
                    'Complete 5 interactive levels in the HOPE planet experience.',
                accentColor: Color(0xFFF5F1FF),
              ),
              const SizedBox(height: 10),
              const AssessmentFeatureCard(
                icon: Icons.timer_rounded,
                title: 'Takes About 10 Minutes',
                subtitle: 'Go at your own pace — there is no pressure or rush.',
                accentColor: Color(0xFFF1F8F1),
              ),
              const SizedBox(height: 10),
              const AssessmentFeatureCard(
                icon: Icons.shield_outlined,
                title: 'Private & Secure',
                subtitle: 'Your data is only shared with your care team.',
                accentColor: Color(0xFFF6F5F0),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const StartSessionFlowScreen(
                          isAssessmentMode: true,
                          initialApproach: TrainingApproach.smartGlove,
                          initialFormat: TrainingFormatType.video,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DBE7A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Assessment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
