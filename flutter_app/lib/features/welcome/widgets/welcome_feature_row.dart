import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/features/welcome/widgets/welcome_feature_card.dart';

class WelcomeFeatureRow extends StatelessWidget {
  const WelcomeFeatureRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 270,
        height: 100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            PositionedDirectional(
              start: 0,
              top: 4,
              child: Transform.rotate(
                angle: -0.105,
                child: WelcomeFeatureCard(
                  icon: '🏆',
                  title: LocaleKeys.welcomeFeatureGamified.tr(),
                  backgroundColor: const Color(0xFFFFF9F0),
                ),
              ),
            ),
            PositionedDirectional(
              start: 82,
              top: 0,
              child: Transform.rotate(
                angle: 0.035,
                child: WelcomeFeatureCard(
                  icon: '🧤',
                  title: LocaleKeys.welcomeFeatureSmartGlove.tr(),
                  backgroundColor: const Color(0xFFF0F8FF),
                ),
              ),
            ),
            PositionedDirectional(
              start: 174,
              top: 2,
              child: Transform.rotate(
                angle: -0.052,
                child: WelcomeFeatureCard(
                  icon: '📈',
                  title: LocaleKeys.welcomeFeatureProgress.tr(),
                  backgroundColor: const Color(0xFFF0FBF5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
