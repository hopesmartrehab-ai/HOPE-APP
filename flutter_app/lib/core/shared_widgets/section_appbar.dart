import 'package:flutter/material.dart';
import 'package:tara_car/core/theme/styles/app_text_styles.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class SectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onpressed;
  const SectionAppBar({required this.title, this.onpressed, super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: context.primaryColor,
      title: Text(
        title,
        style: Styles.s24(context).copyWith(
          color: context.lightLightnessColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
