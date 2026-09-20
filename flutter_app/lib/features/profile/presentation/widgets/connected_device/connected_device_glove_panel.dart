import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/assets_constants.dart';

class ConnectedDeviceGlovePanel extends StatelessWidget {
  const ConnectedDeviceGlovePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2F9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDDE7F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          Assets.onboardingGlove,
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
