// import 'package:dio/dio.dart';
// import 'package:easy_localization/easy_localization.dart';

// import '../constants/locale_keys.dart';

// abstract class Failures {
//   final String errorMessage;
//   Failures(this.errorMessage);
// }

// String _extractFirstErrorMessage(dynamic response) {
//   try {
//     // New API shape: { "data": ["name should not be empty"] }
//     final dynamic data = response is Map<String, dynamic>
//         ? response['data']
//         : null;
//     if (data is List && data.isNotEmpty && data.first is String) {
//       return data.first as String;
//     }

//     // Fallbacks to old message-based format if present
//     final dynamic message = response is Map<String, dynamic>
//         ? response['message']
//         : null;
//     if (message is String && message.isNotEmpty) {
//       return message;
//     }
//     if (message is List && message.isNotEmpty && message.first is String) {
//       return message.first as String;
//     }
//   } catch (_) {
//     // ignore and fallback below
//   }
//   return LocaleKeys.anErrorOccurred.tr();
// }

// class ServerFailure extends Failures {
//   ServerFailure(super.errorMessage);
//   factory ServerFailure.fromDioException(DioException dioException) {
//     switch (dioException.type) {
//       case DioExceptionType.connectionTimeout:
//         final message = LocaleKeys.connectionTimeOutWithApiServer.tr();
//         return ServerFailure(message);
//       case DioExceptionType.sendTimeout:
//         final message = LocaleKeys.sendTimeOutWithApiServer.tr();
//         return ServerFailure(message);
//       case DioExceptionType.receiveTimeout:
//         final message = LocaleKeys.receiveTimeOutWithApiServer.tr();
//         return ServerFailure(message);
//       case DioExceptionType.transformTimeout:
//         final message = LocaleKeys.receiveTimeOutWithApiServer.tr();
//         return ServerFailure(message);
//       case DioExceptionType.badCertificate:
//         final message = LocaleKeys.badCertificateWithApiServer.tr();
//         return ServerFailure(message);
//       case DioExceptionType.badResponse:
//         final statusCode = dioException.response?.statusCode;
//         final responseData = dioException.response?.data;

//         if (statusCode != null) {
//           return ServerFailure.fromResponse(statusCode, responseData);
//         }

//         final message = _extractFirstErrorMessage(responseData);
//         return ServerFailure(message);
//       case DioExceptionType.cancel:
//         final message = LocaleKeys.requestToApiServerWasCanceled.tr();
//         return ServerFailure(message);
//       case DioExceptionType.connectionError:
//         final message = LocaleKeys.connectionErrorWithApiServer.tr();
//         return ServerFailure(message);
//       case DioExceptionType.unknown:
//         final message =
//             dioException.message?.contains('SocketException') == true
//             ? LocaleKeys.noInternetConnection.tr()
//             : LocaleKeys.unknownErrorWithApiServer.tr();
//         return ServerFailure(message);
//     }
//   }

//   factory ServerFailure.fromResponse(int statusCode, dynamic response) {
//     final extractedMessage = _extractFirstErrorMessage(response);

//     if (statusCode == 400 ||
//         statusCode == 401 ||
//         statusCode == 403 ||
//         statusCode == 404 ||
//         statusCode == 409 ||
//         statusCode == 500) {
//       return ServerFailure(extractedMessage);
//     } else {
//       final message = extractedMessage.isNotEmpty
//           ? extractedMessage
//           : LocaleKeys.oopsThereWasAnError.tr();
//       return ServerFailure(message);
//     }
//   }
// }
