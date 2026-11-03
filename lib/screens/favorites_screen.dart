import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';

/// Mes favoris (écran 11) : vide jusqu'au catalogue (lot 1) ; connexion demandée à un visiteur.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final signedIn = ref.watch(sessionProvider).value != null;

    return Scaffold(
      body: ListView(padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 14, 20, 120), children: [
        BrandTitle(t.favoritesTitle, t.favoritesTitleEm, size: 30),
        const SizedBox(height: 20),
        signedIn ? DowriCard(mood: DowriMood.content, text: t.favoritesEmpty) : const GuestInvite(),
      ]),
    );
  }
}
