import 'package:easy_localization/easy_localization.dart';

import '../constants/locale_keys.dart';

abstract class AppValidators {
  AppValidators._();

  static bool isEmail(String email) => RegExp(
    "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$",
  ).hasMatch(email);

  static String? isValidEmail(String? email) {
    if (email?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    }
    if (RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$",
    ).hasMatch(email ?? "")) {
      return null;
    }
    return LocaleKeys.thisNotEmail.tr();
  }

  static String? isNotEmptyValidator(String? title) {
    if (title?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    }
    return null;
  }

  static String? isNumberValidator(String? title) {
    if (title?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    }
    if ((num.tryParse(title ?? "") ?? 0.0).isNegative) {
      return LocaleKeys.thisFieldIsNotMinusOrZero.tr();
    }
    return null;
  }

  static String? isValidPrice(String? title) {
    if (title?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    } else if ((num.tryParse(title ?? "0") ?? 0) <= 0) {
      return LocaleKeys.thisFieldIsNotMinusOrZero.tr();
    }
    return null;
  }

  static String? isValidPassword(String? password) {
    if (password?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    } else if ((password?.length ?? 0) < 8) {
      return LocaleKeys.passwordMinEight.tr();
    }
    return null;
  }

  static String? isValidConfirmPassword(
    String password,
    String? confirmPassword,
  ) {
    if (confirmPassword?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    } else if (confirmPassword != password) {
      return LocaleKeys.passwordNoCorrect.tr();
    }
    return null;
  }

  static String? isValidSaudiPhone(String? phoneNumber) {
    if (phoneNumber?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    }

    // Saudi phone number regex: Starts with 05 and has a total of 10 digits
    final RegExp saudiPhoneRegex = RegExp(r'^05\d{8}$');

    if (!saudiPhoneRegex.hasMatch(phoneNumber!)) {
      return LocaleKeys.invalidPhoneNumber.tr();
    }

    return null; // Valid number
  }

  static String? isValidEgyptianPhone(String? phoneNumber) {
    if (phoneNumber?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    }
    if (!RegExp(
      r'^(010|011|012|015|10|11|12|15)\d{8}$',
    ).hasMatch(phoneNumber!)) {
      return LocaleKeys.invalidPhoneNumber.tr();
    }
    return null;
  }

  static String? isValidCode(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return null;
  }
}
/* static String? isValidEgyptianPhone(String? phoneNumber) {
    if (phoneNumber?.isEmpty ?? true) {
      return LocaleKeys.thisFieldIsRequired.tr();
    }

    // Egyptian phone: starts with 010, 011, 012, or 015 and is 11 digits total
    if (!RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(phoneNumber!)) {
      return LocaleKeys.invalidPhoneNumber.tr();
    }

    return null;
  }*/