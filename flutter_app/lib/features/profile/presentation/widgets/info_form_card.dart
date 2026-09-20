import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class InfoFormCard extends StatelessWidget {
  const InfoFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'FULL NAME', value: 'Sarah Johnson'),
          Divider(height: 1, thickness: 1, color: Color(0xFFE7EDF3)),
          _InfoRow(label: 'EMAIL ADDRESS', value: 'sarah.johnson@email.com'),
          Divider(height: 1, thickness: 1, color: Color(0xFFE7EDF3)),
          _InfoRow(label: 'PHONE NUMBER', value: '+1 (555) 234-5678'),
          Divider(height: 1, thickness: 1, color: Color(0xFFE7EDF3)),
          _InfoRow(label: 'DATE OF BIRTH', value: 'March 12, 1985'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              textAlign: TextAlign.left,
              style: Styles.s12(context).copyWith(
                color: const Color(0xFF7A8A9B),
                letterSpacing: 0.8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.left,
              style: Styles.s16(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
