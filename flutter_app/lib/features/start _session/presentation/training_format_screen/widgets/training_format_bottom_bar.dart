import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/custom_button.dart';
// import 'package:hope_app/core/utils/app_route.dart'; // هنحتاجها بعدين للتوجه للعبة أو الفيديو

class TrainingFormatBottomBar extends StatelessWidget {
  final bool isFormatSelected;
  final VoidCallback onContinue;

  const TrainingFormatBottomBar({
    required this.isFormatSelected,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F4F8),
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: CustomButton(
        title: 'Continue',
        isLoading: false,
        backgroundColor: isFormatSelected
            ? const Color(0xFF4ADE80)
            : Colors.grey[300],
        foregroundColor: isFormatSelected ? Colors.white : Colors.grey[500],
        borderRadius: 16.0,
        onPressed: isFormatSelected ? onContinue : null,
      ),
    );
  }
}
