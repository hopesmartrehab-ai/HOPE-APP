import 'package:flutter/material.dart';
import 'package:hope_app/core/theme/styles/app_colors.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';

class AffectedSideSelector extends StatefulWidget {
  const AffectedSideSelector({super.key});

  @override
  State<AffectedSideSelector> createState() => _AffectedSideSelectorState();
}

class _AffectedSideSelectorState extends State<AffectedSideSelector> {
  String _selectedSide = 'Right Hand';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSide = 'Left Hand'),
              child: _SideChip(
                label: 'Left Hand',
                selected: _selectedSide == 'Left Hand',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSide = 'Right Hand'),
              child: _SideChip(
                label: 'Right Hand',
                selected: _selectedSide == 'Right Hand',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSide = 'Both'),
              child: _SideChip(
                label: 'Both',
                selected: _selectedSide == 'Both',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideChip extends StatelessWidget {
  const _SideChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEAF8F0) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? const Color(0xFF4CAF50) : const Color(0xFFE2EAF2),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: Styles.s14(context).copyWith(
            color: selected ? const Color(0xFF2E7D32) : AppColors.primary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
