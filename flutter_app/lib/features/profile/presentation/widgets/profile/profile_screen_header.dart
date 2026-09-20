import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';

class ProfileScreenHeader extends StatelessWidget {
  const ProfileScreenHeader({
    required this.title,
    this.onSettingsTap,
    super.key,
  });

  final String title;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (onSettingsTap != null)
          IconButton(
            onPressed: onSettingsTap,
            icon: const Icon(Icons.settings_rounded, color: AppColors.primary),
          ),
      ],
    );
  }
}
