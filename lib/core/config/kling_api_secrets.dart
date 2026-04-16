import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../error/exceptions.dart';

String _signKlingApiJwt({
  required String accessKey,
  required String secretKey,
  required int ttlSeconds,
  required int nbfSkewSeconds,
}) {
  final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  final header = <String, dynamic>{'alg': 'HS256', 'typ': 'JWT'};
  final payload = <String, dynamic>{
    'iss': accessKey,
    'exp': now + ttlSeconds,
    'nbf': now - nbfSkewSeconds,
  };
  final signingInput = '${_jwtSegment(header)}.${_jwtSegment(payload)}';
  final key = utf8.encode(secretKey);
  final sig = Hmac(sha256, key).convert(utf8.encode(signingInput)).bytes;
  return '$signingInput.${_jwtSegmentBytes(sig)}';
}

String _jwtSegment(Map<String, dynamic> claims) =>
    _jwtSegmentBytes(utf8.encode(jsonEncode(claims)));

String _jwtSegmentBytes(List<int> bytes) =>
    base64Url.encode(bytes).replaceAll('=', '');

class KlingApiSecrets {
  KlingApiSecrets._(this._authorizationHeader, {_KlingJwtTokenCache? jwtCache})
    : _jwtCache = jwtCache;

  final String Function() _authorizationHeader;
  final _KlingJwtTokenCache? _jwtCache;

  String authorizationHeaderValue() => _authorizationHeader();

  void invalidateKlingJwtCache() => _jwtCache?.invalidate();

  factory KlingApiSecrets.fromLoadedEnv() {
    String? trimmed(String key) {
      final raw = dotenv.env[key]?.trim();
      if (raw == null || raw.isEmpty) {
        return null;
      }
      return raw;
    }

    final accessKey = trimmed('KLING_ACCESS_KEY');
    final secretKey = trimmed('KLING_SECRET_KEY');
    if (accessKey != null && secretKey != null) {
      final cache = _KlingJwtTokenCache(
        accessKey: accessKey,
        secretKey: secretKey,
      );
      return KlingApiSecrets._(
        () => 'Bearer ${cache.token()}',
        jwtCache: cache,
      );
    }

    throw ConfigurationException(
      'Missing Kling credentials. Set KLING_ACCESS_KEY and KLING_SECRET_KEY in assets/.env.',
    );
  }

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

  static const int _ttlSeconds = 25 * 60;
  static const int _nbfSkewSeconds = 10;

  String token() {
    final now = DateTime.now();
    if (_cachedToken != null &&
        _cacheValidUntil != null &&
        now.isBefore(_cacheValidUntil!)) {
      return _cachedToken!;
    }

    _cachedToken = _signKlingApiJwt(
      accessKey: _accessKey,
      secretKey: _secretKey,
      ttlSeconds: _ttlSeconds,
      nbfSkewSeconds: _nbfSkewSeconds,
    );
    _cacheValidUntil = now.add(const Duration(minutes: 20));
    return _cachedToken!;
  }

  void invalidate() {
    _cachedToken = null;
    _cacheValidUntil = null;
  }
}
