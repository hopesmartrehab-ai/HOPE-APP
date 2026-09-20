import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:hope_app/features/profile/presentation/widgets/settings_row_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const notificationItems = [
      SettingsNotificationToggle(
        title: 'Push Notifications',
        subtitle: 'Receive all app notifications',
        value: true,
      ),
      SettingsNotificationToggle(
        title: 'Session Reminders',
        subtitle: 'Daily reminder for your training sessions',
        value: true,
      ),
      SettingsNotificationToggle(
        title: 'Progress Alerts',
        subtitle: 'Celebrate milestones and achievements',
        value: false,
      ),
      SettingsNotificationToggle(
        title: 'Therapist Updates',
        subtitle: 'Notifications when therapist reviews your session',
        value: true,
      ),
    ];

    const preferenceItems = [
      SettingsPreferenceRow(
        icon: Icons.language_rounded,
        label: 'Language',
        value: 'English',
      ),
      SettingsPreferenceRow(
        icon: Icons.straighten_rounded,
        label: 'Units',
        value: 'Metric',
      ),
      SettingsPreferenceRow(
        icon: Icons.light_mode_rounded,
        label: 'Theme',
        value: 'Light',
      ),
    ];

    const legalItems = [
      SettingsLinkRow(
        icon: Icons.lock_outline_rounded,
        label: 'Privacy Settings',
      ),
      SettingsLinkRow(
        icon: Icons.description_outlined,
        label: 'Terms of Service',
      ),
      SettingsLinkRow(icon: Icons.info_outline_rounded, label: 'About HOPE'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(
                  title: 'Profile',
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                const SettingsNotificationCard(items: notificationItems),
                const SizedBox(height: 14),
                const SettingsPreferenceCard(items: preferenceItems),
                const SizedBox(height: 14),
                const SettingsLinksCard(items: legalItems),
                const SizedBox(height: 14),
                const SettingsDangerCard(),
                const SizedBox(height: 18),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D2C45),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'HOPE Smart Rehabilitation • v1.2.0',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF7A8A9B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
