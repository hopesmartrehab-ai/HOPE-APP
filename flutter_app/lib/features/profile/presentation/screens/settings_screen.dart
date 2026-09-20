import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/app_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/local_storage/local_storage.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/profile/models/profile_models.dart';
import 'package:hope_app/features/profile/presentation/widgets/profile/profile_header.dart';
import 'package:hope_app/features/profile/presentation/widgets/settings/settings_app_footer.dart';
import 'package:hope_app/features/profile/presentation/widgets/settings/settings_row_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<NotificationSettingModel> _notificationItems;

  @override
  void initState() {
    super.initState();
    _notificationItems = [
      NotificationSettingModel(
        title: LocaleKeys.pushNotifications.tr(),
        subtitle: LocaleKeys.pushNotificationsSubtitle.tr(),
        value: true,
      ),
      NotificationSettingModel(
        title: LocaleKeys.sessionReminders.tr(),
        subtitle: LocaleKeys.sessionRemindersSubtitle.tr(),
        value: true,
      ),
      NotificationSettingModel(
        title: LocaleKeys.progressAlerts.tr(),
        subtitle: LocaleKeys.progressAlertsSubtitle.tr(),
        value: false,
      ),
      NotificationSettingModel(
        title: LocaleKeys.therapistUpdates.tr(),
        subtitle: LocaleKeys.therapistUpdatesSubtitle.tr(),
        value: true,
      ),
    ];
  }

  void _toggleNotification(int index, bool value) {
    setState(() {
      _notificationItems[index] = NotificationSettingModel(
        title: _notificationItems[index].title,
        subtitle: _notificationItems[index].subtitle,
        value: value,
      );
    });
  }

  void _toggleLanguage() {
    final currentLocale = context.locale.languageCode;
    final nextLocale = currentLocale == 'ar'
        ? AppLocalizations.englishLocale
        : AppLocalizations.arabicLocale;

    context.setLocale(nextLocale);
    unawaited(LocalStorage.setLocaleLanguage(nextLocale.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = context.locale.languageCode == 'ar'
        ? LocaleKeys.arabic.tr()
        : LocaleKeys.english.tr();

    final preferenceItems = [
      SettingsPreferenceRow(
        icon: Icons.language_rounded,
        label: LocaleKeys.language.tr(),
        value: currentLanguage,
      ),
      SettingsPreferenceRow(
        icon: Icons.straighten_rounded,
        label: LocaleKeys.units.tr(),
        value: LocaleKeys.metric.tr(),
      ),
      SettingsPreferenceRow(
        icon: Icons.light_mode_rounded,
        label: LocaleKeys.theme.tr(),
        value: LocaleKeys.light.tr(),
      ),
    ];

    final legalItems = [
      SettingsLinkRow(
        icon: Icons.lock_outline_rounded,
        label: LocaleKeys.privacySettings.tr(),
      ),
      SettingsLinkRow(
        icon: Icons.description_outlined,
        label: LocaleKeys.termsOfService.tr(),
      ),
      SettingsLinkRow(
        icon: Icons.info_outline_rounded,
        label: LocaleKeys.aboutHope.tr(),
      ),
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
                  title: LocaleKeys.profile.tr(),
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 20),
                Text(
                  LocaleKeys.settings.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                SettingsNotificationCard(
                  items: _notificationItems
                      .map(
                        (item) => SettingsNotificationToggle(
                          title: item.title,
                          subtitle: item.subtitle,
                          value: item.value,
                        ),
                      )
                      .toList(),
                  onToggle: _toggleNotification,
                ),
                const SizedBox(height: 14),
                SettingsPreferenceCard(
                  items: preferenceItems,
                  onLanguageTap: _toggleLanguage,
                ),
                const SizedBox(height: 14),
                SettingsLinksCard(items: legalItems),
                const SizedBox(height: 14),
                const SettingsDangerCard(),
                const SizedBox(height: 18),
                const SettingsAppFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
