import 'package:flutter/material.dart';

class SharedSessionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SharedSessionAppBar({
    required this.currentPage,
    required this.onBack,
    super.key,
  });

  final int currentPage;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 90,
      leading: TextButton.icon(
        onPressed: onBack,
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 16,
          color: Color(0xFF1E3A5F),
        ),
        label: const Text(
          'Back',
          style: TextStyle(
            color: Color(0xFF1E3A5F),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      title: null,
      centerTitle: true,
    );
  }
}
