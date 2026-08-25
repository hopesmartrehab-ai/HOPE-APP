import 'package:flutter/material.dart';

class ClickedWidget extends StatelessWidget {
  const ClickedWidget({super.key, this.child, this.onTap, this.borderRadius});
  final Widget? child;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent, // No focus effect
      splashColor: Colors.transparent, // No splash effect
      hoverColor: Colors.transparent, // No hover effect
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: borderRadius),
        child: child,
      ),
    );
  }
}
