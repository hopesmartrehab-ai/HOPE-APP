import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hope_app/features/screens/splash/widgets/radial_glow.dart';
import 'package:hope_app/features/screens/splash/widgets/splash_dots.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashLogo = 'assets/images/hope_splash_logo.png';
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    // _navigationTimer = Timer(const Duration(seconds: 2), _goToRoleSelection);
  }

  // void _goToRoleSelection() {
  //   if (!mounted) return;
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
  //   );
  // }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0A1520),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1520),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.78, -1),
              end: Alignment(0.76, 1),
              colors: [Color(0xFF163E61), Color(0xFF0D2B44), Color(0xFF0A1F33)],
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
                  color: Color(0xFF4FB679),
                  opacity: 0.10,
                ),
              ),
              const Positioned(
                left: -60,
                bottom: -80,
                child: RadialGlow(
                  size: 250,
                  color: Color(0xFF347CB3),
                  opacity: 0.08,
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -26),
                  child: const _SplashMark(),
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

class _SplashMark extends StatelessWidget {
  const _SplashMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1.55,
              ),
            ),
          ),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1.15,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                _SplashScreenState._splashLogo,
                width: 128,
                height: 128,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 26),
              Text(
                'HOPE',
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 36,
                  height: 40 / 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SMART REHABILITATION',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.50),
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
