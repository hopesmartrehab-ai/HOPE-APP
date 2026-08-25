import 'package:flutter/material.dart';

import '../../core/old_core/l10n/gen/app_localizations.dart';
import '../../core/old_core/theme/app_theme.dart';
import '../widgets/language_toggle.dart';
import 'patient/patient_shell_screen.dart';
import 'practitioner/practitioner_shell_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.chooseYourRole),
        actions: const [LanguageToggle()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.roleIntro,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: HopeColors.muted, height: 1.4),
            ),
            const SizedBox(height: 40),
            _ModeCard(
              title: t.rolePatient,
              description: t.rolePatientDesc,
              icon: Icons.personal_injury,
              color: HopeColors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PatientShellScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _ModeCard(
              title: t.roleDoctor,
              description: t.roleDoctorDesc,
              icon: Icons.medical_services,
              color: HopeColors.navy,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PractitionerShellScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: HopeColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(color: HopeColors.muted),
                    ),
                  ],
                ),
              ),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left
                    : Icons.chevron_right,
                color: HopeColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
