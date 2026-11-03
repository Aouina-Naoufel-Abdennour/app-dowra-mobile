import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Adresse de l'API. Par défaut : émulateur Android (10.0.2.2) ou simulateur iOS / web (127.0.0.1).
/// Sur un vrai téléphone : flutter run --dart-define=API_URL=http://IP-DU-PC:8000/api/v1
String defaultApiUrl() {
  const fromEnv = String.fromEnvironment('API_URL');
  if (fromEnv.isNotEmpty) return fromEnv;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8000/api/v1';
  return 'http://127.0.0.1:8000/api/v1';
}

/// Erreur lisible renvoyée par l'API (message de validation traduit) ; « network » si le serveur ne répond pas.
class ApiException implements Exception {
  ApiException(this.message, {this.status});

  final String message;
  final int? status;

  bool get isNetwork => message == 'network';

  @override
  String toString() => message;

  static ApiException from(Object error) {
    if (error is ApiException) return error;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['errors'] is Map && (data['errors'] as Map).isNotEmpty) {
        final first = (data['errors'] as Map).values.first;
        return ApiException(first is List ? first.first.toString() : first.toString(), status: error.response?.statusCode);
      }
      if (data is Map && data['message'] is String && (error.response?.statusCode ?? 500) < 500) {
        return ApiException(data['message'] as String, status: error.response?.statusCode);
      }
      return ApiException('network', status: error.response?.statusCode);
    }
    return ApiException('network');
  }
}

/// Client HTTP : langue de l'app et jeton ajoutés à chaque requête.
Dio createDio({required String baseUrl, required Future<String?> Function() token, required String Function() locale}) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Accept': 'application/json'},
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      options.headers['Accept-Language'] = locale();
      final value = await token();
      if (value != null) options.headers['Authorization'] = 'Bearer $value';
      handler.next(options);
    },
  ));

  return dio;
}
