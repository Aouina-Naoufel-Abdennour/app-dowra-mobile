import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../core/catalogue.dart';
import '../core/catalogue_providers.dart';
import '../core/format.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/event_card.dart';
import '../widgets/events_map.dart';

/// Explorer et filtres (écrans 4 et 5) : recherche, filtres rapides, filtres complets, liste ou carte, près de moi.
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late final _search = TextEditingController(text: ref.read(exploreFiltersProvider).q ?? '');
  final _scroll = ScrollController();
  bool _map = false;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 400) ref.read(exploreResultsProvider.notifier).loadMore();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  EventFilters get _filters => ref.read(exploreFiltersProvider);

  void _set(EventFilters filters) => ref.read(exploreFiltersProvider.notifier).set(filters);

  Future<void> _nearMe() async {
    final t = AppLocalizations.of(context);
    if (_filters.nearMe) {
      _set(_filters.copyWith(lat: null, lng: null, sort: null));
      return;
    }
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) throw Exception('denied');
      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 12)));
      _set(_filters.copyWith(lat: position.latitude, lng: position.longitude, wilaya: null, sort: 'distance'));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.nearMeError)));
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final filters = ref.watch(exploreFiltersProvider);
    final results = ref.watch(exploreResultsProvider);
    final lang = ref.watch(localeProvider);

    final quick = [
      (t.nearMe, filters.nearMe, _nearMe, Icons.my_location_rounded),
      (t.whenWeekend, filters.when == 'weekend', () => _set(filters.copyWith(when: filters.when == 'weekend' ? null : 'weekend')), Icons.event_rounded),
      (t.priceFree, filters.price == 'free', () => _set(filters.copyWith(price: filters.price == 'free' ? null : 'free')), Icons.redeem_outlined),
      (t.family, filters.family, () => _set(filters.copyWith(family: !filters.family)), Icons.groups_outlined),
      (t.hiddenGem, filters.hiddenGem, () => _set(filters.copyWith(hiddenGem: !filters.hiddenGem)), Icons.diamond_outlined),
    ];

    return Scaffold(
      body: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 10, 16, 8),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: t.searchOutings,
                  prefixIcon: const Icon(Icons.search_rounded),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide(color: palette.line)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide(color: palette.line)),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _search.clear();
                            _set(filters.copyWith(q: null));
                          },
                        ),
                ),
                onSubmitted: (value) => _set(filters.copyWith(q: value.trim().isEmpty ? null : value.trim())),
              ),
            ),
            const SizedBox(width: 8),
            Badge(
              isLabelVisible: filters.activeCount > 0,
              label: Text('${filters.activeCount}'),
              backgroundColor: DowraColors.rose,
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: Ink(
                  decoration: const BoxDecoration(gradient: DowraColors.gradient),
                  child: IconButton(icon: const Icon(Icons.tune_rounded, color: Colors.white), tooltip: t.filters, onPressed: () => _openFilters(context)),
                ),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 46,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: quick.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => ChoicePill(
              label: quick[i].$1,
              selected: quick[i].$2,
              onTap: quick[i].$3,
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: i == 0 && _locating
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(quick[i].$4, size: 17, color: quick[i].$2 ? Colors.white : palette.accent),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 12, 4),
          child: Row(children: [
            Expanded(child: Text(results.loading && results.page == 0 ? '…' : t.resultsCount(results.total), style: const TextStyle(fontWeight: FontWeight.w800))),
            SegmentedButton<bool>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(visualDensity: VisualDensity.compact, selectedBackgroundColor: DowraColors.mauve600, selectedForegroundColor: Colors.white),
              segments: [
                ButtonSegment(value: false, icon: const Icon(Icons.view_list_rounded, size: 18), label: Text(t.listView)),
                ButtonSegment(value: true, icon: const Icon(Icons.map_outlined, size: 18), label: Text(t.mapView)),
              ],
              selected: {_map},
              onSelectionChanged: (value) => setState(() => _map = value.first),
            ),
          ]),
        ),
        Expanded(
          child: _map
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ref.watch(mapPointsProvider).when(
                          data: (points) => EventsMap(pins: [
                            for (final point in points)
                              MapPin(
                                lat: point.lat,
                                lng: point.lng,
                                label: point.priceFrom == 0 ? t.free : (point.priceFrom == null ? point.title : formatPrice(lang, point.priceFrom!)),
                                onTap: () => context.push('/sorties/${point.slug}'),
                              ),
                          ]),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (_, _) => RetryCard(onRetry: () => ref.invalidate(mapPointsProvider)),
                        ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => ref.invalidate(exploreResultsProvider),
                  child: results.error && results.events.isEmpty
                      ? ListView(padding: const EdgeInsets.all(16), children: [RetryCard(onRetry: () => ref.invalidate(exploreResultsProvider))])
                      : !results.loading && results.events.isEmpty
                          ? ListView(padding: const EdgeInsets.all(16), children: [DowriCard(mood: DowriMood.carte, text: t.noResults)])
                          : ListView.separated(
                              controller: _scroll,
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
                              itemCount: results.events.length + (results.hasMore || results.loading ? 1 : 0),
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (_, i) => i < results.events.length
                                  ? EventRowTile(event: results.events[i])
                                  : const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator())),
                            ),
                ),
        ),
      ]),
    );
  }

  void _openFilters(BuildContext context) {
    showModalBottomSheet<void>(context: context, isScrollControlled: true, builder: (_) => _FiltersSheet(initial: _filters, onApply: _set));
  }
}

