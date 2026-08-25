// import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// import '../../my_app.dart';

// Future<void> initOneSignal() async {
//   OneSignal.initialize('21fe89c7-c321-4d2c-84b2-0f679269049b');

//   await OneSignal.User.pushSubscription.optIn();
// }

// Future<String?> getOneSignalId() async {
//   try {
//     final String? oneSignalIdStr = await OneSignal.User.getOnesignalId();

//     if (oneSignalIdStr != null) {
//       debugPrint('OneSignal ID is $oneSignalIdStr');
//       final String oneSignalIdStrWithoutMin = oneSignalIdStr.replaceAll(
//         '-',
//         '',
//       );
//       await OneSignal.login(oneSignalIdStrWithoutMin);

//       // Optional: You can log the external ID if needed
//       OneSignal.User.getExternalId().then((value) {
//         debugPrint('External ID is $value');
//       });

//       return oneSignalIdStrWithoutMin;
//     } else {
//       debugPrint('OneSignal ID is null');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error retrieving OneSignal ID: $e');
//     return null;
//   }
// }

// Future<String?> getOneSignalSubscriptionId() async {
//   try {
//     await Future.delayed(const Duration(seconds: 2));
//     final String? oneSignalSubscriptionIdStr =
//         OneSignal.User.pushSubscription.id;

//     if (oneSignalSubscriptionIdStr != null) {
//       return oneSignalSubscriptionIdStr;
//     } else {
//       debugPrint('OneSignal ID is null');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error retrieving OneSignal ID: $e');
//     return null;
//   }
// }

// void printOneSignalSubscriptionId() {
//   debugPrint(
//     '-------------------------OneSignal Subscription ID-------------------------',
//   );
//   OneSignal.User.pushSubscription.addObserver((state) {
//     debugPrint(
//       '-------------------------OneSignal Subscription ID-------------------------',
//     );
//     debugPrint(OneSignal.User.pushSubscription.optedIn.toString());
//     debugPrint(OneSignal.User.pushSubscription.id.toString());
//     debugPrint(OneSignal.User.pushSubscription.token.toString());
//     debugPrint(state.current.jsonRepresentation().toString());
//     debugPrint(
//       '-------------------------OneSignal Subscription ID-------------------------',
//     );
//   });
// }

// void printNotificationData() {
//   debugPrint(
//     '-------------------------OneSignal Notification Data-------------------------',
//   );

//   // Listen for notification received
//   OneSignal.Notifications.addClickListener((event) {
//     debugPrint('Notification clicked!');
//     debugPrint('Notification ID: ${event.notification.notificationId}');
//     debugPrint('Title: ${event.notification.title}');
//     debugPrint('Body: ${event.notification.body}');
//     debugPrint('Raw Payload: ${event.notification.rawPayload}');
//     debugPrint('Additional Data: ${event.notification.additionalData}');
//     if (event.notification.body != null) {
//       if (event.notification.body!.contains('Shipment #') ||
//           event.notification.body!.contains('A new order')) {
//         final context = navigatorKey.currentContext;
//         final body = event.notification.body ?? '';
//         final shipmentNumber = extractShipmentNumber(body);
//         //Body: Shipment #43200 status has been updated to "Arrived".
//         debugPrint('Order ID: ${event.notification.body} $shipmentNumber');
//         if (context != null) {
//           // AppRoute.goSearchResult(
//           //   context: context,
//           //   searchParam: shipmentNumber ?? '',
//           // );
//           return;
//         }
//       }
//     }

//     // Print additional data from payload
//     if (event.notification.additionalData != null) {
//       debugPrint('Additional Data:');
//       event.notification.additionalData!.forEach((key, value) {
//         debugPrint('key: $key, value: $value');
//       });
//     }

//     // Print launch URL if present
//     if (event.notification.launchUrl != null) {
//       debugPrint('Launch URL: ${event.notification.launchUrl}');
//     }

//     debugPrint(
//       '-------------------------OneSignal Notification Data-------------------------',
//     );
//   });

//   // Listen for notification received (when app is in foreground)
//   OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//     debugPrint('Notification received in foreground!');
//     debugPrint('Notification ID: ${event.notification.notificationId}');
//     debugPrint('Title: ${event.notification.title}');
//     debugPrint('Body: ${event.notification.body}');
//     debugPrint('Raw Payload: ${event.notification.rawPayload}');
//     debugPrint('Additional Data: ${event.notification.additionalData}');
//     // Print additional data from payload
//     if (event.notification.additionalData != null) {
//       debugPrint('Additional Data:');
//       event.notification.additionalData!.forEach((key, value) {
//         debugPrint('  $key: $value');
//       });
//     }

//     // Print launch URL if present
//     if (event.notification.launchUrl != null) {
//       debugPrint('Launch URL: ${event.notification.launchUrl}');
//     }

//     debugPrint(
//       '-------------------------OneSignal Notification Data-------------------------',
//     );
//   });
// }

// /// Extracts the shipment/order ID from a notification body.
// /// Supports:
// /// - "Shipment #69611 status…"
// /// - "order number 69611"
// /// - "order #69611"
// /// Returns null if not found.
// String? extractShipmentNumber(String? message) {
//   if (message == null) return null;

//   // Normalize: remove zero-width/invisible chars & smart quotes
//   final cleaned = message
//       .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '')
//       .replaceAll(RegExp(r'[“”‘’"]'), '')
//       .trim();

//   // 1) If there's a hash, grab token after it until first whitespace/punct
//   final hashIdx = cleaned.indexOf('#');
//   if (hashIdx != -1) {
//     final rest = cleaned.substring(hashIdx + 1).trimLeft();
//     // token ends at first space or punctuation
//     final token = rest.split(RegExp(r'[\s,.:;]+')).first;
//     if (token.isNotEmpty) return token;
//   }

//   // 2) Look for "order number ..." (case-insensitive)
//   final lower = cleaned.toLowerCase();
//   const anchor = 'order number';
//   final anchorIdx = lower.indexOf(anchor);
//   if (anchorIdx != -1) {
//     var rest = cleaned.substring(anchorIdx + anchor.length).trimLeft();
//     // strip optional ":" or "-" after "order number"
//     rest = rest.replaceFirst(RegExp(r'^[:\-]\s*'), '');
//     final token = rest.split(RegExp(r'[\s,.:;]+')).first;
//     if (token.isNotEmpty) return token;
//   }

//   // 3) Fallback: last long number in the string (e.g., "... number 69611")
//   final nums = RegExp(r'\d{3,}').allMatches(cleaned).toList();
//   if (nums.isNotEmpty) return nums.last.group(0);

//   return null;
// }
