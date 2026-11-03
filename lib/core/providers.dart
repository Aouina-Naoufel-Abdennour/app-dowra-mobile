import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'models.dart';
import 'repository.dart';
import 'storage.dart';

const supportedLocales = ['fr', 'ar', 'en'];
const localeLabels = {'fr': 'Français', 'ar': 'العربية', 'en': 'English'};

final localPrefsProvider = Provider<LocalPrefs>((ref) => LocalPrefs());
final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

/// Préférences lues au démarrage (avant le premier écran), passées par main.dart.
class StartupPrefs {
  const StartupPrefs({required this.locale, required this.themeMode, required this.introSeen});

  final String? locale;
  final String? themeMode;
  final bool introSeen;
}

final startupPrefsProvider = Provider<StartupPrefs>((ref) => const StartupPrefs(locale: null, themeMode: null, introSeen: false));

/// Langue de l'app ('fr', 'ar', 'en'), gardée sur le téléphone et envoyée au compte (langue des SMS et notifications).
final localeProvider = NotifierProvider<LocaleNotifier, String>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<String> {
  static const key = 'dowra_locale';

  @override
  String build() {
    final stored = ref.read(startupPrefsProvider).locale;
    if (stored != null && supportedLocales.contains(stored)) return stored;
    final device = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return supportedLocales.contains(device) ? device : 'fr';
  }

  void set(String locale) {
    if (!supportedLocales.contains(locale)) return;
    state = locale;
    ref.read(localPrefsProvider).write(key, locale);
    // Le compte garde la langue, et ses libellés (wilaya, niveau) reviennent dans la nouvelle langue.
    if (ref.read(sessionProvider).value != null) {
      ref.read(sessionProvider.notifier).updateProfile({'locale': locale}).ignore();
    }
  }
}

/// Mode d'affichage : 'clair', 'sombre' ou 'systeme' (mêmes valeurs que l'API).
final themeModeProvider = NotifierProvider<ThemeModeNotifier, String>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<String> {
  static const key = 'dowra_theme';
  static const modes = ['clair', 'sombre', 'systeme'];

  @override
  String build() {
    final stored = ref.read(startupPrefsProvider).themeMode;
    return modes.contains(stored) ? stored! : 'systeme';
  }

  /// [sync] : false quand le mode vient déjà du compte (connexion), pour ne pas le renvoyer.
  void set(String mode, {bool sync = true}) {
    if (!modes.contains(mode)) return;
    state = mode;
    ref.read(localPrefsProvider).write(key, mode);
    if (sync && ref.read(sessionProvider).value != null) {
      ref.read(repositoryProvider).updateProfile({'theme_mode': mode}).ignore();
    }
  }
}

ThemeMode flutterThemeMode(String mode) => switch (mode) {
      'clair' => ThemeMode.light,
      'sombre' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

/// Écran de bienvenue déjà vu (il ne s'affiche qu'au premier lancement).
final introSeenProvider = NotifierProvider<IntroSeenNotifier, bool>(IntroSeenNotifier.new);

class IntroSeenNotifier extends Notifier<bool> {
  static const key = 'dowra_intro_seen';

  @override
  bool build() => ref.read(startupPrefsProvider).introSeen;

  void markSeen() {
    state = true;
    ref.read(localPrefsProvider).write(key, '1');
  }
}

/// Client HTTP de l'API Dowra (jeton et langue ajoutés à chaque requête).
final dioProvider = Provider<Dio>((ref) {
  final tokens = ref.watch(tokenStorageProvider);
  return createDio(baseUrl: defaultApiUrl(), token: tokens.read, locale: () => ref.read(localeProvider));
});

final repositoryProvider = Provider<DowraRepository>((ref) => DowraRepository(ref.watch(dioProvider), ref.watch(tokenStorageProvider)));

/// Compte connecté (null pour un visiteur).
final sessionProvider = AsyncNotifierProvider<SessionNotifier, DowraUser?>(SessionNotifier.new);

class SessionNotifier extends AsyncNotifier<DowraUser?> {
  @override
  Future<DowraUser?> build() async {
    try {
      final user = await ref.read(repositoryProvider).currentUser();
      if (user != null) _applyPreferences(user);
      return user;
    } on ApiException {
      // Serveur injoignable au lancement : l'app s'ouvre en visiteur, la session reste gardée.
      return null;
    }
  }

  /// Le mode d'affichage du compte suit l'utilisateur sur ce téléphone.
  void _applyPreferences(DowraUser user) => ref.read(themeModeProvider.notifier).set(user.themeMode, sync: false);

  void signedIn(DowraUser user) {
    _applyPreferences(user);
    // Le compte prend la langue choisie dans l'app (SMS et notifications dans cette langue).
    final locale = ref.read(localeProvider);
    state = AsyncData(user);
    if (user.locale != locale) ref.read(repositoryProvider).updateProfile({'locale': locale}).ignore();
  }

  Future<DowraUser> updateProfile(Map<String, Object?> fields) async {
    final user = await ref.read(repositoryProvider).updateProfile(fields);
    state = AsyncData(user);
    return user;
  }

  Future<void> logout() async {
    await ref.read(repositoryProvider).logout();
    state = const AsyncData(null);
  }

  Future<void> deleteAccount() async {
    await ref.read(repositoryProvider).deleteAccount();
    state = const AsyncData(null);
  }
}

/// Référentiels publics, rechargés quand la langue change (noms traduits par l'API).
final outingTypesProvider = FutureProvider<List<OutingType>>((ref) {
  ref.watch(localeProvider);
  return ref.watch(repositoryProvider).outingTypes();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  ref.watch(localeProvider);
  return ref.watch(repositoryProvider).categories();
});

final wilayasProvider = FutureProvider<List<Wilaya>>((ref) {
  ref.watch(localeProvider);
  return ref.watch(repositoryProvider).wilayas();
});

/// Direction du texte selon la langue (seul l'arabe s'écrit de droite à gauche).
TextDirection directionOf(String locale) => locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;
