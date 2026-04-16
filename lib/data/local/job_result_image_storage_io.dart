import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:uuid/uuid.dart';

Future<void> saveImageToGalleryFromUrl(Dio dio, String imageUrl) async {
  final Response<List<int>> response = await dio.get<List<int>>(
    imageUrl,
    options: Options(
      responseType: ResponseType.bytes,
      receiveTimeout: const Duration(seconds: 120),
      followRedirects: true,
      validateStatus: (int? status) => status != null && status < 500,
    ),
  );
  final int? code = response.statusCode;
  if (code != 200 || response.data == null) {
    throw StateError('Download failed (HTTP $code).');
  }
  final Uint8List bytes = Uint8List.fromList(response.data!);
  if (!await Gal.hasAccess()) {
    final bool granted = await Gal.requestAccess();
    if (!granted) {
      throw StateError('Permission to save to the gallery was denied.');
    }
  }
  try {
    await Gal.putImageBytes(bytes, name: 'neurogen_${const Uuid().v4()}.jpg');
  } on GalException catch (e) {
    throw StateError(e.type.message);
  }
}
