import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tara_car/core/theme/theme_extension.dart';

class CustomNetworkImage extends StatelessWidget {
  final Widget? errorWidget;

  const CustomNetworkImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.borderRadiusGeometry,
    this.errorWidget,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadiusGeometry;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          borderRadiusGeometry ?? BorderRadius.circular(borderRadius ?? 12),

      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width ?? 75,
        height: height ?? 85,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Center(
          child: LoadingAnimationWidget.dotsTriangle(
            color: context.primaryColor,
            size: 30,
          ),
        ),
        errorWidget: (context, url, error) => errorWidget ?? Container(
          width: width ?? 75,
          height: height ?? 85,
          decoration: BoxDecoration(
            color: context.lightGray.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          child: Icon(Icons.error, size: 30, color: context.lightGray),
        ),
      ),
    );
  }
}
