import 'package:flutter/material.dart';
import 'package:hope_app/features/auth/login/screens/sign_in_screen.dart';
import 'package:hope_app/features/auth/register/sign_up_screen.dart';
import 'package:hope_app/features/home/presentation/assessment_complete/screen/home_assessment_complete_screen.dart';
import 'package:hope_app/features/home/presentation/dashboard/screen/dashboard_screen.dart';
import 'package:hope_app/features/onboarding/screens/onboarding_screen.dart';
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
}
