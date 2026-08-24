import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/locale_keys.dart';
import 'api_message_localizer.dart';
import '../local_storage/local_storage.dart';
import '../shared_widgets/error_toast.dart';
import '../shared_widgets/info_toast.dart';
import '../shared_widgets/success_toast.dart';

abstract class AppHelper {
  AppHelper._();
  static void errorSnackBar({
    required BuildContext context,
    required String message,
  }) {
    return showErrorToast(message, context);
  }

  static void successSnackBar({
    required BuildContext context,
    required String message,
  }) {
    return showSuccessToast(
      ApiMessageLocalizer.localize(message),
      context,
      delay: 1,
    );
  }

  static void infoSnackBar({
    required BuildContext context,
    required String message,
  }) {
    return showInfoToast(message, context);
  }

  static Future<void> makeAphoneCall({required String phoneNumber}) async {
    // Ensure the phone number is properly formatted
    // if (phoneNumber.startsWith('+20')) {
    //   phoneNumber = phoneNumber.substring(
    //     3,
    //   ); // Remove +965 if it's already there
    // }

    // // Add +965 if it's missing
    // final String formattedNumber = '+20$phoneNumber';

    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  static Future<void> openUrl({required String url}) async {
    final Uri launchUri = Uri.parse(url); // Parse the URL
    if (await canLaunchUrl(launchUri)) {
      debugPrint('Launching URL: $url');
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch URL: $url');
      throw 'Could not launch $url';
    }
  }

  static Future<void> openWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'wa.me', // WhatsApp's URL scheme
      path:
          phoneNumber, // Phone number in international format without '+' or special characters
      queryParameters: message != null ? {'text': message} : null,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp with number $phoneNumber';
    }
  }

  static bool isArabic() {
    return LocalStorage.getLocaleLanguage() == 'ar';
  }

  // /// Function to show this bottom sheet
  // static void showButtomSheet(
  //   BuildContext context,
  //   Widget child, {
  //   bool isDismissible = true,
  // }) {
  //   showModalBottomSheet(
  //     context: context,
  //     isDismissible: isDismissible,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(32),
  //         topRight: Radius.circular(32),
  //       ),
  //     ),
  //     isScrollControlled: true, // Allow full-height content if needed
  //     backgroundColor: context.scaffoldBackgroundColor,
  //     builder: (context) => CustomBottomSheet(child: child),
  //   );
  // }

  /// Check if the device is a tablet (Android) or iPad (iOS)
  /// Returns true if the device is a tablet/iPad, false otherwise
  static bool isTablet(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double shortestSide = mediaQuery.size.shortestSide;
    // Tablets typically have a minimum width of 600dp
    // This works for both Android tablets and iPads
    return shortestSide >= 600;
  }

  static Future<void> shareUserNameAndPassword({
    required BuildContext context,
    required String? username,
    required String? password,
  }) async {
    final String usernameString = (username ?? '').trim();
    final String passwordString = (password ?? '').trim();

    // Avoid sharing an empty payload.
    if (usernameString.isEmpty && passwordString.isEmpty) {
      showErrorToast(
        LocaleKeys.completeDataBeforeSharing.tr(),
        context,
        title: LocaleKeys.sharingUnavailable.tr(),
      );
      return;
    }

    final text =
        '${LocaleKeys.userName.tr()}: ${usernameString.isEmpty ? '—' : usernameString}\n'
        '${LocaleKeys.password.tr()}: ${passwordString.isEmpty ? '—' : passwordString}';

    await SharePlus.instance.share(
      ShareParams(text: text, subject: LocaleKeys.userNameAndPassword.tr()),
    );
  }

  /// Get a setting value by key from local storage.
  /// Returns the value as a [String], or [defaultValue] if not found.
  // static String getSettingValue(String key, {String defaultValue = ''}) {
  //   return LocalStorage.getSettingValue(key) ?? defaultValue;
  // }

  // /// Get a setting value as a [bool].
  // /// Values like "true", "1", "yes" are treated as true.
  // static bool getSettingBool(String key, {bool defaultValue = false}) {
  //   final value = LocalStorage.getSettingValue(key);
  //   if (value == null) return defaultValue;
  //   return value == 'true' || value == '1' || value == 'yes';
  // }

  // /// Get a setting value as an [int].
  // static int? getSettingInt(String key) {
  //   final value = LocalStorage.getSettingValue(key);
  //   if (value == null) return null;
  //   return int.tryParse(value);
  // }

  // /// Get a setting value as a [double].
  // static double getSettingDouble(String key, {double defaultValue = 0.0}) {
  //   final value = LocalStorage.getSettingValue(key);
  //   if (value == null) return defaultValue;
  //   return double.tryParse(value) ?? defaultValue;
  // }

  // static int? getFreeMaxCompanies() {
  //   if (isFreePlan()) return null;
  //   return getSettingInt('free_max_companies');
  // }

  // static int? getFreeMaxDepartments() {
  //   if (isFreePlan()) return null;
  //   return getSettingInt('free_max_departments');
  // }

  // static int? getFreeMaxEmployees() {
  //   if (isFreePlan()) return null;
  //   return getSettingInt('free_max_employees');
  // }

  // static String? getContactNumber() {
  //   return getSettingValue('contact_number');
  // }

  // static UserType getUserType() {
  //   final userModule = LocalStorage.getUser();
  //   if (userModule?.role == 'HR') {
  //     return UserType.hrManager;
  //   } else if (userModule?.role == 'EMPLOYEE') {
  //     return UserType.employee;
  //   } else {
  //     return UserType.hrManager;
  //   }
  // }

  // static bool isFreePlan() {
  //   final userModule = LocalStorage.getUser();
  //   return userModule?.isActive == false;
  // }
}
