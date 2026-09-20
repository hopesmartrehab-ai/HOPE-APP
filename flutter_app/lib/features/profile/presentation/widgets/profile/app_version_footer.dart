import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';

class AppVersionFooter extends StatelessWidget {
  const AppVersionFooter({required this.version, super.key});

  final String version;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline, size: 12, color: Color(0xFF7A8A9B)),
          const SizedBox(width: 4),
          Text(
            version,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
