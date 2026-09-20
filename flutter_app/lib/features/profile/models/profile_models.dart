import 'package:flutter/material.dart';

class ProfileSummaryModel {
  const ProfileSummaryModel({
    required this.initials,
    required this.fullName,
    required this.email,
    required this.status,
    required this.weekLabel,
  });

  final String initials;
  final String fullName;
  final String email;
  final String status;
  final String weekLabel;
}

class ProfileMetricModel {
  const ProfileMetricModel({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  final String value;
  final String label;
  final Color color;
  final IconData icon;
}

class ProfileMenuModel {
  const ProfileMenuModel({
    required this.icon,
    required this.label,
    this.trailing,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final String? trailing;
  final bool isDestructive;
}

class OnlineRehabModel {
  const OnlineRehabModel({
    required this.title,
    required this.subtitle,
    required this.progress,
    this.icon = Icons.computer_rounded,
    this.progressColor = const Color(0xFF2E7D32),
  });

  final String title;
  final String subtitle;
  final String progress;
  final IconData icon;
  final Color progressColor;
}

class ProfileScreenModel {
  const ProfileScreenModel({
    required this.user,
    required this.metrics,
    required this.menuItems,
    required this.onlineRehab,
    this.appVersion = 'HOPE v1.2.0',
  });

  final ProfileSummaryModel user;
  final List<ProfileMetricModel> metrics;
  final List<ProfileMenuModel> menuItems;
  final OnlineRehabModel onlineRehab;
  final String appVersion;
}

class PersonalInfoModel {
  const PersonalInfoModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.therapistName,
    required this.therapistRole,
    required this.affectedSide,
    this.initials = 'SJ',
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String therapistName;
  final String therapistRole;
  final String affectedSide;
  final String initials;
}

class ConnectedDeviceModel {
  const ConnectedDeviceModel({
    required this.deviceName,
    required this.model,
    required this.serialNumber,
    required this.statusText,
    required this.batteryLevel,
    required this.signalLevel,
    required this.firmwareVersion,
    required this.lastSynced,
    required this.totalSessions,
    this.isConnected = true,
  });

  final String deviceName;
  final String model;
  final String serialNumber;
  final String statusText;
  final String batteryLevel;
  final String signalLevel;
  final String firmwareVersion;
  final String lastSynced;
  final String totalSessions;
  final bool isConnected;
}

class NotificationSettingModel {
  const NotificationSettingModel({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final String title;
  final String subtitle;
  final bool value;
}

class PreferenceSettingModel {
  const PreferenceSettingModel({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class LinkSettingModel {
  const LinkSettingModel({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class SettingsScreenModel {
  const SettingsScreenModel({
    required this.notifications,
    required this.preferences,
    required this.links,
    this.languageLabel = 'English',
    this.appVersion = 'HOPE Smart Rehabilitation • v1.2.0',
  });

  final List<NotificationSettingModel> notifications;
  final List<PreferenceSettingModel> preferences;
  final List<LinkSettingModel> links;
  final String languageLabel;
  final String appVersion;
}
