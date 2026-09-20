import 'package:flutter/material.dart';
import 'package:hope_app/features/auth/login/screens/sign_in_screen.dart';
import 'package:hope_app/features/auth/register/sign_up_screen.dart';
import 'package:hope_app/features/home/presentation/assessment_complete/screen/home_assessment_complete_screen.dart';
import 'package:hope_app/features/home/presentation/dashboard/screen/dashboard_screen.dart';
import 'package:hope_app/features/main_layout/screens/main_navigation_screen.dart';
import 'package:hope_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:hope_app/features/rehab/presentation/screens/rehab_screen.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_flow_screen.dart';
import 'package:hope_app/features/start%20_session/presentation/start_session_types.dart';
import 'package:hope_app/features/welcome/screens/welcome_screen.dart';

abstract class AppRoute {
  AppRoute._();

  // static void goToSomethingWentWrongScreen({required BuildContext context}) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const SomethingWentWrongScreen()),
  //   );
  // }
  static void goToOnboarding({required BuildContext context}) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (route) => false,
    );
  }

  static void goToWelcome({required BuildContext context}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const WelcomeScreen()));
  }

  static void goToSignUp({required BuildContext context}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignUpScreen()));
  }

  static void goToSignIn({required BuildContext context}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignInScreen()));
  }

  static void goToRoleSelection({required BuildContext context}) {
    goToOnboarding(context: context);
  }

  static void goToAssessmentComplete({required BuildContext context}) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AssessmentCompleteScreen()),
      (route) => false,
    );
  }

  static void goToDashboard({required BuildContext context}) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  static void goToRehab({required BuildContext context}) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RehabScreen()),
      (route) => false,
    );
  }

  static void goToMainNavigation({required BuildContext context}) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      (route) => false,
    );
  }

  static void goToTrainingSetup({required BuildContext context}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const StartSessionFlowScreen()));
  }

  static void goToConnectGlove({
    required BuildContext context,
    required TrainingApproach selectedApproach,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StartSessionFlowScreen(
          initialPage: 1,
          initialApproach: selectedApproach,
        ),
      ),
    );
  }

  static void goToTrainingFormat({
    required BuildContext context,
    required TrainingApproach selectedApproach,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StartSessionFlowScreen(
          initialPage: 2,
          initialApproach: selectedApproach,
        ),
      ),
    );
  }
}
