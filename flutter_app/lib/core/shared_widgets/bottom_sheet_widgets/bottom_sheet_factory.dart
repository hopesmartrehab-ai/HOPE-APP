import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tara_car/core/constants/assets_constants.dart';
import 'package:tara_car/core/constants/locale_keys.dart';
import 'package:tara_car/core/enums/bottom_sheet.dart';
import 'package:tara_car/core/shared_widgets/bottom_sheet_widgets/base_bottom_sheet.dart';
import 'package:tara_car/core/shared_widgets/bottom_sheet_widgets/bottom_sheet_config.dart';
import 'package:tara_car/core/shared_widgets/bottom_sheet_widgets/sort_sheet_content.dart';
import 'package:tara_car/feature/more/presentation/widgets/account/delete_account_password_sheet_content.dart';
import 'package:tara_car/feature/more/presentation/widgets/account/delete_sheet_content.dart';
import 'package:tara_car/feature/more/presentation/widgets/ads/ad_options_sheet_content.dart';
import 'package:tara_car/feature/more/presentation/widgets/sections/log_out_section.dart';
import 'package:tara_car/feature/more/presentation/widgets/settings/language_sheet_content.dart';
import 'package:tara_car/feature/post_ad/presentation/widgets/color_bottom_sheet_content.dart';
import 'package:tara_car/feature/shared_screen/product_details/widgets/price_inquiry_bottom_sheet_content.dart';

//This is the factory class for the bottom sheet
//It is used to show the bottom sheet
class BottomSheetFactory {
  static Future<void> show(BuildContext context, BottomSheetConfig config) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return BaseBottomSheet(
          showHandle: config.showHandle,
          heightFraction: config.heightFraction,
          contentPadding: _getContentPadding(config.type),
          onDismiss: config.onDismiss,
          content: _buildContent(config),
        );
      },
    );
  }

  static Widget _buildContent(BottomSheetConfig config) {
    switch (config.type) {
      case BottomSheetType.sort:
        return SortSheetContent(
          items: config.params['items'] as List<String>,
          initialIndex: config.params['initialIndex'] as int? ?? 0,
          onSelected: config.params['onSelected'] as ValueChanged<int>,
        );

      case BottomSheetType.adOptions:
        return AdOptionsSheetContent(
          onEdit: config.params['onEdit'] as VoidCallback,
          onViewDetails: config.params['onViewDetails'] as VoidCallback,
          onMarkAsSold: config.params['onMarkAsSold'] as VoidCallback,
          onDelete: config.params['onDelete'] as VoidCallback,
        );

      case BottomSheetType.deleteAccount:
        return DeleteSheetContent(
          title: LocaleKeys.deleteAccount.tr(),
          description: LocaleKeys.deleteAccountDescription.tr(),
          iconPath: Assets.assetsIconsDeleteAccountIcon,
          deleteButtonLabel: LocaleKeys.deleteAccount.tr(),
          cancelButtonLabel: LocaleKeys.cancel.tr(),
          onDelete: config.params['onDelete'] as VoidCallback,
        );
      case BottomSheetType.deleteAccountPassword:
        return DeleteAccountPasswordSheetContent(
          onDelete: config.params['onDelete'] as ValueChanged<String>,
        );

      case BottomSheetType.delete:
        return DeleteSheetContent(
          title: config.params['title'] as String? ?? 'Delete',
          description:
              config.params['description'] as String? ?? 'Are you sure?',
          iconPath:
              config.params['iconPath'] as String? ??
              Assets.assetsIconsTrashIcon,
          deleteButtonLabel:
              config.params['deleteLabel'] as String? ?? 'Delete',
          cancelButtonLabel:
              config.params['cancelLabel'] as String? ?? 'Cancel',
          onDelete: config.params['onDelete'] as VoidCallback,
        );
      case BottomSheetType.language:
        return LanguageSheetContent(
          initialIndex: config.params['initialIndex'] as int? ?? 0,
          title: LocaleKeys.changeLanguage.tr(),
          description: LocaleKeys.choosePreferredLanguage.tr(),
          iconPath: Assets.assetsIconsLanguageIcon,
          onSelected: config.params['onSelected'] as ValueChanged<int>,
        );
      case BottomSheetType.logout:
        return LogOutSheetContent(
          title: LocaleKeys.logout.tr(),
          description: LocaleKeys.logoutConfirmation.tr(),
          iconPath: Assets.assetsIconsDeleteAccountIcon,
          logoutButtonLabel: LocaleKeys.logout.tr(),
          cancelButtonLabel: LocaleKeys.cancel.tr(),
          onLogout: config.params['onLogout'] as VoidCallback,
        );
      case BottomSheetType.color:
        return ColorBottomSheetContent(
          initialIndex: config.params['initialIndex'] as int,
          onSelected: config.params['onSelected'] as ValueChanged<int>,
        );
      case BottomSheetType.priceInquiry:
        return const PriceInquiryBottomSheetContent();
    }
  }

  static EdgeInsetsGeometry? _getContentPadding(BottomSheetType type) {
    switch (type) {
      case BottomSheetType.sort:
        return const EdgeInsets.symmetric(horizontal: 16);
      case BottomSheetType.adOptions:
        return const EdgeInsets.symmetric(horizontal: 16);
      case BottomSheetType.deleteAccount:
      case BottomSheetType.deleteAccountPassword:
      case BottomSheetType.delete:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case BottomSheetType.language:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case BottomSheetType.logout:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case BottomSheetType.color:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case BottomSheetType.priceInquiry:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    }
  }
}
