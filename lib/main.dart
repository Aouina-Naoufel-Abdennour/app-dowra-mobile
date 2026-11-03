import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/providers.dart';
import 'core/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Langue, affichage et écran de bienvenue lus avant le premier écran (pas de clignotement).
  final prefs = LocalPrefs();
  final startup = StartupPrefs(
    locale: await prefs.read(LocaleNotifier.key),
    themeMode: await prefs.read(ThemeModeNotifier.key),
    introSeen: await prefs.read(IntroSeenNotifier.key) == '1',
  );

  runApp(ProviderScope(
    overrides: [startupPrefsProvider.overrideWithValue(startup)],
    child: const DowraApp(),
  ));
}
