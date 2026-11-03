import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';

/// Mes billets (écran 10) : vide jusqu'à la billetterie (lot 2) ; connexion demandée à un visiteur.
class TicketsScreen extends ConsumerWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final signedIn = ref.watch(sessionProvider).value != null;

    return Scaffold(
      body: ListView(padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 14, 20, 120), children: [
        BrandTitle(t.ticketsTitle, t.ticketsTitleEm, size: 30),
        const SizedBox(height: 20),
        signedIn ? DowriCard(mood: DowriMood.billet, text: t.ticketsEmpty) : const GuestInvite(),
      ]),
    );
  }
}
