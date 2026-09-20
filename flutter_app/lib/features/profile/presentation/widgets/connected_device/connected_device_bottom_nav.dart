import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';

class ConnectedDeviceBottomNav extends StatelessWidget {
  const ConnectedDeviceBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _BottomNavItem(
        icon: Icons.home_rounded,
        label: LocaleKeys.home.tr(),
        active: false,
      ),
      _BottomNavItem(
        icon: Icons.accessibility_new_rounded,
        label: LocaleKeys.rehab.tr(),
        active: false,
      ),
      _BottomNavItem(
        icon: Icons.insights_rounded,
        label: LocaleKeys.progress.tr(),
        active: false,
      ),
      _BottomNavItem(
        icon: Icons.person_rounded,
        label: LocaleKeys.profile.tr(),
        active: true,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5EBF2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 22,
                color: item.active
                    ? AppColors.primary
                    : const Color(0xFF7B8B9A),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 10,
                  color: item.active
                      ? AppColors.primary
                      : const Color(0xFF7B8B9A),
                  fontWeight: item.active ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;
}
