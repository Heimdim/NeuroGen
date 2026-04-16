import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'kling_api_secrets.dart';

class KlingApiConfig {
  KlingApiConfig({
    required this.baseUrl,
    required this.secrets,
    this.imageModelName = 'kling-v2-1',
  });

  final String baseUrl;
  final KlingApiSecrets secrets;

  final String imageModelName;

  static const String _defaultBaseUrl = 'https://api.kling.ai';
  static const String _defaultImageModel = 'kling-v2-1';

  factory KlingApiConfig.fromLoadedEnv() {
    final raw = dotenv.env['KLING_API_BASE_URL']?.trim();
    final base = (raw == null || raw.isEmpty) ? _defaultBaseUrl : raw;
    final normalized = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    final modelRaw = dotenv.env['KLING_MODEL_NAME']?.trim();
    final model = (modelRaw == null || modelRaw.isEmpty)
        ? _defaultImageModel
        : modelRaw;
    return KlingApiConfig(
      baseUrl: normalized,
      secrets: KlingApiSecrets.fromLoadedEnv(),
      imageModelName: model,
    );
  }
}
