import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/features/profile/models/profile_models.dart';
import 'package:hope_app/features/profile/presentation/widgets/personal_info/affected_side_selector.dart';
import 'package:hope_app/features/profile/presentation/widgets/personal_info/info_form_card.dart';
import 'package:hope_app/features/profile/presentation/widgets/personal_info/personal_info_header.dart';
import 'package:hope_app/features/profile/presentation/widgets/personal_info/personal_info_section_title.dart';
import 'package:hope_app/features/profile/presentation/widgets/personal_info/user_avatar_card.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key, this.model});

  final PersonalInfoModel? model;

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  @override
  Widget build(BuildContext context) {
    final model =
        widget.model ??
        const PersonalInfoModel(
          fullName: 'Sarah Johnson',
          email: 'sarah.johnson@email.com',
          phoneNumber: '+1 (555) 234-5678',
          dateOfBirth: 'March 12, 1985',
          therapistName: 'Dr. Amina Hassan',
          therapistRole: 'Rehabilitation Specialist',
          affectedSide: 'Right Side',
          initials: 'SJ',
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PersonalInfoHeader(
                  onBack: () => Navigator.of(context).pop(),
                  onEdit: () {},
                ),
                const SizedBox(height: 20),
                const PersonalInfoTitleRow(onEdit: null),
                const SizedBox(height: 24),
                UserAvatarCard(initials: model.initials),
                const SizedBox(height: 22),
                InfoFormCard(
                  fullName: model.fullName,
                  email: model.email,
                  phoneNumber: model.phoneNumber,
                  dateOfBirth: model.dateOfBirth,
                ),
                const SizedBox(height: 18),
                PersonalInfoSectionTitle(
                  title: LocaleKeys.assignedTherapist.tr().toUpperCase(),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2EAF2)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 12,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7E8C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 22,
                          color: Color(0xFF8C6A20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.therapistName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              model.therapistRole,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                PersonalInfoSectionTitle(
                  title: LocaleKeys.affectedSide.tr().toUpperCase(),
                ),
                const SizedBox(height: 10),
                AffectedSideSelector(selectedSide: model.affectedSide),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
