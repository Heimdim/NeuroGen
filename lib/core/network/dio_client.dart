import 'package:dio/dio.dart';

import 'kling_auth_interceptor.dart';

class DioClient {
  DioClient({
    required String baseUrl,
    List<Interceptor> interceptors = const [],
    Duration connectTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 40),
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           responseType: ResponseType.json,
         ),
       ) {
    for (final interceptor in interceptors) {
      if (interceptor is KlingAuthInterceptor) {
        interceptor.bindClient(dio);
      }
    }
    dio.interceptors.addAll(interceptors);
  }

  final Dio dio;
}
