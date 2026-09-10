import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/assets_constants.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/onboarding/models/onboarding_item.dart';
import 'package:hope_app/features/onboarding/widgets/onboarding_content_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final List<OnboardingItem> _onboardingItems = const [
    OnboardingItem(
      title: LocaleKeys.onboardingTherapyTitle,
      description: LocaleKeys.onboardingTherapyDescription,
      image: Assets.onboardingTherapy,
      topColor: AppColors.onboardingTherapyTop,
      bottomColor: AppColors.onboardingTherapyBottom,
    ),
    OnboardingItem(
      title: LocaleKeys.onboardingGloveTitle,
      description: LocaleKeys.onboardingGloveDescription,
      image: Assets.onboardingGlove,
      topColor: AppColors.onboardingGloveTop,
      bottomColor: AppColors.onboardingGloveBottom,
      hasImageBackground: true,
    ),
    OnboardingItem(
      title: LocaleKeys.onboardingPlanetTitle,
      description: LocaleKeys.onboardingPlanetDescription,
      image: Assets.onboardingPlanet,
      topColor: AppColors.onboardingPlanetTop,
      bottomColor: AppColors.onboardingPlanetBottom,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _onboardingItems.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    _controller.animateToPage(
      _onboardingItems.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingContentView(
        controller: _controller,
        onboardingItems: _onboardingItems,
        currentPage: _currentPage,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        onNext: _onNext,
        onSkip: _onSkip,
      ),
    );
  }
}
