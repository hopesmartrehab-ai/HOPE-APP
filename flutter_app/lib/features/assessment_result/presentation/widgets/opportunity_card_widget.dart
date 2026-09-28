import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/locale_keys.dart';

class OpportunityCardWidget extends StatelessWidget {
  const OpportunityCardWidget({required this.opportunityText, super.key});

  final String opportunityText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF9F1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD6EBDC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF59C583),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.opportunityTitle.tr(),
                style: const TextStyle(
                  color: Color(0xFF2A7C4B),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.opportunityDesc.tr(args: [opportunityText]),
            style: const TextStyle(
              color: Color(0xFF4A6B56),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
