import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope_app/core/theme/theme_extension.dart';

import '../theme/styles/app_text_styles.dart';
import 'custom_button.dart';

class WarningBottomSheet extends StatelessWidget {
  const WarningBottomSheet({
    required this.title,
    required this.description,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.firstButtonOnPressed,
    required this.secondButtonOnPressed,
    required this.image,
    super.key,
  });
  final String title;
  final String description;
  final String firstButtonText;
  final String secondButtonText;
  final VoidCallback firstButtonOnPressed;
  final VoidCallback secondButtonOnPressed;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 4,
                color: context.buttomSheetTopColor,
                width: 65,
              ),
            ),
            const SizedBox(height: 16),
            SvgPicture.asset(image),
            const SizedBox(height: 16),
            Text(title, style: Styles.s16(context)),
            const SizedBox(height: 8),
            Text(
              description,
              style: Styles.s14(context).copyWith(color: context.textHintBold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              title: firstButtonText,
              isLoading: false,
              isBackgroundPrimary: true,
              onPressed: firstButtonOnPressed,
            ),
            const SizedBox(height: 16),
            CustomButton(
              title: secondButtonText,
              isLoading: false,
              isBackgroundPrimary: true,
              isStroked: true,
              onPressed: secondButtonOnPressed,
            ),
          ],
        ),
      ),
    );
  }
}
