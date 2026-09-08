import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/splash/widgets/radial_glow.dart';
import 'package:hope_app/features/splash/widgets/splash_dots.dart';
import 'package:hope_app/features/splash/widgets/splash_mark.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.splashBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.78, -1),
              end: Alignment(0.76, 1),
              colors: [
                AppColors.splashGradientStart,
                AppColors.splashGradientMiddle,
                AppColors.splashGradientEnd,
              ],
              stops: [0.08, 0.58, 0.92],
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                top: -100,
                right: -80,
                child: RadialGlow(
                  size: 300,
                  color: AppColors.splashGreenGlow,
                  opacity: 0.08,
                ),
              ),
              const Positioned(
                left: -60,
                bottom: -80,
                child: RadialGlow(
                  size: 250,
                  color: AppColors.splashBlueGlow,
                  opacity: 0.06,
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -26),
                  child: const SplashMark(),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 56,
                child: SplashDots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
