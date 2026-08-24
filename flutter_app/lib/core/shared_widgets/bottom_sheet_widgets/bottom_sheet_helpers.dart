import 'package:flutter/material.dart';
import 'package:tara_car/core/enums/bottom_sheet.dart';
import 'package:tara_car/core/shared_widgets/bottom_sheet_widgets/bottom_sheet_config.dart';
import 'package:tara_car/core/shared_widgets/bottom_sheet_widgets/bottom_sheet_factory.dart';

/// Sort bottom sheet
Future<void> showSortBottomSheet({
  required BuildContext context,
  required List<String> items,
  required int initialIndex,
  required ValueChanged<int> onSelected,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.sort,
      heightFraction: 0.75,
      params: {
        'items': items,
        'initialIndex': initialIndex,
        'onSelected': onSelected,
      },
      onDismiss: onDismiss,
    ),
  );
}

/// Ad options bottom sheet
Future<void> showAdOptionsBottomSheet({
  required BuildContext context,
  required VoidCallback onEdit,
  required VoidCallback onViewDetails,
  required VoidCallback onMarkAsSold,
  required VoidCallback onDelete,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.adOptions,
      heightFraction: 0.5,
      params: {
        'onEdit': onEdit,
        'onViewDetails': onViewDetails,
        'onMarkAsSold': onMarkAsSold,
        'onDelete': onDelete,
      },
      onDismiss: onDismiss,
    ),
  );
}

/// Delete account bottom sheet
Future<void> showDeleteAccountBottomSheet({
  required BuildContext context,
  required VoidCallback onDelete,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.deleteAccount,
      heightFraction: 0.5,
      params: {'onDelete': onDelete},
      onDismiss: onDismiss,
    ),
  );
}

Future<void> showDeleteAccountPasswordBottomSheet({
  required BuildContext context,
  required ValueChanged<String> onDelete,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.deleteAccountPassword,
      heightFraction: 0.58,
      params: {'onDelete': onDelete},
      onDismiss: onDismiss,
    ),
  );
}

Future<void> showLanguageBottomSheet({
  required BuildContext context,
  required int initialIndex,
  required ValueChanged<int> onSelected,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.language,
      heightFraction: 0.5,
      params: {'initialIndex': initialIndex, 'onSelected': onSelected},
      onDismiss: onDismiss,
    ),
  );
}

/// Generic delete confirmation bottom sheet
Future<void> showDeleteConfirmationBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
  required VoidCallback onDelete,
  String? iconPath,
  String? deleteLabel,
  String? cancelLabel,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.delete,
      heightFraction: 0.5,
      params: {
        'title': title,
        'description': description,
        'iconPath': iconPath,
        'deleteLabel': deleteLabel,
        'cancelLabel': cancelLabel,
        'onDelete': onDelete,
      },
      onDismiss: onDismiss,
    ),
  );
}

/// Logout bottom sheet
Future<void> showLogoutBottomSheet({
  required BuildContext context,
  required VoidCallback onLogout,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.logout,
      heightFraction: 0.5,
      params: {'onLogout': onLogout},
      onDismiss: onDismiss,
    ),
  );
}

/// Color selection bottom sheet
Future<void> showColorBottomSheet({
  required BuildContext context,
  required int initialIndex,
  required ValueChanged<int> onSelected,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.color,
      heightFraction: 0.7,
      params: {'initialIndex': initialIndex, 'onSelected': onSelected},
      onDismiss: onDismiss,
    ),
  );
}

/// Price inquiry bottom sheet
Future<void> showPriceInquiryBottomSheet({
  required BuildContext context,
  required VoidCallback onSend,
  VoidCallback? onDismiss,
}) {
  return BottomSheetFactory.show(
    context,
    BottomSheetConfig(
      type: BottomSheetType.priceInquiry,
      heightFraction: 0.8,
      params: {'onSend': onSend},
      onDismiss: onDismiss,
    ),
  );
}
