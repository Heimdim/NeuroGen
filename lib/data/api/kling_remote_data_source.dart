import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/config/kling_api_config.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/dio_error_mapper.dart';
import '../../domain/entities/job_status.dart';
import '../../l10n/locale_bridge.dart';
import '../dto/generation_poll_result.dart';
import '../dto/generation_request_dto.dart';
import '../dto/generation_submit_result.dart';

abstract class KlingRemoteDataSource {
  Future<GenerationSubmitResult> submitImageGeneration(
    GenerationRequestDto request,
  );

  Future<GenerationPollResult> pollImageGeneration(String taskId);
}

class KlingRemoteDataSourceImpl implements KlingRemoteDataSource {
  KlingRemoteDataSourceImpl(this._dioClient, this._config);

  final DioClient _dioClient;
  final KlingApiConfig _config;

  static const String _generationsPath = '/v1/images/generations';

  @override
  Future<GenerationSubmitResult> submitImageGeneration(
    GenerationRequestDto request,
  ) async {
    final l10n = resolveAppLocalizationsFromPlatform();
    try {
      final imageField = await _imageFieldForJson(request.imagePath);
      final payload = <String, dynamic>{
        'model_name': _config.imageModelName,
        'prompt': request.prompt,
        'negative_prompt': '',
        'image': imageField,
        'n': 1,
        'external_task_id': '',
        'callback_url': '',
      };

      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        _generationsPath,
        data: payload,
      );

      final data = response.data;
      if (data == null) {
        throw ServerException(l10n.errorEmptyResponseFromApi);
      }

      _ensureSuccessEnvelope(data);

      final inner = data['data'];
      if (inner is! Map) {
        throw ServerException(l10n.errorUnexpectedApiMissingData);
      }
      final node = Map<String, dynamic>.from(inner);

      final urls = _extractAllImageUrls(node);
      if (urls.isNotEmpty) {
        return GenerationSubmitResult(imageUrls: urls);
      }

      final taskId = node['task_id']?.toString();
      if (taskId == null || taskId.isEmpty) {
        throw ServerException(l10n.errorUnexpectedNoImageOrTask);
      }

      return GenerationSubmitResult(taskId: taskId);
    } on DioException catch (error) {
      DioErrorMapper.throwMapped(error, l10n);
    }
  }

  @override
  Future<GenerationPollResult> pollImageGeneration(String taskId) async {
    final l10n = resolveAppLocalizationsFromPlatform();
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        '$_generationsPath/$taskId',
      );

      final root = response.data;
      if (root == null) {
        return const GenerationPollResult(status: JobStatus.processing);
      }

      _ensureSuccessEnvelope(root);

      final inner = root['data'];
      final Map<String, dynamic> node = inner is Map
          ? Map<String, dynamic>.from(inner)
          : root;

      final urls = _extractAllImageUrls(node);
      if (urls.isNotEmpty) {
        return GenerationPollResult(
          status: JobStatus.completed,
          imageUrls: urls,
        );
      }

      final statusRaw = node['task_status']?.toString().toLowerCase() ?? '';
      if (statusRaw == 'failed' || statusRaw == 'error') {
        final msg =
            node['task_status_msg']?.toString() ??
            node['message']?.toString() ??
            l10n.errorImageGenerationFailed;
        return GenerationPollResult(status: JobStatus.failed, message: msg);
      }
      if (statusRaw == 'succeed' ||
          statusRaw == 'success' ||
          statusRaw == 'completed') {
        return GenerationPollResult(
          status: JobStatus.completed,
          imageUrls: urls,
          message: urls.isEmpty ? l10n.errorCompletedWithoutUrls : null,
        );
      }
      return const GenerationPollResult(status: JobStatus.processing);
    } on DioException catch (error) {
      DioErrorMapper.throwMapped(error, l10n);
    }
  }

  void _ensureSuccessEnvelope(Map<String, dynamic> json) {
    final code = json['code'];
    if (code == null) {
      return;
    }
    final ok =
        (code is num && code.toInt() == 0) || (code is String && code == '0');
    if (!ok) {
      final msg =
          json['message']?.toString() ??
          resolveAppLocalizationsFromPlatform().errorKlingApiReturned;
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
      throw ServerException(
        resolveAppLocalizationsFromPlatform().errorSelectedImageFileNotFound,
      );
    }

    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static List<String> _extractAllImageUrls(Map<String, dynamic> node) {
    final out = <String>[];
    final direct = node['image_url'] as String?;
    if (direct != null && direct.isNotEmpty) {
      out.add(direct);
    }

    final tr = node['task_result'];
    if (tr is! Map) {
      return out;
    }
    final trMap = Map<String, dynamic>.from(tr);
    final images = trMap['images'];
    if (images is! List || images.isEmpty) {
      return out;
    }
    for (final item in images) {
      if (item is! Map) {
        continue;
      }
      final m = Map<String, dynamic>.from(item);
      final u = m['url'] as String? ?? m['image_url'] as String?;
      if (u != null && u.isNotEmpty) {
        out.add(u);
      }
    }
    return out;
  }
}
