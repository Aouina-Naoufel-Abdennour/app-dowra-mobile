import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stockage chiffré du jeton (Keychain iOS, Keystore Android).
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _key = 'dowra_token';
  String? _cache;

  Future<String?> read() async => _cache ??= await _storage.read(key: _key);

  Future<void> write(String token) async {
    _cache = token;
    await _storage.write(key: _key, value: token);
  }

  Future<void> clear() async {
    _cache = null;
    await _storage.delete(key: _key);
  }
}

/// Petit stockage clé-valeur local (préférences non sensibles : langue, affichage, écran de bienvenue vu).
class LocalPrefs {
  LocalPrefs([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {
      // Préférence non critique : on continue sans la garder.
    }
  }
}
