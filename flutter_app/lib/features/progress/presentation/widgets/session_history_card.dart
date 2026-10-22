import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/session_model.dart';

class SessionHistoryCard extends StatelessWidget {
  const SessionHistoryCard({
    required this.session,
    required this.onTap,
    super.key,
  });

  final SessionModel session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCompleted = session.status == SessionStatus.completed;
    final background = isCompleted
        ? const Color(0xFFE3F6EC)
        : const Color(0xFFFDEFD9);
    final foreground = isCompleted
        ? const Color(0xFF2E8555)
        : const Color(0xFFD97706);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE9F0F5),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    session.dateLabel,
                    style: Styles.s12(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (session.isCurrent) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3DAA6B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.s14(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.subtitle.tr(),
                    style: Styles.s12(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (isCompleted
                        ? LocaleKeys.progressCompleted
                        : LocaleKeys.progressPartial)
                    .tr(),
                style: Styles.s10(context).copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
