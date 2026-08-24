import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/shared_widgets/car_property_widget/custom_text_title.dart';
import 'package:tara_car/core/shared_widgets/custom_drop_down.dart';

class LocationFilterSection extends StatefulWidget {
  final String? sectionNumber;
  const LocationFilterSection({this.sectionNumber, super.key});

  @override
  State<LocationFilterSection> createState() => _LocationFilterSectionState();
}

class LocationData {
  final String name;
  final List<String> areas;

  LocationData({required this.name, required this.areas});
}

class _LocationFilterSectionState extends State<LocationFilterSection> {
  final List<LocationData> locations = [
    LocationData(name: 'Cairo', areas: ['Maadi', 'Nasr City', 'New Cairo']),
    LocationData(
      name: 'Giza',
      areas: ['Dokki', '6th of October', 'Sheikh Zayed'],
    ),
    LocationData(
      name: 'Alexandria',
      areas: ['Downtown', 'Montaza', 'Sidi Bishr'],
    ),
  ];

  String? selectedGovId;
  String? selectedAreaId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextTitle(
          text: widget.sectionNumber != null
              ? "${widget.sectionNumber}${LocaleKeys.locationHeader.tr()}"
              : LocaleKeys.locationHeader.tr(),
          isSectionTitle: true,
        ),
        const SizedBox(height: 24),
        CustomDropDown<LocationData>(
          items: locations,
          hintText: LocaleKeys.governorate.tr(),
          titleExtractor: (location) => location.name,
          idExtractor: (location) => location.name,
          selectedId: selectedGovId,
          onSelected: (govId) {
            setState(() {
              selectedGovId = govId;
              selectedAreaId = null;
            });
          },
          onClear: () {
            setState(() {
              selectedGovId = null;
              selectedAreaId = null;
            });
          },
        ),
        const SizedBox(height: 12),
        CustomDropDown<String>(
          items: selectedGovId != null
              ? locations.firstWhere((loc) => loc.name == selectedGovId).areas
              : [],
          hintText: LocaleKeys.area.tr(),
          titleExtractor: (area) => area,
          idExtractor: (area) => area,
          selectedId: selectedAreaId,
          isAcceptEdits: selectedGovId != null,
          onSelected: (areaId) {
            setState(() {
              selectedAreaId = areaId;
            });
          },
          onClear: () {
            setState(() {
              selectedAreaId = null;
            });
          },
        ),
      ],
    );
  }
}
