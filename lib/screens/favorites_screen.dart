import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/catalogue_providers.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';
import '../widgets/event_card.dart';

/// Mes favoris (écran 11) : sorties gardées, à venir d'abord ; connexion demandée à un visiteur.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final signedIn = ref.watch(sessionProvider).value != null;
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(favoritesProvider),
        child: ListView(padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 14, 20, 120), children: [
          BrandTitle(t.favoritesTitle, t.favoritesTitleEm, size: 30),
          const SizedBox(height: 20),
          if (!signedIn)
            const GuestInvite()
          else
            favorites.when(
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator())),
              error: (_, _) => RetryCard(onRetry: () => ref.invalidate(favoritesProvider)),
              data: (list) => list.isEmpty
                  ? DowriCard(mood: DowriMood.content, text: t.favoritesEmpty)
                  : Column(children: [
                      for (final event in list)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Opacity(opacity: event.nextSessionAt == null ? 0.55 : 1, child: EventRowTile(event: event)),
                        ),
                    ]),
            ),
        ]),
      ),
    );
  }
}
