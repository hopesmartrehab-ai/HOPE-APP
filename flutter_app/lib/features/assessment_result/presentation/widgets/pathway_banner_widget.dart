import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.dart';
import '../../domain/entities/rehab_pathway.dart';
import '../logic/rehab_pathway_ui.dart';

/// Headline card naming the care pathway the assessment recommends.
class PathwayBannerWidget extends StatelessWidget {
  const PathwayBannerWidget({required this.pathway, super.key});

  final RehabPathway pathway;

  @override
  Widget build(BuildContext context) {
    final accent = pathway.accentColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(pathway.icon, color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  LocaleKeys.recommendedPathTag.tr(),
                  style: const TextStyle(
                    color: Color(0xFF86A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            pathway.titleKey.tr(),
            style: const TextStyle(
              color: Color(0xFF15314B),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pathway.followUpKey.tr(),
            style: TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            pathway.descriptionKey.tr(),
            style: const TextStyle(
              color: Color(0xFF6B8296),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
