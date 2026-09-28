import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/locale_keys.dart';
import '../../../core/utils/app_route.dart';
import 'widgets/recovery_timeline_item_widget.dart';

class PotentialRecoveryPage extends StatelessWidget {
  const PotentialRecoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF6B8296),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: -8,
        title: Text(
          LocaleKeys.back.tr(),
          style: const TextStyle(
            color: Color(0xFF6B8296),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.recoveryTimeline.tr(),
                            style: const TextStyle(
                              color: Color(0xFF15314B),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 24),
                          RecoveryTimelineItemWidget(
                            title: LocaleKeys.weeks1_4.tr(),
                            desc: LocaleKeys.weeks1_4Desc.tr(),
                            color: const Color(0xFF4A80A3),
                          ),
                          RecoveryTimelineItemWidget(
                            title: LocaleKeys.weeks4_8.tr(),
                            desc: LocaleKeys.weeks4_8Desc.tr(),
                            color: const Color(0xFF59C583),
                          ),
                          RecoveryTimelineItemWidget(
                            title: LocaleKeys.weeks8_12.tr(),
                            desc: LocaleKeys.weeks8_12Desc.tr(),
                            color: const Color(0xFF59C583),
                          ),
                          RecoveryTimelineItemWidget(
                            title: LocaleKeys.months3Plus.tr(),
                            desc: LocaleKeys.months3PlusDesc.tr(),
                            color: const Color(0xFF15314B),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF9F1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFD6EBDC)),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Color(0xFF4A6B56),
                            fontSize: 13,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: LocaleKeys.recoveryAlertBold.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: LocaleKeys.recoveryAlertText.tr()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      AppRoute.goToPersonalizedPlan(context: context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF59C583),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    LocaleKeys.seeMyRehabilitationPlan.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
