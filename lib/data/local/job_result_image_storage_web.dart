import 'package:dio/dio.dart';

Future<void> saveImageToGalleryFromUrl(Dio dio, String imageUrl) async {
  throw UnsupportedError(
    'Saving images to the gallery is not supported in the web build.',
  );
}
