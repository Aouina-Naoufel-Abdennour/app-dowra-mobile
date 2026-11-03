import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/catalogue.dart';
import '../core/catalogue_providers.dart';
import '../core/models.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';
import '../widgets/event_card.dart';
import '../widgets/wilaya_picker.dart';

/// Accueil (écran 3) : « Salam, on sort où ? », recherche, à la une, ce week-end, types, Wilaya du jour, Trésors cachés, envies.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _explore(BuildContext context, WidgetRef ref, EventFilters Function(EventFilters) change) {
    final base = EventFilters(wilaya: ref.read(preferredWilayaProvider));
    ref.read(exploreFiltersProvider.notifier).set(change(base));
    context.go('/explorer');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final user = ref.watch(sessionProvider).value;
    final home = ref.watch(homeProvider);
    final types = ref.watch(outingTypesProvider);
    final categories = ref.watch(categoriesProvider);
    final hello = user?.name?.trim().isNotEmpty == true ? t.homeHello(user!.firstName) : t.homeHelloGuest;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeProvider);
          ref.invalidate(outingTypesProvider);
          ref.invalidate(categoriesProvider);
          await ref.read(homeProvider.future).catchError((_) => const HomeData(featured: [], weekend: [], hiddenGems: [], recent: []));
        },
        child: ListView(padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 10, 20, 120), children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const WilayaPickerButton(),
                Text(hello, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
                BrandTitle(t.homeQuestion, t.homeQuestionEm, size: 24),
              ]),
            ),
            const Dowri(DowriMood.carte, size: 86),
          ]),
          const SizedBox(height: 16),
          _SearchBar(onTap: () => context.go('/explorer'), hint: t.searchHint),
          const SizedBox(height: 18),
          home.when(
            loading: () => const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
            error: (_, _) => RetryCard(onRetry: () => ref.invalidate(homeProvider)),
            data: (data) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (data.featured.isNotEmpty) _Featured(event: data.featured.first),
              const SizedBox(height: 22),
              types.maybeWhen(
                data: (list) => SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => ActionChip(
                      avatar: Icon(iconFor(list[i].icon), size: 18, color: palette.accent),
                      label: Text(list[i].name),
                      shape: StadiumBorder(side: BorderSide(color: palette.line)),
                      backgroundColor: palette.surface,
                      onPressed: () => _explore(context, ref, (f) => f.copyWith(type: list[i].slug)),
                    ),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              EventSection(title: t.weekendTitle, events: data.weekend, onSeeAll: () => _explore(context, ref, (f) => f.copyWith(when: 'weekend'))),
              const SizedBox(height: 24),
              EventSection(title: t.featuredTitle, events: data.featured.skip(1).toList(), onSeeAll: () => _explore(context, ref, (f) => f.copyWith(sort: 'popular'))),
              if (data.wilayaOfDay != null) ...[
                const SizedBox(height: 24),
                _WilayaOfDay(data: data.wilayaOfDay!, onTap: () => _explore(context, ref, (f) => f.copyWith(wilaya: data.wilayaOfDay!.code))),
              ],
              const SizedBox(height: 24),
              EventSection(title: t.gemsTitle, events: data.hiddenGems, onSeeAll: () => _explore(context, ref, (f) => f.copyWith(hiddenGem: true))),
              const SizedBox(height: 24),
              EventSection(title: t.newTitle, events: data.recent),
            ]),
          ),
          const SizedBox(height: 24),
          SectionHeader(t.interestsTitle),
          const SizedBox(height: 10),
          categories.maybeWhen(
            data: (list) => Wrap(spacing: 8, runSpacing: 10, children: [
              for (final category in list) _CategoryChip(category: category, selected: user?.interests.contains(category.slug) == true, onTap: () => _explore(context, ref, (f) => f.copyWith(category: category.slug))),
            ]),
            orElse: () => const SizedBox.shrink(),
          ),
        ]),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap, required this.hint});

  final VoidCallback onTap;
  final String hint;

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
          padding: const EdgeInsetsDirectional.fromSTEB(18, 6, 6, 6),
          child: Row(children: [
            Icon(Icons.search_rounded, color: palette.muted),
            const SizedBox(width: 10),
            Expanded(child: Text(hint, style: TextStyle(color: palette.muted))),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(gradient: DowraColors.gradient, shape: BoxShape.circle),
              child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Grande carte « à la une » (maquette : photo, label promo, titre, départ).
class _Featured extends StatelessWidget {
  const _Featured({required this.event});

  final EventCard event;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Material(
        child: InkWell(
          onTap: () => context.push('/sorties/${event.slug}'),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 200),
            child: Stack(children: [
              Positioned.fill(child: EventCover(url: event.cover?.card, icon: event.typeIcon)),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x001A0833), Color(0xE61A0833)], stops: [0.3, 1]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 90, 18, 18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  PhotoBadge(t.badgeFeatured, sun: true),
                  const SizedBox(height: 8),
                  Text(event.title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800, height: 1.2)),
                  const SizedBox(height: 4),
                  Text([event.typeName, event.wilayaName].join(' · '), style: const TextStyle(color: Color(0xD9FFFFFF), fontSize: 13)),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _WilayaOfDay extends StatelessWidget {
  const _WilayaOfDay({required this.data, required this.onTap});

  final ({int code, String name, String? headline, String? text, Sizes? photo, List<EventCard> events}) data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Material(
        color: DowraColors.mauve950,
        child: InkWell(
          onTap: onTap,
          child: Stack(children: [
            if (data.photo != null) Positioned.fill(child: Opacity(opacity: 0.4, child: EventCover(url: data.photo!.card))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                PhotoBadge(t.wilayaOfDay, sun: true),
                const SizedBox(height: 10),
                Text(data.headline ?? data.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.2)),
                if (data.text != null) ...[
                  const SizedBox(height: 6),
                  Text(data.text!, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xD9FFFFFF), height: 1.45)),
                ],
                const SizedBox(height: 14),
                Row(children: [
                  Text(t.seeOutingsIn(data.name), style: const TextStyle(color: DowraColors.sun, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, color: DowraColors.sun, size: 18),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category, required this.selected, required this.onTap});

  final Category category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: selected ? palette.pale : palette.surface,
      shape: StadiumBorder(side: BorderSide(color: selected ? palette.accent : palette.line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 14, 5),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            CategoryDot(icon: category.icon, color: category.color, size: 28),
            const SizedBox(width: 8),
            Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
          ]),
        ),
      ),
    );
  }
}
