import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class ProfileMenuItem {
  const ProfileMenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final String? trailing;
  final bool isDestructive;
}

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({required this.items, super.key, this.onItemTap});

  final List<ProfileMenuItem> items;
  final void Function(ProfileMenuItem item)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE7F0)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5EBF2)),
        itemBuilder: (context, index) {
          return ProfileMenuRow(
            item: items[index],
            onTap: () => onItemTap?.call(items[index]),
          );
        },
      ),
    );
  }
}

class ProfileMenuRow extends StatelessWidget {
  const ProfileMenuRow({required this.item, super.key, this.onTap});

  final ProfileMenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final rowColor = item.isDestructive
        ? const Color(0xFFC9372C)
        : AppColors.primary;

    final isPersonalInfo = item.label == 'Personal Information';

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: item.isDestructive
                    ? const Color(0x1AC9372C)
                    : const Color(0x1A1A4663),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.icon, size: 18, color: rowColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: Styles.s14(
                  context,
                ).copyWith(color: rowColor, fontWeight: FontWeight.w500),
              ),
            ),
            if (item.trailing != null)
              Text(
                item.trailing!,
                style: Styles.s14(
                  context,
                ).copyWith(color: AppColors.textSecondary),
              ),
            if (item.trailing == null && !isPersonalInfo)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            if (item.trailing == null && isPersonalInfo)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
