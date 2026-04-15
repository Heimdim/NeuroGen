import 'package:dio/dio.dart';

import '../config/kling_api_secrets.dart';

class KlingAuthInterceptor extends Interceptor {
  KlingAuthInterceptor(this._secrets);

  final KlingApiSecrets _secrets;
  Dio? _client;

  void bindClient(Dio dio) {
    _client = dio;
  }

  static const String _retryExtraKey = 'neurogen.kling_jwt_retried';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = _secrets.authorizationHeaderValue();
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final client = _client;
    if (client == null || err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }
    final opts = err.requestOptions;
    if (opts.extra[_retryExtraKey] == true) {
      handler.next(err);
      return;
    }

    _secrets.invalidateKlingJwtCache();
    opts.extra[_retryExtraKey] = true;

    client
        .fetch<dynamic>(opts)
        .then(
          handler.resolve,
          onError: (Object e) {
            if (e is DioException) {
              handler.next(e);
            } else {
              handler.next(err);
            }
          },
        );
  }
}
