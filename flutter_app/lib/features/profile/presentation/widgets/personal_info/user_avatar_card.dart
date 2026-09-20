import 'package:flutter/material.dart';

class UserAvatarCard extends StatelessWidget {
  const UserAvatarCard({
    super.key,
    this.initials = 'S',
    this.size = 86,
    this.borderRadius = 22,
    this.backgroundColor = const Color(0xFF1A4663),
  });

  final String initials;
  final double size;
  final double borderRadius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
