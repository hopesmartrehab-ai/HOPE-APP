import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope_app/core/theme/logic/theme_cubit.dart';

class AppSvg extends StatelessWidget {
  final String assetName;
  final Color? darkColor;
  final Color? lightColor;
  final double? width;
  final double? height;

  const AppSvg({
    required this.assetName,
    super.key,
    this.lightColor,
    this.darkColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().isDarkMode;

    final Color? appliedColor = isDark ? darkColor : lightColor;

    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: appliedColor != null
          ? ColorFilter.mode(appliedColor, BlendMode.srcIn)
          : null,
    );
  }
}
