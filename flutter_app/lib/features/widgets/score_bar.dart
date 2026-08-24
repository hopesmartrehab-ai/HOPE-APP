import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final String label;
  final double percent;

  const ScoreBar({
    super.key,
    required this.label,
    required this.percent,
  });

  Color _barColor() {
    if (percent >= 70) return Colors.green;
    if (percent >= 50) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percent / 100,
              color: _barColor(),
              backgroundColor: Colors.grey.shade200,
              minHeight: 10,
            ),
          ),
          const SizedBox(width: 8),
          Text('${percent.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}
