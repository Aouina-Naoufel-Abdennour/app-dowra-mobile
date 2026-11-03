import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Données gardées sur le téléphone pour fonctionner sans réseau : billets (4.5) et listes du mode scan (7.4).
class OfflineStore {
  OfflineStore([SharedPreferencesAsync? prefs]) : _prefs = prefs;

  SharedPreferencesAsync? _prefs;
  SharedPreferencesAsync get prefs => _prefs ??= SharedPreferencesAsync();

  Future<Object?> readJson(String key) async {
    try {
      final raw = await prefs.getString(key);
      return raw == null ? null : jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> writeJson(String key, Object? value) async {
    try {
      await prefs.setString(key, jsonEncode(value));
    } catch (_) {
      // Sans stockage, l'app continue en ligne.
    }
  }

  /// Déconnexion : billets et listes de scan effacés du téléphone.
  Future<void> clear() async {
    try {
      final keys = await prefs.getKeys();
      for (final key in keys.where((k) => k.startsWith('dowra_offline_'))) {
        await prefs.remove(key);
      }
    } catch (_) {}
  }
}
