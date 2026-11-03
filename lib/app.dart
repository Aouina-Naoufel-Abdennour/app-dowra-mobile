import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';
import 'theme/theme.dart';

class DowraApp extends ConsumerWidget {
  const DowraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final mode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Dowra',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: dowraTheme(brightness: Brightness.light, locale: locale),
      darkTheme: dowraTheme(brightness: Brightness.dark, locale: locale),
      themeMode: flutterThemeMode(mode),
    );
  }
}
