import 'package:flutter/material.dart';

class PerformanceBarWidget extends StatelessWidget {
  const PerformanceBarWidget({
    required this.title,
    required this.percentage,
    required this.color,
    super.key,
  });

  final String title;
  final int percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF6B8296),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                color: Color(0xFF15314B),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: const Color(0xFFE8EFF3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
