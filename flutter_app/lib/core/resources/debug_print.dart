import 'package:flutter/foundation.dart';

void printDebug({required String message, StackTrace? stackTrace}) {
  if (kDebugMode) {
    debugPrint('===========> $message <===========');
    if (stackTrace != null) {
      debugPrint('===========> $stackTrace <===========');
    }
  }
}