/// Filtres complets : wilaya, quand, envie, type, prix, cadre, publics, tri.
class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet({required this.initial, required this.onApply});

  final EventFilters initial;
  final ValueChanged<EventFilters> onApply;

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  late EventFilters _f = widget.initial;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final wilayas = ref.watch(wilayasProvider).value ?? const [];
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final types = ref.watch(outingTypesProvider).value ?? const [];
    Widget title(String text) => Padding(padding: const EdgeInsets.only(top: 18, bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)));
    Widget pills<T>(List<(T?, String)> options, T? value, ValueChanged<T?> onChanged) => Wrap(spacing: 8, runSpacing: 8, children: [
          for (final (v, label) in options) ChoicePill(label: label, selected: value == v, onTap: () => onChanged(value == v ? null : v)),
        ]);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (_, controller) => Column(children: [
        Expanded(
          child: ListView(controller: controller, padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), children: [
            Text(t.filters, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            title(t.chooseWilayaTitle),
            DropdownButtonFormField<int?>(
              initialValue: _f.wilaya,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: null, child: Text(t.allAlgeria)),
                for (final w in [...wilayas.where((w) => w.isActive), ...wilayas.where((w) => !w.isActive)]) DropdownMenuItem(value: w.code, child: Text(w.label)),
              ],
              onChanged: (value) => setState(() => _f = _f.copyWith(wilaya: value, lat: null, lng: null)),
            ),
            title(t.when),
            pills([('today', t.whenToday), ('tomorrow', t.whenTomorrow), ('weekend', t.whenWeekend), ('week', t.whenWeek), ('month', t.whenMonth)], _f.when, (v) => setState(() => _f = _f.copyWith(when: v))),
            title(t.category),
            pills([for (final c in categories) (c.slug, c.name)], _f.category, (v) => setState(() => _f = _f.copyWith(category: v))),
            title(t.type),
            pills([for (final type in types) (type.slug, type.name)], _f.type, (v) => setState(() => _f = _f.copyWith(type: v))),
            title(t.price),
            pills([('free', t.priceFree), ('under_2000', t.priceUnder2000)], _f.price, (v) => setState(() => _f = _f.copyWith(price: v))),
            title(t.setting),
            pills([('interieur', t.indoor), ('plein_air', t.outdoor)], _f.setting, (v) => setState(() => _f = _f.copyWith(setting: v))),
            const SizedBox(height: 10),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(t.family), value: _f.family, onChanged: (v) => setState(() => _f = _f.copyWith(family: v))),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(t.women), value: _f.women, onChanged: (v) => setState(() => _f = _f.copyWith(women: v))),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(t.pmr), value: _f.pmr, onChanged: (v) => setState(() => _f = _f.copyWith(pmr: v))),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(t.hiddenGem), value: _f.hiddenGem, onChanged: (v) => setState(() => _f = _f.copyWith(hiddenGem: v))),
            title(t.sortBy),
            pills([('date', t.sortDate), ('popular', t.sortPopular), ('price_asc', t.sortPriceAsc), if (_f.nearMe) ('distance', t.sortDistance)], _f.sort, (v) => setState(() => _f = _f.copyWith(sort: v))),
          ]),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(children: [
              TextButton(onPressed: () => setState(() => _f = EventFilters(q: _f.q)), child: Text(t.reset)),
              const SizedBox(width: 12),
              Expanded(
                child: GradientButton(
                  label: t.apply,
                  onPressed: () {
                    widget.onApply(_f);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
