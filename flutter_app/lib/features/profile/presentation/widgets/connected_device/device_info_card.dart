import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';

class DeviceInfoCard extends StatelessWidget {
  const DeviceInfoCard({
    required this.deviceName,
    required this.firmwareVersion,
    required this.lastSynced,
    required this.totalSessions,
    super.key,
  });

  final String deviceName;
  final String firmwareVersion;
  final String lastSynced;
  final String totalSessions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _DeviceInfoRow(
            label: LocaleKeys.profileFieldDeviceName.tr(),
            value: deviceName,
          ),
          const _DeviceDivider(),
          _DeviceInfoRow(
            label: LocaleKeys.profileFieldFirmwareVersion.tr(),
            value: firmwareVersion,
          ),
          const _DeviceDivider(),
          _DeviceInfoRow(
            label: LocaleKeys.profileFieldLastSynced.tr(),
            value: lastSynced,
          ),
          const _DeviceDivider(),
          _DeviceInfoRow(
            label: LocaleKeys.profileFieldTotalSessions.tr(),
            value: totalSessions,
          ),
        ],
      ),
    );
  }
}

class _DeviceInfoRow extends StatelessWidget {
  const _DeviceInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceDivider extends StatelessWidget {
  const _DeviceDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFE9EEF3));
  }
}
