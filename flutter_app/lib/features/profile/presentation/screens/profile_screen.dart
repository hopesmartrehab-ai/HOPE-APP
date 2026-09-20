import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/profile/presentation/screens/personal_information_screen.dart';
import 'package:hope_app/features/profile/presentation/screens/settings_screen.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile_menu_row.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile_metric_card.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile_user_summary_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const metrics = [
      ProfileMetricItem(
        value: '28',
        label: 'Sessions',
        color: Color(0xFF4CAF50),
        icon: Icons.check_circle_rounded,
      ),
      ProfileMetricItem(
        value: '13',
        label: 'Day Streak',
        color: Color(0xFFFF6B57),
        icon: Icons.local_fire_department_rounded,
      ),
      ProfileMetricItem(
        value: '4.8',
        label: 'Performance',
        color: Color(0xFFFFC857),
        icon: Icons.star_rounded,
      ),
    ];

    const menuItems = [
      ProfileMenuItem(
        icon: Icons.person_outline_rounded,
        label: 'Personal Information',
      ),
      ProfileMenuItem(
        icon: Icons.bluetooth_connected_rounded,
        label: 'Connected Device',
        trailing: 'Smart Glove',
      ),
      ProfileMenuItem(
        icon: Icons.insert_chart_outlined_rounded,
        label: 'Assessment Report',
      ),
      ProfileMenuItem(
        icon: Icons.help_outline_rounded,
        label: 'Help & Support',
      ),
      ProfileMenuItem(
        icon: Icons.logout_rounded,
        label: 'Sign Out',
        isDestructive: true,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ProfileHeader(
                    title: 'MY PROFILE',
                    onSettingsTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  const ProfileUserSummaryCard(),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFDEE7F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF4F8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.computer_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Online Rehabilitation',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Monthly Follow-Up • Week 2 of 12',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF9EE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '63%',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const ProfileMetricsRow(metrics: metrics),
                  const SizedBox(height: 18),
                  ProfileMenuList(
                    items: menuItems,
                    onItemTap: (item) {
                      if (item.label == 'Personal Information') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PersonalInformationScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 12,
                          color: Color(0xFF7A8A9B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'HOPE v1.2.0',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
