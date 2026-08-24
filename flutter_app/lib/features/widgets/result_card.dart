import 'package:flutter/material.dart';

import '../../core/old_core/l10n/gen/app_localizations.dart';

class ResultCard extends StatelessWidget {
  final String functionName;
  final bool passed;

  const ResultCard({
    required this.functionName,
    required this.passed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = passed ? Colors.green : Colors.red;
    final bgColor = passed ? Colors.green.shade50 : Colors.red.shade50;
    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              passed ? Icons.check_circle : Icons.cancel,
              color: color,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                functionName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              passed
                  ? AppLocalizations.of(context).pass
                  : AppLocalizations.of(context).fail,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
