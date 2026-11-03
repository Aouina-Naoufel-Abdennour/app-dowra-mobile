import 'package:dio/dio.dart';

import 'api.dart';
import 'catalogue.dart';
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

  // ── Catalogue ──

  Future<HomeData> home({int? wilaya}) => _call(() async {
        final res = await _dio.get('/home', queryParameters: {'wilaya': ?wilaya});
        return HomeData.fromJson(res.data['data'] as Map<String, dynamic>);
      });

  /// Une page de l'agenda (12 sorties) et le nombre de pages.
  Future<({List<EventCard> events, int total, int lastPage})> events(EventFilters filters, {int page = 1}) => _call(() async {
        final res = await _dio.get('/events', queryParameters: {...filters.toQuery(), 'page': page});
        final meta = res.data['meta'] as Map<String, dynamic>;
        return (
          events: [for (final item in res.data['data'] as List) EventCard.fromJson(item as Map<String, dynamic>)],
          total: meta['total'] as int,
          lastPage: meta['last_page'] as int,
        );
      });

  Future<List<MapPoint>> mapPoints(EventFilters filters) => _list('/events/map?${Uri(queryParameters: filters.toQuery().map((k, v) => MapEntry(k, '$v'))).query}', MapPoint.fromJson);

  Future<EventDetail> event(String slug) => _call(() async {
        final res = await _dio.get('/events/${Uri.encodeComponent(slug)}');
        return EventDetail.fromJson(res.data['data'] as Map<String, dynamic>);
      });

  Future<List<EventCard>> similar(String slug) => _list('/events/${Uri.encodeComponent(slug)}/similar', EventCard.fromJson);

  Future<OrganizerPage> organizer(String slug) => _call(() async {
        final res = await _dio.get('/organizers/${Uri.encodeComponent(slug)}');
        return OrganizerPage.fromJson(res.data['data'] as Map<String, dynamic>);
      });

  Future<List<EventCard>> favorites() => _list('/me/favorites', EventCard.fromJson);

  Future<bool> setFavorite(String slug, bool favorite) => _call(() async {
        final path = '/events/${Uri.encodeComponent(slug)}/favorite';
        final res = favorite ? await _dio.post(path) : await _dio.delete(path);
        return res.data['data']['is_favorite'] as bool;
      });

  Future<({bool following, int followers})> setFollow(String slug, bool follow) => _call(() async {
        final path = '/organizers/${Uri.encodeComponent(slug)}/follow';
        final res = follow ? await _dio.post(path) : await _dio.delete(path);
        return (following: res.data['data']['is_following'] as bool, followers: res.data['data']['followers_count'] as int);
      });

  Future<void> report({required String type, required String slug, required String reason, String? details}) =>
      _call(() => _dio.post('/reports', data: {'type': type, 'slug': slug, 'reason': reason, if (details != null && details.isNotEmpty) 'details': details}));
}
