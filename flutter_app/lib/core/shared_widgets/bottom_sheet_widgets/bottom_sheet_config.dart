import 'package:flutter/material.dart';
import 'package:tara_car/core/enums/bottom_sheet.dart';

//This is the config class for the bottom sheet
class BottomSheetConfig {
  final BottomSheetType type;
  //This is the height of the bottom sheet
  final double heightFraction;
  //This is the handle of the bottom sheet
  final bool showHandle;
  //This is the params of the bottom sheet
  final Map<String, dynamic> params;
  //This is the onDismiss of the bottom sheet
  final VoidCallback? onDismiss;

  BottomSheetConfig({
    required this.type,
    required this.params,
    this.heightFraction = 0.6,
    this.showHandle = true,
    this.onDismiss,
  });
}
