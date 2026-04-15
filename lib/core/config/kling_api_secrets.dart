import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../error/exceptions.dart';

/// Loads Kling API credentials from [dotenv] (call [dotenv.load] first).
///
/// Supports either a static bearer token or access/secret key pair (JWT).
class KlingApiSecrets {
  KlingApiSecrets._(this._authorizationHeader);

  final String Function() _authorizationHeader;

  /// `Authorization` header value, including the `Bearer` prefix.
  String authorizationHeaderValue() => _authorizationHeader();

  /// Reads [KLING_BEARER_TOKEN] or [KLING_API_KEY], or
  /// [KLING_ACCESS_KEY] + [KLING_SECRET_KEY] for JWT (HS256).
  factory KlingApiSecrets.fromLoadedEnv() {
    String? trimmed(String key) {
      final raw = dotenv.env[key]?.trim();
      if (raw == null || raw.isEmpty) {
        return null;
      }
      return raw;
    }

    final bearer = trimmed('KLING_BEARER_TOKEN') ?? trimmed('KLING_API_KEY');
    if (bearer != null) {
      return KlingApiSecrets._(() => 'Bearer $bearer');
    }

    final accessKey = trimmed('KLING_ACCESS_KEY');
    final secretKey = trimmed('KLING_SECRET_KEY');
    if (accessKey != null && secretKey != null) {
      final cache = _KlingJwtTokenCache(
        accessKey: accessKey,
        secretKey: secretKey,
      );
      return KlingApiSecrets._(() => 'Bearer ${cache.token()}');
    }

    throw ConfigurationException(
      'Missing Kling credentials. Set KLING_BEARER_TOKEN (or KLING_API_KEY), '
      'or KLING_ACCESS_KEY and KLING_SECRET_KEY in assets/.env.',
    );
  }

  /// Fixed bearer token (e.g. widget tests).
  factory KlingApiSecrets.bearerForTests(String rawToken) {
    return KlingApiSecrets._(() => 'Bearer $rawToken');
  }
}

class _KlingJwtTokenCache {
  _KlingJwtTokenCache({required String accessKey, required String secretKey})
    : _accessKey = accessKey,
      _secretKey = secretKey;

  final String _accessKey;
  final String _secretKey;

  String? _cachedToken;
  DateTime? _cacheValidUntil;

  String token() {
    final now = DateTime.now();
    if (_cachedToken != null &&
        _cacheValidUntil != null &&
        now.isBefore(_cacheValidUntil!)) {
      return _cachedToken!;
    }

    final jwt = JWT(<String, dynamic>{}, issuer: _accessKey);
    _cachedToken = jwt.sign(
      SecretKey(_secretKey),
      algorithm: JWTAlgorithm.HS256,
      expiresIn: const Duration(minutes: 25),
      notBefore: const Duration(seconds: -5),
    );
    _cacheValidUntil = now.add(const Duration(minutes: 20));
    return _cachedToken!;
  }
}
