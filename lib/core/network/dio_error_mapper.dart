import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Maps [DioException] to app-level exceptions with user-facing messages.
class DioErrorMapper {
  const DioErrorMapper._();

  static Never throwMapped(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      throw NetworkException(
        'The request took too long. Check your connection and try again.',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      throw NetworkException(
        'No internet connection. Try again when you are online.',
      );
    }

    if (error.type == DioExceptionType.cancel) {
      throw NetworkException('The request was cancelled.');
    }

    final response = error.response;
    if (response != null) {
      final status = response.statusCode;
      final data = response.data;
      final apiMessage = _messageFromBody(data);
      final message =
          apiMessage ??
          'The service is temporarily unavailable'
              '${status != null ? ' (code $status)' : ''}. Please try again.';
      throw ServerException(message);
    }

    final fallback = error.message?.trim();
    throw ServerException(
      (fallback == null || fallback.isEmpty)
          ? 'Something went wrong. Please try again.'
          : fallback,
    );
  }

  static String? _messageFromBody(Object? data) {
    if (data is Map<String, dynamic>) {
      final direct = data['message'] ?? data['error'] ?? data['detail'];
      if (direct is String && direct.trim().isNotEmpty) {
        return direct.trim();
      }
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty && errors.first is String) {
        return (errors.first as String).trim();
      }
    }
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }
    return null;
  }
}
