import 'package:flutter/material.dart';
import 'package:hope_app/features/profile/models/profile_models.dart';
import 'package:hope_app/features/profile/presentation/widgets/connected_device/connected_device_bottom_nav.dart';
import 'package:hope_app/features/profile/presentation/widgets/connected_device/connected_device_content.dart';

class ConnectedDeviceScreen extends StatefulWidget {
  const ConnectedDeviceScreen({super.key, this.model});

  final ConnectedDeviceModel? model;

  @override
  State<ConnectedDeviceScreen> createState() => _ConnectedDeviceScreenState();
}

class _ConnectedDeviceScreenState extends State<ConnectedDeviceScreen> {
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _isConnected = (widget.model ?? _buildDefaultModel()).isConnected;
  }

  ConnectedDeviceModel _buildDefaultModel() {
    return const ConnectedDeviceModel(
      deviceName: 'HOPE Smart Glove',
      model: 'Model HSG-2026',
      serialNumber: 'Serial #HG-48291',
      statusText: 'HOPE Smart Glove connected',
      batteryLevel: '87%',
      signalLevel: 'Strong',
      firmwareVersion: '2.1.4',
      lastSynced: 'Today at 9:30 AM',
      totalSessions: '28 sessions',
      isConnected: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model ?? _buildDefaultModel();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ConnectedDeviceContent(
                model: model,
                isConnected: _isConnected,
                onDisconnect: () {
                  setState(() {
                    _isConnected = false;
                  });
                },
                onConnect: () {
                  setState(() {
                    _isConnected = true;
                  });
                },
              ),
            ),
            const ConnectedDeviceBottomNav(),
          ],
        ),
      ),
    );
  }
}
