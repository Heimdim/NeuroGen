import 'package:dio/dio.dart';

import 'job_result_image_storage_io.dart'
    if (dart.library.html) 'job_result_image_storage_web.dart'
    as platform;

class JobResultImageStorage {
  JobResultImageStorage({Dio? downloadClient})
    : _dio =
          downloadClient ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 120),
            ),
          );

  final Dio _dio;

  Future<void> saveToGalleryFromUrl(String imageUrl) =>
      platform.saveImageToGalleryFromUrl(_dio, imageUrl);
}
