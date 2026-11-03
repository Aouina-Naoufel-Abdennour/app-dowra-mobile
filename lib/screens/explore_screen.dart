import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';

/// Explorer (écran 4) : les types de sortie de l'API ; les sorties et les filtres arrivent avec le catalogue (lot 1).
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final types = ref.watch(outingTypesProvider);

    return Scaffold(
      body: ListView(padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 14, 20, 120), children: [
        Text(t.exploreTitle, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(t.exploreLead, style: TextStyle(color: palette.muted, height: 1.5)),
        const SizedBox(height: 18),
        types.when(
          data: (list) => list.isEmpty
              ? DowriCard(mood: DowriMood.repos, text: t.emptyReferentials)
              : Column(children: [
                  for (final type in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: palette.surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: palette.line)),
                        child: Row(children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(gradient: DowraColors.gradient, borderRadius: BorderRadius.circular(16)),
                            child: Icon(iconFor(type.icon), color: Colors.white),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(type.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
                              const SizedBox(height: 2),
                              Text(type.bookingLabel, style: TextStyle(color: palette.muted, fontSize: 13)),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                ]),
          loading: () => const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
          error: (_, _) => RetryCard(onRetry: () => ref.invalidate(outingTypesProvider)),
        ),
      ]),
    );
  }
}
