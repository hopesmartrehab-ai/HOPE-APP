import 'package:dio/dio.dart';

import '../local_storage/local_storage.dart';

class TokenInterceptor extends Interceptor {
  final bool requireAuth;
  TokenInterceptor({required this.requireAuth}) : super();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (requireAuth) {
      final userToken = await LocalStorage.getUserToken();
      if (userToken.isNotEmpty) {
        options.headers.addAll({'Authorization': 'Bearer $userToken'});
      }
    }
    handler.next(options);
  }
}
