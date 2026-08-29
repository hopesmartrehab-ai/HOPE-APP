import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:provider/provider.dart';

import '../../state/session_provider.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/language_toggle.dart';
import '../dashboard/dashboard_screen.dart';
import 'assess_waiting_screen.dart';

class SessionStartScreen extends StatelessWidget {
  const SessionStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.errorMessage != null) {
        showSessionError(context, provider.errorMessage);
        provider.clearError();
      }
      // The device is now auto-linked inside startSession(), so we go straight
      // to the assessment-waiting screen once the session is ready.
      if (provider.state == SessionState.waitingForAssessment) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AssessWaitingScreen()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.startSession.tr()),
        actions: const [LanguageToggle()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.health_and_safety, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              Text(
                LocaleKeys.readyToBegin.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.sessionIntro.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              provider.state == SessionState.creatingSession
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: Text(LocaleKeys.startNewSession.tr()),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () =>
                          context.read<SessionProvider>().startSession(),
                    ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.insights),
                label: Text(LocaleKeys.dashboard.tr()),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const DashboardScreen(mode: DashboardMode.patient),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
