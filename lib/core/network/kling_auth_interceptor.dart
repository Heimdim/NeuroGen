import 'package:dio/dio.dart';

import '../config/kling_api_secrets.dart';

/// Injects the Kling `Authorization` header on every request.
class KlingAuthInterceptor extends Interceptor {
  KlingAuthInterceptor(this._secrets);

  final KlingApiSecrets _secrets;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = _secrets.authorizationHeaderValue();
    handler.next(options);
  }
}
