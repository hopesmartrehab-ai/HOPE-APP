import 'package:easy_localization/easy_localization.dart';
import 'package:tara_car/core/constants/locale_keys.dart';

abstract class ApiMessageLocalizer {
  ApiMessageLocalizer._();

  static String localize(String message) {
    return switch (message.trim()) {
      'OTP sent' => LocaleKeys.otpSent.tr(),
      'Invalid credentials' => LocaleKeys.invalidCredentials.tr(),
      'Phone already registered' => LocaleKeys.phoneAlreadyRegistered.tr(),
      'Invalid or expired OTP' => LocaleKeys.invalidOrExpiredOtp.tr(),
      'Invalid OTP' => LocaleKeys.invalidOtp.tr(),
      'No account with that phone' => LocaleKeys.noAccountWithThatPhone.tr(),
      'OTP verified' => LocaleKeys.otpVerified.tr(),
      'Password reset' => LocaleKeys.passwordReset.tr(),
      'Invalid or expired reset token' =>
        LocaleKeys.invalidOrExpiredResetToken.tr(),
      'phone must be a valid international phone number' =>
        LocaleKeys.invalidPhoneNumber.tr(),
      _ => message,
    };
  }
}
