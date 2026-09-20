import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/profile/models/profile_models.dart';
import 'package:hope_app/features/profile/presentation/widgets/connected_device/connected_device_glove_panel.dart';
import 'package:hope_app/features/profile/presentation/widgets/connected_device/connected_device_header.dart';
import 'package:hope_app/features/profile/presentation/widgets/connected_device/connected_device_stat_card.dart';
import 'package:hope_app/features/profile/presentation/widgets/connected_device/device_info_card.dart';
import 'package:hope_app/features/profile/presentation/widgets/connected_device/device_status_badge.dart';

class ConnectedDeviceContent extends StatelessWidget {
  const ConnectedDeviceContent({
    required this.model,
    required this.isConnected,
    required this.onDisconnect,
    required this.onConnect,
    super.key,
  });

  final ConnectedDeviceModel model;
  final bool isConnected;
  final VoidCallback onDisconnect;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConnectedDeviceHeader(onBack: () => Navigator.of(context).maybePop()),
          const SizedBox(height: 14),
          Text(
            LocaleKeys.connectedDevice.tr(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          const ConnectedDeviceGlovePanel(),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.deviceName,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${model.model} • ${model.serialNumber}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnected
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFB0B8C1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          DeviceStatusBadge(
            isConnected: isConnected,
            statusText: isConnected
                ? model.statusText
                : LocaleKeys.smartGloveNotConnected.tr(),
          ),
          if (isConnected) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                ConnectedDeviceStatCard(
                  icon: Icons.battery_5_bar_rounded,
                  title: LocaleKeys.battery.tr(),
                  value: model.batteryLevel,
                  iconColor: const Color(0xFF3AA7A2),
                ),
                const SizedBox(width: 10),
                ConnectedDeviceStatCard(
                  icon: Icons.signal_cellular_4_bar_rounded,
                  title: LocaleKeys.signal.tr(),
                  value: model.signalLevel,
                  iconColor: const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 10),
                ConnectedDeviceStatCard(
                  icon: Icons.memory_rounded,
                  title: LocaleKeys.firmware.tr(),
                  value: model.firmwareVersion,
                  iconColor: const Color(0xFF7C4DFF),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onDisconnect,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(
                      color: Color(0xFF1A4663),
                      width: 1.5,
                    ),
                  ),
                ),
                child: Text(
                  LocaleKeys.disconnectGlove.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConnect,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF2E9B67),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  LocaleKeys.connectSmartGlove.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          DeviceInfoCard(
            deviceName: model.deviceName,
            firmwareVersion: model.firmwareVersion,
            lastSynced: model.lastSynced,
            totalSessions: model.totalSessions,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
