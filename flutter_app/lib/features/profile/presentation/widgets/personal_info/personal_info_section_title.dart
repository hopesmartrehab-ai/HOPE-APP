import 'package:flutter/material.dart';

class PersonalInfoSectionTitle extends StatelessWidget {
  const PersonalInfoSectionTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: const Color(0xFF7A8A9B),
        letterSpacing: 0.8,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
