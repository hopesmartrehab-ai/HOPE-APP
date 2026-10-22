import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/features/progress/data/models/therapist_note_model.dart';

class TherapistNoteCard extends StatelessWidget {
  const TherapistNoteCard({required this.note, super.key});

  final TherapistNoteModel note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC7E6D3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.progressTherapistNote.tr(),
            style: Styles.s14(context).copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D4E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            note.note.tr(),
            style: Styles.s12(context).copyWith(
              color: const Color(0xFF334E3F),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '— ${note.therapistName} · ${note.reviewedDate}',
            style: Styles.s10(context).copyWith(
              color: const Color(0xFF5E8570),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
