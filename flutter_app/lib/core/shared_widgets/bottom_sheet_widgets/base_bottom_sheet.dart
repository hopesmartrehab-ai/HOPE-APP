import 'package:flutter/material.dart';
import 'package:tara_car/core/shared_widgets/clicked_widget.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

// This is a base widget for all bottom sheets
class BaseBottomSheet extends StatelessWidget {
  final Widget content;
  final bool showHandle;
  final double heightFraction;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onDismiss;

  const BaseBottomSheet({
    required this.content,
    this.showHandle = true,
    this.heightFraction = 0.6,
    this.contentPadding,
    this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClickedWidget(
      onTap: () {},
      child: Container(
        constraints: BoxConstraints(
          //This is the height of the bottom sheet
          maxHeight: MediaQuery.of(context).size.height * heightFraction,
        ),
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          //This is the border radius of the bottom sheet
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHandle) ...[
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.lightGray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                //This is the padding of the bottom sheet content
                padding: contentPadding ?? const EdgeInsetsDirectional.all(16),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
