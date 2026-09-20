import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';

class DeviceStatusBadge extends StatelessWidget {
  const DeviceStatusBadge({
    required this.isConnected,
    this.statusText,
    super.key,
  });

  final bool isConnected;
  final String? statusText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isConnected ? const Color(0xFFEAF8EE) : const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected
              ? const Color(0xFF9AD6AE)
              : const Color(0xFFE1E6EC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected ? const Color(0xFF3BB273) : Colors.grey,
            ),
            child: Icon(
              isConnected ? Icons.check_rounded : Icons.info_outline_rounded,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            statusText ??
                (isConnected
                    ? LocaleKeys.hopeSmartGloveConnected.tr()
                    : LocaleKeys.smartGloveNotConnected.tr()),
            style: TextStyle(
              color: isConnected
                  ? const Color(0xFF1A6A4F)
                  : const Color(0xFF58667A),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
