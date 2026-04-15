import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/config/kling_api_config.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/dio_error_mapper.dart';
import '../dto/generation_request_dto.dart';
import '../dto/generation_response_dto.dart';

abstract class KlingRemoteDataSource {
  Future<GenerationResponseDto> generateImage(GenerationRequestDto request);
}

class KlingRemoteDataSourceImpl implements KlingRemoteDataSource {
  KlingRemoteDataSourceImpl(this._dioClient, this._config);

  final DioClient _dioClient;
  final KlingApiConfig _config;

  static const String _generationsPath = '/v1/images/generations';
  static const Duration _pollInterval = Duration(seconds: 2);
  static const int _maxPollAttempts = 90;

  @override
  Future<GenerationResponseDto> generateImage(
    GenerationRequestDto request,
  ) async {
    try {
      final imageField = await _imageFieldForJson(request.imagePath);
      final payload = <String, dynamic>{
        'model_name': _config.imageModelName,
        'prompt': request.prompt,
        'negative_prompt': '',
        'image': imageField,
        'n': 2,
        'external_task_id': '',
        'callback_url': '',
      };

      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        _generationsPath,
        data: payload,
      );

      final data = response.data;
      if (data == null) {
        throw ServerException('Empty response from API.');
      }

      _ensureSuccessEnvelope(data);

      final inner = data['data'];
      if (inner is! Map) {
        throw ServerException('Unexpected API response: missing data object.');
      }
      final node = Map<String, dynamic>.from(inner);

      final immediate = _extractImageUrl(node);
      if (immediate != null && immediate.isNotEmpty) {
        return GenerationResponseDto(
          imageUrl: immediate,
          prompt: request.prompt,
        );
      }

      final taskId = node['task_id']?.toString();
      if (taskId == null || taskId.isEmpty) {
        throw ServerException('Unexpected API response: no image URL or task.');
      }

      return _pollUntilImageReady(taskId: taskId, prompt: request.prompt);
    } on DioException catch (error) {
      DioErrorMapper.throwMapped(error);
    }
  }

  Future<GenerationResponseDto> _pollUntilImageReady({
    required String taskId,
    required String prompt,
  }) async {
    for (var i = 0; i < _maxPollAttempts; i++) {
      if (i > 0) {
        await Future<void>.delayed(_pollInterval);
      }

      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        '$_generationsPath/$taskId',
      );

      final root = response.data;
      if (root == null) {
        continue;
      }

      _ensureSuccessEnvelope(root);

      final inner = root['data'];
      final Map<String, dynamic> node = inner is Map
          ? Map<String, dynamic>.from(inner)
          : root;

      final url = _extractImageUrl(node);
      if (url != null && url.isNotEmpty) {
        return GenerationResponseDto(imageUrl: url, prompt: prompt);
      }

      final status = node['task_status']?.toString().toLowerCase();
      if (status == 'failed' || status == 'error') {
        final msg =
            node['task_status_msg']?.toString() ??
            node['message']?.toString() ??
            'Image generation failed.';
        throw ServerException(msg);
      }
    }

    throw ServerException('Image generation timed out.');
  }

  void _ensureSuccessEnvelope(Map<String, dynamic> json) {
    final code = json['code'];
    if (code == null) {
      return;
    }
    final ok =
        (code is num && code.toInt() == 0) || (code is String && code == '0');
    if (!ok) {
      final msg = json['message']?.toString() ?? 'Kling API returned an error.';
      throw ServerException(msg);
    }
  }

  Future<String> _imageFieldForJson(String? imagePath) async {
    final path = imagePath?.trim();
    if (path == null || path.isEmpty) {
      return '';
    }
    final lower = path.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return path;
    }

    final file = File(path);
    if (!await file.exists()) {
      throw ServerException('Selected image file was not found.');
    }

    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static String? _extractImageUrl(Map<String, dynamic> node) {
    final direct = node['image_url'] as String?;
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }

    final tr = node['task_result'];
    if (tr is! Map) {
      return null;
    }
    final trMap = Map<String, dynamic>.from(tr);
    final images = trMap['images'];
    if (images is! List || images.isEmpty) {
      return null;
    }
    final first = images.first;
    if (first is! Map) {
      return null;
    }
    final m = Map<String, dynamic>.from(first);
    final u = m['url'] as String? ?? m['image_url'] as String?;
    if (u != null && u.isNotEmpty) {
      return u;
    }
    return null;
  }
}
