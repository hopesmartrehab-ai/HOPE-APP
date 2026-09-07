import 'package:flutter/material.dart';

class RadialGlow extends StatelessWidget {
  const RadialGlow({
    required this.size,
    required this.color,
    required this.opacity,
    super.key,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.70],
          ),
        ),
      ),
    );
  }
}
