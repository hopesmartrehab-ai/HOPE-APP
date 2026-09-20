import 'package:flutter/material.dart';

class SettingsAppFooter extends StatelessWidget {
  const SettingsAppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF7A8A9B)),
          ),
        ],
      ),
    );
  }
}
