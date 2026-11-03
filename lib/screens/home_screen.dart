import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/models.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';

/// Photo des wilayas de départ (code de la wilaya).
const _wilayaPhotos = {16: 'w-maqam', 31: 'w-oran', 25: 'w-constantine'};

/// Accueil (écran 3) : « Salam, on sort où ? », recherche, mise en avant, types de sortie, envies, villes de départ.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final user = ref.watch(sessionProvider).value;
    final types = ref.watch(outingTypesProvider);
    final categories = ref.watch(categoriesProvider);
    final wilayas = ref.watch(wilayasProvider);
    final hello = user?.name?.trim().isNotEmpty == true ? t.homeHello(user!.firstName) : t.homeHelloGuest;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(outingTypesProvider);
          ref.invalidate(categoriesProvider);
          ref.invalidate(wilayasProvider);
        },
        child: ListView(padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 14, 20, 120), children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (user?.wilayaName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [
                      Icon(Icons.place_outlined, size: 16, color: palette.muted),
                      const SizedBox(width: 4),
                      Text(user!.wilayaName!, style: TextStyle(color: palette.muted, fontSize: 13, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                Text(hello, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
                BrandTitle(t.homeQuestion, t.homeQuestionEm, size: 24),
              ]),
            ),
            const Dowri(DowriMood.carte, size: 86),
          ]),
          const SizedBox(height: 16),
          Material(
            color: palette.surface,
            shape: StadiumBorder(side: BorderSide(color: palette.line)),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => context.go('/explorer'),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 6, 6, 6),
                child: Row(children: [
                  Icon(Icons.search_rounded, color: palette.muted),
                  const SizedBox(width: 10),
                  Expanded(child: Text(t.searchHint, style: TextStyle(color: palette.muted))),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(gradient: DowraColors.gradient, shape: BoxShape.circle),
                    child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                  ),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _HeroBanner(kicker: t.heroKicker, title: t.heroTitle, text: t.heroText),
          const SizedBox(height: 26),
          SectionHeader(t.typesTitle, action: t.seeAll, onAction: () => context.go('/explorer')),
          const SizedBox(height: 6),
          types.when(
            data: (list) => list.isEmpty
                ? Text(t.emptyReferentials, style: TextStyle(color: palette.muted))
                : SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => _TypeChip(type: list[i], onTap: () => context.go('/explorer')),
                    ),
                  ),
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => RetryCard(onRetry: () => ref.invalidate(outingTypesProvider)),
          ),
          const SizedBox(height: 26),
          SectionHeader(t.interestsTitle),
          const SizedBox(height: 10),
          categories.when(
            data: (list) => Wrap(spacing: 8, runSpacing: 10, children: [
              for (final category in list)
                Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 14, 5),
                  decoration: BoxDecoration(
                    color: user?.interests.contains(category.slug) == true ? palette.pale : palette.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: user?.interests.contains(category.slug) == true ? palette.accent : palette.line),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    CategoryDot(icon: category.icon, color: category.color, size: 28),
                    const SizedBox(width: 8),
                    Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  ]),
                ),
            ]),
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 26),
          SectionHeader(t.citiesTitle),
          const SizedBox(height: 10),
          wilayas.when(
            data: (list) => SizedBox(
              height: 190,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final w in list.where((w) => w.isActive)) Padding(padding: const EdgeInsetsDirectional.only(end: 12), child: _CityCard(wilaya: w, openLabel: t.open)),
              ]),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ]),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.kicker, required this.title, required this.text});

  final String kicker;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 200),
        child: Stack(children: [
          Positioned.fill(child: Image.asset('assets/photos/w-taghit.jpg', fit: BoxFit.cover, semanticLabel: 'Taghit')),
          const Positioned.fill(child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x001A0833), Color(0xE61A0833)], stops: [0.25, 1]),
            ),
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 80, 18, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: DowraColors.sun, borderRadius: BorderRadius.circular(999)),
                child: Text(kicker, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: DowraColors.ink)),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800, height: 1.2)),
              const SizedBox(height: 4),
              Text(text, style: const TextStyle(color: Color(0xD9FFFFFF), fontSize: 13, height: 1.4)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type, required this.onTap});

  final OutingType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surface,
      shape: StadiumBorder(side: BorderSide(color: palette.line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(children: [
            Icon(iconFor(type.icon), size: 18, color: palette.accent),
            const SizedBox(width: 7),
            Text(type.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
          ]),
        ),
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({required this.wilaya, required this.openLabel});

  final Wilaya wilaya;
  final String openLabel;

  @override
  Widget build(BuildContext context) {
    final photo = _wilayaPhotos[wilaya.code];
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 160,
        child: Stack(fit: StackFit.expand, children: [
          if (photo != null)
            Image.asset('assets/photos/$photo.jpg', fit: BoxFit.cover)
          else
            const DecoratedBox(decoration: BoxDecoration(gradient: DowraColors.gradient)),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x001A0833), Color(0xD91A0833)], stops: [0.4, 1]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: DowraColors.sun, borderRadius: BorderRadius.circular(999)),
                child: Text(openLabel, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: DowraColors.ink)),
              ),
              const Spacer(),
              Text(wilaya.code.toString().padLeft(2, '0'), textDirection: TextDirection.ltr, style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12, fontWeight: FontWeight.w600)),
              Text(wilaya.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            ]),
          ),
        ]),
      ),
    );
  }
}
