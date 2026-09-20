import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class SettingsNotificationToggle {
  const SettingsNotificationToggle({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final String title;
  final String subtitle;
  final bool value;
}

class SettingsPreferenceRow {
  const SettingsPreferenceRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class SettingsLinkRow {
  const SettingsLinkRow({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class SettingsNotificationCard extends StatelessWidget {
  const SettingsNotificationCard({required this.items, super.key});

  final List<SettingsNotificationToggle> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EAF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: Styles.s18(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SettingsToggleRow(
                title: item.title,
                subtitle: item.subtitle,
                value: item.value,
              ),
            ),
        ],
      ),
    );
  }
}

class SettingsPreferenceCard extends StatelessWidget {
  const SettingsPreferenceCard({required this.items, super.key});

  final List<SettingsPreferenceRow> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EAF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: SettingsValueRow(row: item),
            ),
        ],
      ),
    );
  }
}

class SettingsLinksCard extends StatelessWidget {
  const SettingsLinksCard({required this.items, super.key});

  final List<SettingsLinkRow> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EAF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: SettingsLinkRowWidget(row: item),
            ),
        ],
      ),
    );
  }
}

class SettingsDangerCard extends StatelessWidget {
  const SettingsDangerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7C7C7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SettingsDangerRowWidget(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Account',
            ),
          ),
          Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F5)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SettingsDangerRowWidget(
              icon: Icons.logout_rounded,
              label: 'Sign Out',
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Styles.s16(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Styles.s12(
                  context,
                ).copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Transform.scale(
          scale: 0.82,
          child: Switch(
            value: value,
            onChanged: (_) {},
            activeTrackColor: const Color(0xFF5DBE7A),
            inactiveTrackColor: const Color(0xFFDDE5EA),
            activeThumbColor: Colors.white,
            inactiveThumbColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SettingsValueRow extends StatelessWidget {
  const SettingsValueRow({required this.row, super.key});

  final SettingsPreferenceRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(row.icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            row.label,
            style: Styles.s16(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          row.value,
          style: Styles.s16(
            context,
          ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class SettingsLinkRowWidget extends StatelessWidget {
  const SettingsLinkRowWidget({required this.row, super.key});

  final SettingsLinkRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(row.icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            row.label,
            style: Styles.s16(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.primary,
          size: 22,
        ),
      ],
    );
  }
}

class SettingsDangerRowWidget extends StatelessWidget {
  const SettingsDangerRowWidget({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFFDA5858)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Styles.s16(context).copyWith(
              color: const Color(0xFFDA5858),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
