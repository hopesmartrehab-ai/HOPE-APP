// import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';

// class DeviceService {
//   static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

//   /// Get unique device identifier
//   static Future<String> getDeviceId() async {
//     if (Platform.isAndroid) {
//       final androidInfo = await _deviceInfo.androidInfo;
//       return androidInfo.id;
//     } else if (Platform.isIOS) {
//       final iosInfo = await _deviceInfo.iosInfo;
//       return iosInfo.identifierForVendor ?? "unknown-ios-id";
//     } else {
//       return "unsupported-platform";
//     }
//   }

//   /// Get more detailed device info (if needed)
//   static Future<Map<String, dynamic>> getDeviceDetails() async {
//     if (Platform.isAndroid) {
//       final androidInfo = await _deviceInfo.androidInfo;
//       return {
//         "brand": androidInfo.brand,
//         "model": androidInfo.model,
//         "id": androidInfo.id,
//         "androidVersion": androidInfo.version.release,
//       };
//     } else if (Platform.isIOS) {
//       final iosInfo = await _deviceInfo.iosInfo;
//       return {
//         "name": iosInfo.name,
//         "model": iosInfo.model,
//         "systemName": iosInfo.systemName,
//         "systemVersion": iosInfo.systemVersion,
//         "identifierForVendor": iosInfo.identifierForVendor,
//       };
//     } else {
//       return {"error": "Unsupported platform"};
//     }
//   }
// }
