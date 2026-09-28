import 'package:flutter/material.dart';

class StarFieldBackground extends StatelessWidget {
  const StarFieldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    const positions = [
      Offset(0.12, 0.18),
      Offset(0.24, 0.34),
      Offset(0.37, 0.15),
      Offset(0.44, 0.52),
      Offset(0.62, 0.22),
      Offset(0.75, 0.38),
      Offset(0.88, 0.14),
      Offset(0.18, 0.62),
      Offset(0.31, 0.73),
      Offset(0.52, 0.80),
      Offset(0.67, 0.63),
      Offset(0.82, 0.76),
      Offset(0.92, 0.48),
      Offset(0.14, 0.88),
      Offset(0.58, 0.92),
    ];

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return IgnorePointer(
            child: Stack(
              children: positions.map((offset) {
                final left = constraints.maxWidth * offset.dx;
                final top = constraints.maxHeight * offset.dy;
                final size = 3.0 + (offset.dx * 4.0) % 2.0;

                return Positioned(
                  left: left,
                  top: top,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEAF9FF),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
