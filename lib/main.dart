import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/providers.dart';
import 'core/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Noms des jours et des mois en français, arabe (chiffres latins, ar_DZ) et anglais.
  await initializeDateFormatting();

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
