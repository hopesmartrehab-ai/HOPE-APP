import '../../../../core/constants/locale_keys.dart';

/// How the patient continues their rehabilitation after the assessment.
///
/// Decided by the backend and delivered as the `pathway` field, whose known
/// values are `Online`, `Hybrid` and `RehabCenter`.
enum RehabPathway {
  online,
  hybrid,
  rehabCenter;

  /// Parses the server value.
  ///
  /// Anything unrecognised — a missing field, or a pathway added on the server
  /// before the app knows about it — falls back to [online] so an unknown value
  /// can never break the results screen.
  static RehabPathway fromApi(Object? value) {
    switch (value?.toString().trim().toLowerCase().replaceAll('_', '')) {
      case 'hybrid':
        return RehabPathway.hybrid;
      case 'rehabcenter':
      case 'center':
      case 'centre':
        return RehabPathway.rehabCenter;
      default:
        return RehabPathway.online;
    }
  }

  /// Locale key for the pathway's name.
  String get titleKey {
    switch (this) {
      case RehabPathway.online:
        return LocaleKeys.pathwayOnlineTitle;
      case RehabPathway.hybrid:
        return LocaleKeys.pathwayHybridTitle;
      case RehabPathway.rehabCenter:
        return LocaleKeys.pathwayRehabCenterTitle;
    }
  }

  /// Locale key for the short follow-up line under the pathway name.
  String get followUpKey {
    switch (this) {
      case RehabPathway.online:
        return LocaleKeys.pathwayOnlineFollowUp;
      case RehabPathway.hybrid:
        return LocaleKeys.pathwayHybridFollowUp;
      case RehabPathway.rehabCenter:
        return LocaleKeys.pathwayRehabCenterFollowUp;
    }
  }

  /// Locale key for the paragraph explaining what the pathway means.
  String get descriptionKey {
    switch (this) {
      case RehabPathway.online:
        return LocaleKeys.pathwayOnlineDesc;
      case RehabPathway.hybrid:
        return LocaleKeys.pathwayHybridDesc;
      case RehabPathway.rehabCenter:
        return LocaleKeys.pathwayRehabCenterDesc;
    }
  }
}
