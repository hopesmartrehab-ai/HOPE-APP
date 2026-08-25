import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_constant_keys.dart';

abstract class LocalStorage {
  static SharedPreferences? local;
  static FlutterSecureStorage? flutterSecureStorage;

  static Future<void> init() async {
    local = await SharedPreferences.getInstance();
    flutterSecureStorage = const FlutterSecureStorage();
  }

  static Future<void> setUserToken(String value) async {
    await flutterSecureStorage?.write(key: StorageKeys.userToken, value: value);
  }

  static Future<String> getUserToken() async {
    try {
      return await flutterSecureStorage?.read(key: StorageKeys.userToken) ?? '';
    } catch (_) {
      // A token encrypted with an old device key cannot be used safely.
      // Treat it as a logged-out session instead of blocking authenticated calls.
      try {
        await flutterSecureStorage?.delete(key: StorageKeys.userToken);
      } catch (_) {}
      return '';
    }
  }

  static Future<void> deleteUserToken() async {
    await flutterSecureStorage?.delete(key: StorageKeys.userToken);
  }

  static Future<void> setCacheString({
    required String key,
    required String value,
  }) async {
    await local?.setString(key, value);
  }

  static String? getCacheString({required String key}) {
    return local?.getString(key);
  }

  static Future<void> setCacheBool({
    required String key,
    required bool value,
  }) async {
    await local?.setBool(key, value);
  }

  static bool? getCacheBool({required String key}) {
    return local?.getBool(key);
  }

  static Future<void> setCacheStringList({
    required String key,
    required List<String> value,
  }) async {
    await local?.setStringList(key, value);
  }

  static List<String> getCacheStringList({required String key}) {
    return local?.getStringList(key) ?? [];
  }

  static Future<void> setCacheJson({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    await local?.setString(key, jsonEncode(value));
  }

  static Map<String, dynamic>? getCacheJson({required String key}) {
    final rawValue = local?.getString(key);

    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      local?.remove(key);
      return null;
    } catch (_) {
      local?.remove(key);
      return null;
    }
  }

  static Future<void> removeCache({required String key}) async {
    await local?.remove(key);
  }

  static Future<void> setMyAccountCache({
    required Map<String, dynamic> value,
  }) async {
    await setCacheJson(key: StorageKeys.myAccount, value: value);
  }

  static Map<String, dynamic>? getMyAccountCache() {
    return getCacheJson(key: StorageKeys.myAccount);
  }

  static Future<void> deleteMyAccountCache() async {
    await removeCache(key: StorageKeys.myAccount);
  }

  // static Future setUser({UserModule? user}) async {
  //   final value = user == null ? '' : json.encode(user.toJson());
  //   await local?.setString(StorageKeys.userModule, value);
  // }

  // static UserModule? getUser() {
  //   final raw = local?.getString(StorageKeys.userModule);
  //   if (raw == null || raw.trim().isEmpty) return null;
  //   try {
  //     final decoded = json.decode(raw);
  //     if (decoded is Map<String, dynamic>) {
  //       return UserModule.fromJson(decoded);
  //     }
  //     // Old/bad cached format → clear and ignore
  //     deleteUser();
  //     return null;
  //   } catch (_) {
  //     // Old/bad cached string (e.g. Map.toString()) → clear and ignore
  //     deleteUser();
  //     return null;
  //   }
  // }

  // static void deleteUser() => local?.remove(StorageKeys.userModule);

  static Future<void> setLocaleLanguage(String locale) async {
    await local?.setString(StorageKeys.localeLanguage, locale);
  }

  static String getLocaleLanguage() {
    if (local?.getString(StorageKeys.localeLanguage) == 'en') {
      return 'en';
    } else if (local?.getString(StorageKeys.localeLanguage) == 'ar_EG') {
      return 'ar';
    } else {
      return local?.getString(StorageKeys.localeLanguage) ?? 'en';
    }
  }

  static Future<void> setIsDarkModeOn({required bool isDarkMode}) async {
    await local?.setBool(StorageKeys.isDarkMode, isDarkMode);
  }

  static bool getIsDarkModeOn() {
    return local?.getBool(StorageKeys.isDarkMode) ?? false;
  }

  static void deleteIsDarkModeOn() {
    local?.remove(StorageKeys.isDarkMode);
  }

  static void deleteLocaleLanguage() {
    local?.remove(StorageKeys.localeLanguage);
  }

  static bool getIsOnboardingCompleted() {
    debugPrint(
      'isOnboardingCompleted: ${local?.getBool(StorageKeys.isOnboardingCompleted)}',
    );
    return local?.getBool(StorageKeys.isOnboardingCompleted) ?? false;
  }

  static Future<void> setIsOnboardingCompleted({
    required bool isOnboardingCompleted,
  }) async {
    await local?.setBool(
      StorageKeys.isOnboardingCompleted,
      isOnboardingCompleted,
    );
  }

  static void deleteIsOnboardingCompleted() {
    local?.remove(StorageKeys.isOnboardingCompleted);
  }

  static Future<void> setIsGuestUser({required bool isGuestUser}) async {
    await local?.setBool(StorageKeys.isGuestUser, isGuestUser);
  }

  static bool getIsGuestUser() {
    return local?.getBool(StorageKeys.isGuestUser) ?? false;
  }

  static void deleteIsGuestUser() {
    local?.remove(StorageKeys.isGuestUser);
  }

  static Future<void> setShowGuestDialogOnHome({
    required bool shouldShow,
  }) async {
    await local?.setBool(StorageKeys.showGuestDialogOnHome, shouldShow);
  }

  static bool getShowGuestDialogOnHome() {
    return local?.getBool(StorageKeys.showGuestDialogOnHome) ?? false;
  }

  static void deleteShowGuestDialogOnHome() {
    local?.remove(StorageKeys.showGuestDialogOnHome);
  }

  static void setAppleuser({required String email}) {
    debugPrint('email: $email');
    if (email.isNotEmpty && email == 'store@store.com') {
      local?.setBool(StorageKeys.isAppleUser, true);
    } else {
      local?.setBool(StorageKeys.isAppleUser, false);
    }
  }

  static bool getIsAppleUser() {
    return local?.getBool(StorageKeys.isAppleUser) ?? false;
  }

  static void deleteIsAppleUser() {
    local?.remove(StorageKeys.isAppleUser);
  }

  static Future<void> clearSession() async {
    await deleteUserToken();
    await deleteMyAccountCache();
    deleteIsGuestUser();
    deleteShowGuestDialogOnHome();
    deleteIsAppleUser();
  }

  static void clear() {
    clearSession();
  }

  // Saves the list of favorite car IDs to local storage.
  static Future<void> setFavoriteCars({
    required List<String> favoriteCars,
  }) async {
    await local?.setStringList(StorageKeys.favoriteCars, favoriteCars);
    // print('favoriteCars: $favoriteCars');
  }

  // Retrieves the list of favorite car IDs from local storage.
  static List<String> getFavoriteCars() {
    final favoriteCars = local?.getStringList(StorageKeys.favoriteCars) ?? [];
    // print('favoriteCars: $favoriteCars');
    return favoriteCars;
  }

  // Deletes the list of favorite car IDs from local storage.
  static void deleteFavoriteCars() {
    local?.remove(StorageKeys.favoriteCars);
    // print('favoriteCars: ${local?.getStringList(StorageKeys.favoriteCars)}');
  }
}
