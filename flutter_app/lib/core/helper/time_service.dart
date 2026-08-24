import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../local_storage/local_storage.dart';

abstract class TimeService {
  TimeService._();

  static const String _timeFormat = 'HH:mm';

  static DateTime dateFormatYMD(DateTime? time) {
    return DateTime.tryParse(
          DateFormat("yyyy-MM-dd", 'en').format(time ?? DateTime.now()),
        ) ??
        DateTime.now();
  }

  static String dateFormatMDYHm(DateTime? time) {
    return DateFormat(
      "MMM d, yyyy - $_timeFormat",
      LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String dateFormatYMDHm(DateTime? time) {
    return DateFormat(
      "yyyy-MM-dd HH:mm",
      LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String dateFormatDMY(DateTime? time, {String? locale}) {
    return DateFormat(
      "d MMM, yyyy",
      locale ?? LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String dateFormatDMYSlash(DateTime? time, {String? locale}) {
    return DateFormat(
      "d / M / yyyy",
      locale ?? LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String dateFormatDM(DateTime? time) {
    if (DateTime.now().year == time?.year) {
      return DateFormat(
        "d MMMM",
        LocalStorage.getLocaleLanguage(),
      ).format(time ?? DateTime.now());
    }
    return DateFormat(
      "d MMMM, yyyy",
      LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String timeFormat(DateTime? time) {
    return DateFormat(
      _timeFormat,
      LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String dateFormatWDM(DateTime? time) {
    return DateFormat(
      "EEE, d MMM",
      LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String dateFormatForChat(DateTime? time) {
    if ((DateTime.now().difference(time ?? DateTime.now()).inHours) > 24 &&
        (DateTime.now().difference(time ?? DateTime.now()).inDays) < 7) {
      return DateFormat(
        "EEEE",
        LocalStorage.getLocaleLanguage(),
      ).format(time ?? DateTime.now());
    }
    if ((DateTime.now().difference(time ?? DateTime.now()).inDays) > 7) {
      return DateFormat(
        "MMM/d/yyyy",
        LocalStorage.getLocaleLanguage(),
      ).format(time ?? DateTime.now());
    }
    return DateFormat(
      _timeFormat,
      LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String dateFormatForNotification(DateTime? time) {
    return DateFormat(
      "d MMM, $_timeFormat",
      LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String timeFormatHM(DateTime? time) {
    return DateFormat(
      "hh:mm a",
      LocalStorage.getLocaleLanguage(),
    ).format(time ?? DateTime.now());
  }

  static String formatTimeString(String timeString) {
    try {
      // Parse the input time string
      final parsedTime = DateFormat("HH:mm:ss").parse(timeString);

      // Format it to "hh:mm a" (12-hour format with AM/PM)
      return DateFormat(
        "hh:mm a",
        LocalStorage.getLocaleLanguage(),
      ).format(parsedTime);
    } catch (e) {
      // Handle parsing errors and return a fallback value
      return "Invalid time";
    }
  }

  static String formatHHMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    final int minutes = (seconds / 60).truncate();
    final String minutesStr = (minutes).toString().padLeft(2, '0');
    final String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  static String getDetailedDateInfo(String date) {
    try {
      // Parse the input date string into a DateTime object
      final DateTime parsedDate = DateTime.parse(date);

      // Format the date components
      final String dayName = DateFormat(
        'EEEE',
        LocalStorage.getLocaleLanguage(),
      ).format(parsedDate);
      final String monthName = DateFormat(
        'MMMM',
        LocalStorage.getLocaleLanguage(),
      ).format(parsedDate);
      final String dayNumber = DateFormat(
        'd',
        LocalStorage.getLocaleLanguage(),
      ).format(parsedDate);
      final String year = DateFormat(
        'yyyy',
        LocalStorage.getLocaleLanguage(),
      ).format(parsedDate);
      debugPrint('date = $dayName, $monthName $dayNumber, $year');
      // Combine the components into a readable string
      return '$dayName $dayNumber $monthName , $year';
    } catch (e) {
      // Handle invalid date strings
      return 'Invalid date format';
    }
  }

  static String formatTimeToLocal(String time) {
    try {
      // Parse the time string into a DateTime object
      final DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);

      // Format the time into your local format (e.g., 8:10 PM)
      return DateFormat.jm(LocalStorage.getLocaleLanguage()).format(parsedTime);
    } catch (e) {
      // Handle invalid input gracefully
      return "Invalid time format";
    }
  }

  static String fomatStartDateAndEndDate(String startDate, String endDate) {
    try {
      final locale = LocalStorage.getLocaleLanguage();
      final start = startDate.trim();
      final end = endDate.trim();

      final DateTime? parsedStart = start.isEmpty
          ? null
          : DateTime.tryParse(start);
      final DateTime? parsedEnd = end.isEmpty ? null : DateTime.tryParse(end);

      final singleFormatter = DateFormat("MMM d, yyyy", locale);
      final rangeStartFormatter = DateFormat("MMM d", locale);
      final rangeEndFormatter = DateFormat("MMM d, yyyy", locale);

      if (parsedStart != null && parsedEnd != null) {
        // Example: Aug 12 - Aug 20, 2024
        return '${rangeStartFormatter.format(parsedStart)} - ${rangeEndFormatter.format(parsedEnd)}';
      }
      if (parsedStart != null) {
        // Example: Jul 28, 2024
        return singleFormatter.format(parsedStart);
      }
      if (parsedEnd != null) {
        // Example: Jul 28, 2024
        return singleFormatter.format(parsedEnd);
      }
      return "";
    } catch (e) {
      return "Invalid start date and end date format";
    }
  }

  static String formatDateToDMYDash(String date) {
    try {
      final raw = date.trim();
      if (raw.isEmpty) return "";

      final parsedDate = DateTime.tryParse(raw);
      if (parsedDate == null) return "Invalid date format";

      // Example: 31-03-2026
      return DateFormat("dd-MM-yyyy", 'en').format(parsedDate);
    } catch (e) {
      return "Invalid date format";
    }
  }

  /// Parses [value] as `month-year`, e.g. `3-2026` or `03-2026`.
  /// Returns localized full month + year, e.g. English: `March 2026`, Arabic: month name per locale.
  static String formatMonthYearFromDash(String value) {
    try {
      final raw = value.trim();
      if (raw.isEmpty) return "";

      final parts = raw.split('-');
      if (parts.length != 2) return "Invalid date format";

      final month = int.tryParse(parts[0].trim());
      final year = int.tryParse(parts[1].trim());
      if (month == null || year == null || month < 1 || month > 12) {
        return "Invalid date format";
      }

      final dt = DateTime(year, month);
      return DateFormat(
        "MMMM yyyy",
        LocalStorage.getLocaleLanguage(),
      ).format(dt);
    } catch (e) {
      return "Invalid date format";
    }
  }
}
