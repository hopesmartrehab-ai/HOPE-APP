import 'package:dio/dio.dart';

import '../local_storage/local_storage.dart';
import 'token_interceptor.dart';
import 'web_constant.dart';

class ApiService {
  Dio client({bool requireAuth = false}) =>
      Dio(
          BaseOptions(
            baseUrl: WebConstant.isDev
                ? WebConstant.baseUrlDev
                : WebConstant.baseUrl,

            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            sendTimeout: const Duration(seconds: 60),
            headers: {
              'Accept':
                  'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
              'Content-type': 'application/json',
              'Accept-Language': LocalStorage.getLocaleLanguage(),
            },
          ),
        )
        ..interceptors.add(TokenInterceptor(requireAuth: requireAuth))
        ..interceptors.add(
          LogInterceptor(
            responseHeader: false,
            requestHeader: true,
            responseBody: true,
            requestBody: true,
          ),
        );
}
