import 'package:dio/dio.dart';

import '../../l10n/app_localizations.dart';
import '../error/exceptions.dart';

class DioErrorMapper {
  const DioErrorMapper._();

  static Never throwMapped(DioException error, AppLocalizations l10n) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      throw NetworkException(l10n.errorRequestTimeout);
    }

    if (error.type == DioExceptionType.connectionError) {
      throw NetworkException(l10n.errorNoConnection);
    }

    if (error.type == DioExceptionType.cancel) {
      throw NetworkException(l10n.errorRequestCancelled);
    }

    final response = error.response;
    if (response != null) {
      final status = response.statusCode;
      final data = response.data;
      final apiMessage = _messageFromBody(data);
      final message =
          apiMessage ??
          (status != null
              ? l10n.errorServiceUnavailableWithCode(status)
              : l10n.errorServiceUnavailable);
      throw ServerException(message);
    }

    final fallback = error.message?.trim();
    throw ServerException(
      (fallback == null || fallback.isEmpty)
          ? l10n.errorSomethingWentWrong
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
