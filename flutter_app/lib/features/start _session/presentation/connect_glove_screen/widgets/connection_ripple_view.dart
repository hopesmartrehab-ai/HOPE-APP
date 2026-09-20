import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/assets_constants.dart';

class ConnectionRippleView extends StatelessWidget {
  const ConnectionRippleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCircle(size: 320, opacity: 0.1),
        _buildCircle(size: 240, opacity: 0.2),
        _buildCircle(size: 160, opacity: 0.3),

        Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
            // color: Colors.white,
            // borderRadius: BorderRadius.circular(26),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withValues(alpha: 0.05),
            //     blurRadius: 12,
            //   ),
            // ],
          ),
          padding: const EdgeInsets.all(20),
          child: Image.asset(
            Assets.onboardingGlove,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildCircle({required double size, required double opacity}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.withValues(alpha: opacity),
          width: 1,
        ),
      ),
    );
  }
}
