import 'package:flutter/material.dart';

import '../../domain/entities/rehab_pathway.dart';

/// Presentation details for [RehabPathway].
///
/// Kept as an extension so the entity itself stays free of Flutter types.
extension RehabPathwayUi on RehabPathway {
  IconData get icon {
    switch (this) {
      case RehabPathway.online:
        return Icons.laptop_mac_rounded;
      case RehabPathway.hybrid:
        return Icons.sync_alt_rounded;
      case RehabPathway.rehabCenter:
        return Icons.local_hospital_rounded;
    }
  }

  /// Accent used for the pathway's follow-up line.
  Color get accentColor {
    switch (this) {
      case RehabPathway.online:
        return const Color(0xFF59C583);
      case RehabPathway.hybrid:
        return const Color(0xFFE8A33D);
      case RehabPathway.rehabCenter:
        return const Color(0xFF5B9BD5);
    }
  }
}
