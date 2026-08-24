import 'package:flutter/material.dart';
import '../l10n/gen/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/language_toggle.dart';
import 'role_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: HopeColors.offWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.directional(
              textDirection: Directionality.of(context),
              top: 8,
              end: 12,
              child: const FloatingLanguageToggle(),
            ),
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Image.asset('assets/logo.png', height: 280),
              const SizedBox(height: 32),
              Text(
                t.welcomeTo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: HopeColors.muted),
              ),
              const SizedBox(height: 4),
              Text(
                t.appName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: HopeColors.navy,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.appTagline,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: HopeColors.teal),
              ),
              const Spacer(flex: 3),
              FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RoleSelectionScreen(),
                  ),
                ),
                child: Text(t.getStarted),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }
}
