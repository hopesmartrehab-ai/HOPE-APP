import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';
import 'package:hope_app/features/profile/models/profile_models.dart';
import 'package:hope_app/features/profile/presentation/screens/connected_device_screen.dart';
import 'package:hope_app/features/profile/presentation/screens/personal_information_screen.dart';
import 'package:hope_app/features/profile/presentation/screens/settings_screen.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile/app_version_footer.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile/online_rehabilitation_card.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile/profile_header.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile/profile_menu_row.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile/profile_metric_card.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile/profile_user_summary_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileModel = ProfileScreenModel(
      user: const ProfileSummaryModel(
        initials: 'SJ',
        fullName: 'Sarah Johnson',
        email: 'sarah.johnson@email.com',
        status: 'Active',
        weekLabel: 'Week 2',
      ),
      metrics: [
        ProfileMetricModel(
          value: '28',
          label: LocaleKeys.profileMetricSessions.tr(),
          color: const Color(0xFF4CAF50),
          icon: Icons.check_circle_rounded,
        ),
        ProfileMetricModel(
          value: '13',
          label: LocaleKeys.profileMetricDayStreak.tr(),
          color: const Color(0xFFFF6B57),
          icon: Icons.local_fire_department_rounded,
        ),
        ProfileMetricModel(
          value: '4.8',
          label: LocaleKeys.profileMetricPerformance.tr(),
          color: const Color(0xFFFFC857),
          icon: Icons.star_rounded,
        ),
      ],
      menuItems: [
        ProfileMenuModel(
          icon: Icons.person_outline_rounded,
          label: LocaleKeys.personalInformation.tr(),
        ),
        ProfileMenuModel(
          icon: Icons.bluetooth_connected_rounded,
          label: LocaleKeys.connectedDevice.tr(),
          trailing: LocaleKeys.smartGlove.tr(),
        ),
        ProfileMenuModel(
          icon: Icons.insert_chart_outlined_rounded,
          label: LocaleKeys.assessmentReport.tr(),
        ),
        ProfileMenuModel(
          icon: Icons.help_outline_rounded,
          label: LocaleKeys.helpSupport.tr(),
        ),
        ProfileMenuModel(
          icon: Icons.logout_rounded,
          label: LocaleKeys.signOut.tr(),
          isDestructive: true,
        ),
      ],
      onlineRehab: OnlineRehabModel(
        title: LocaleKeys.profileOnlineRehabTitle.tr(),
        subtitle: LocaleKeys.profileOnlineRehabSubtitle.tr(),
        progress: '63%',
      ),
      appVersion: 'HOPE v1.2.0',
    );

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
                    title: LocaleKeys.profile.tr().toUpperCase(),
                    onSettingsTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  ProfileUserSummaryCard(user: profileModel.user),
                  const SizedBox(height: 18),
                  OnlineRehabilitationCard(model: profileModel.onlineRehab),
                  const SizedBox(height: 18),
                  ProfileMetricsRow(metrics: profileModel.metrics),
                  const SizedBox(height: 18),
                  ProfileMenuList(
                    items: profileModel.menuItems,
                    onItemTap: (item) {
                      if (item.label == LocaleKeys.personalInformation.tr()) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PersonalInformationScreen(),
                          ),
                        );
                        return;
                      }

                      if (item.label == LocaleKeys.connectedDevice.tr()) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ConnectedDeviceScreen(),
                          ),
                        );
                        return;
                      }

                      if (item.label == LocaleKeys.helpSupport.tr()) {
                        final uri = Uri(
                          scheme: 'mailto',
                          path: 'hope.support@gmail.com',
                          queryParameters: {'subject': 'HOPE Support Request'},
                        );
                        launchUrl(uri);
                        return;
                      }

                      if (item.label == LocaleKeys.signOut.tr()) {
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: Text(LocaleKeys.signOut.tr()),
                            content: Text(
                              LocaleKeys.areYouSureYouWantToSignOut.tr(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                child: Text(LocaleKeys.cancel.tr()),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        LocaleKeys.signedOutSuccessfully.tr(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(LocaleKeys.signOut.tr()),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  AppVersionFooter(version: profileModel.appVersion),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
