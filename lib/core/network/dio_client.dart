import 'package:dio/dio.dart';

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
    dio.interceptors.addAll(interceptors);
  }

  final Dio dio;
}
