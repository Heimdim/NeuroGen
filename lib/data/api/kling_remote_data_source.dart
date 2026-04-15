import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/error/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/dio_error_mapper.dart';
import '../dto/generation_request_dto.dart';
import '../dto/generation_response_dto.dart';

abstract class KlingRemoteDataSource {
  Future<GenerationResponseDto> generateImage(GenerationRequestDto request);
}

class KlingRemoteDataSourceImpl implements KlingRemoteDataSource {
  KlingRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<GenerationResponseDto> generateImage(
    GenerationRequestDto request,
  ) async {
    try {
      final formData = await _buildFormData(request);

      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        '/v1/images/generate',
        data: formData,
      );

      final data = response.data;
      if (data == null) {
        throw ServerException('Empty response from API.');
      }

      return GenerationResponseDto.fromJson(data);
    } on DioException catch (error) {
      DioErrorMapper.throwMapped(error);
    }
  }

  Future<FormData> _buildFormData(GenerationRequestDto request) async {
    final path = request.imagePath?.trim();
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (!await file.exists()) {
        throw ServerException('Selected image file was not found.');
      }
      return FormData.fromMap(<String, dynamic>{
        'prompt': request.prompt,
        'image': await MultipartFile.fromFile(path, filename: _basename(path)),
      });
    }

    return FormData.fromMap(<String, dynamic>{'prompt': request.prompt});
  }

  static String _basename(String path) {
    final normalized = path.replaceAll(r'\', '/');
    final index = normalized.lastIndexOf('/');
    return index == -1 ? normalized : normalized.substring(index + 1);
  }
}
