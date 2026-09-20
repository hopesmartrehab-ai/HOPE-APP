import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';

class SharedSessionBottomBar extends StatelessWidget {
  const SharedSessionBottomBar({
    required this.enabled,
    required this.onPressed,
    this.title = 'Continue',
    super.key,
  });

  final bool enabled;
  final VoidCallback? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F4F8),
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: CustomButton(
        title: title,
        isLoading: false,
        backgroundColor: enabled ? const Color(0xFF4ADE80) : Colors.grey[300],
        foregroundColor: enabled ? Colors.white : Colors.grey[500],
        borderRadius: 16,
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
