import 'package:flutter/material.dart';
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

  static void goToRoleSelection({required BuildContext context}) {
    goToOnboarding(context: context);
  }
}
