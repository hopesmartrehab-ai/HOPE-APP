import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/app_svg.dart';
import 'package:hope_app/core/shared_widgets/clicked_widget.dart';
import 'package:hope_app/core/theme/styles/app_text_styles.dart';
import 'package:hope_app/core/theme/theme_extension.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onpressed;
  final bool? addAction;
  final VoidCallback? actionOnPressed;
  final Widget? actionWidget;
  final EdgeInsetsGeometry? padding;
  final bool? addPost;
  const DefaultAppBar({
    required this.title,
    this.padding,
    this.actionOnPressed,
    this.addAction,
    this.onpressed,
    this.actionWidget,
    this.addPost = false,
    super.key,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16),
        child: ClickedWidget(
          onTap: onpressed,
          child: addPost == false
              ? Padding(
                  padding: const EdgeInsetsDirectional.all(16.0),
                  child: Transform.flip(
                    flipX: Directionality.of(context) == TextDirection.rtl,
                    child: AppSvg(
                      darkColor: context.darkDarkColor,
                      //
                      assetName: "Assets.assetsIconsArrowBackIcon,"  // =============change the ""=================
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsetsDirectional.only(top: 8),
                  child: AppSvg(
                    width: 32,
                    height: 32,
                    darkColor: context.darkDarkColor,
                    assetName: "Assets.assetsIconsCloseIconLight", // =============change the ""=================
                  ),
                ),
        ),
      ),
      centerTitle: true,
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: context.scaffoldBackgroundColor,
      title: Text(
        title,
        style: Styles.s16(
          context,
        ).copyWith(color: context.darkDarkColor, fontWeight: FontWeight.w700),
      ),
      actions: addAction == true
          ? [
              Padding(
                padding: padding ?? const EdgeInsetsDirectional.all(16.0),
                child: ClickedWidget(
                  onTap: actionOnPressed,
                  child: actionWidget ?? const SizedBox.shrink(),
                ),
              ),
            ]
          : null,
    );
  }
}
