import 'package:dio/dio.dart';

import 'api.dart';
import 'models.dart';
import 'storage.dart';

/// Connexion par code SMS, profil et référentiels (API v1 de app-dowra-backend).
class DowraRepository {
  DowraRepository(this._dio, this._tokens);

  final Dio _dio;
  final TokenStorage _tokens;

  Future<T> _call<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<void> requestOtp(String phone) => _call(() => _dio.post('/auth/otp/request', data: {'phone': phone}));

  Future<DowraUser> verifyOtp(String phone, String code, {required String deviceName}) => _call(() async {
        final res = await _dio.post('/auth/otp/verify', data: {'phone': phone, 'code': code, 'device_name': deviceName});
        await _tokens.write(res.data['token'] as String);
        return DowraUser.fromJson(res.data['user'] as Map<String, dynamic>);
      });

  /// Compte du jeton gardé sur le téléphone ; null si personne n'est connecté ou si le jeton a été révoqué.
  Future<DowraUser?> currentUser() async {
    if (await _tokens.read() == null) return null;
    try {
      final res = await _dio.get('/me');
      return DowraUser.fromJson(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _tokens.clear();
        return null;
      }
      throw ApiException.from(e);
    }
  }

  /// PATCH /me : profil, wilaya, envies, langue, mode d'affichage, premier passage terminé.
  Future<DowraUser> updateProfile(Map<String, Object?> fields) => _call(() async {
        final res = await _dio.patch('/me', data: fields);
        return DowraUser.fromJson(res.data['data'] as Map<String, dynamic>);
      });

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {
      // Le jeton est supprimé même si l'API ne répond pas.
    }
    await _tokens.clear();
  }

  /// Suppression du compte (exigée par Apple et Google).
  Future<void> deleteAccount() async {
    await _call(() => _dio.delete('/me'));
    await _tokens.clear();
  }

  Future<List<T>> _list<T>(String path, T Function(Map<String, dynamic>) parse) => _call(() async {
        final res = await _dio.get(path);
        return [for (final item in res.data['data'] as List) parse(item as Map<String, dynamic>)];
      });

  Future<List<OutingType>> outingTypes() => _list('/outing-types', OutingType.fromJson);
  Future<List<Category>> categories() => _list('/categories', Category.fromJson);
  Future<List<Wilaya>> wilayas() => _list('/wilayas', Wilaya.fromJson);
}
