class ConfigurationException implements Exception {
  ConfigurationException(this.message);

  final String message;
}

class ServerException implements Exception {
  ServerException(this.message);

  final String message;
}

class NetworkException implements Exception {
  NetworkException(this.message);

  final String message;
}
