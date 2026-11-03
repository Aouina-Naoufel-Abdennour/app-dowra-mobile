import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'catalogue.dart';
import 'providers.dart';

/// Wilaya choisie (code) : celle du compte, sinon celle choisie sur le téléphone, sinon toute l'Algérie.
final preferredWilayaProvider = NotifierProvider<PreferredWilaya, int?>(PreferredWilaya.new);

class PreferredWilaya extends Notifier<int?> {
  static const key = 'dowra_wilaya';

  @override
  int? build() {
    final user = ref.watch(sessionProvider).value;
    final wilayas = ref.watch(wilayasProvider).value ?? const [];
    if (user?.wilayaId != null) {
      for (final wilaya in wilayas) {
        if (wilaya.id == user!.wilayaId) return wilaya.code;
      }
    }
    _restore();
    return null;
  }

  Future<void> _restore() async {
    final stored = int.tryParse(await ref.read(localPrefsProvider).read(key) ?? '');
    if (stored != null && stored != state) state = stored;
  }

  /// Change la wilaya ; sur le compte aussi si l'utilisateur est connecté.
  void set(int? code) {
    state = code;
    ref.read(localPrefsProvider).write(key, code?.toString() ?? '');
    final wilayas = ref.read(wilayasProvider).value ?? const [];
    final id = wilayas.where((w) => w.code == code).map((w) => w.id).firstOrNull;
    if (ref.read(sessionProvider).value != null) {
      ref.read(sessionProvider.notifier).updateProfile({'wilaya_id': id}).ignore();
    }
  }
}

final homeProvider = FutureProvider<HomeData>((ref) {
  ref.watch(localeProvider);
  return ref.watch(repositoryProvider).home(wilaya: ref.watch(preferredWilayaProvider));
});

final eventProvider = FutureProvider.family<EventDetail, String>((ref, slug) {
  ref.watch(localeProvider);
  ref.watch(sessionProvider);
  return ref.watch(repositoryProvider).event(slug);
});

final similarProvider = FutureProvider.family<List<EventCard>, String>((ref, slug) {
  ref.watch(localeProvider);
  return ref.watch(repositoryProvider).similar(slug);
});

final organizerProvider = FutureProvider.family<OrganizerPage, String>((ref, slug) {
  ref.watch(localeProvider);
  ref.watch(sessionProvider);
  return ref.watch(repositoryProvider).organizer(slug);
});

/// Favoris du compte connecté (vide pour un visiteur).
final favoritesProvider = FutureProvider<List<EventCard>>((ref) async {
  ref.watch(localeProvider);
  if (ref.watch(sessionProvider).value == null) return const [];
  return ref.watch(repositoryProvider).favorites();
});

/// Filtres de l'onglet Explorer, partagés avec l'accueil (types, envies, « Tout voir »).
final exploreFiltersProvider = NotifierProvider<ExploreFilters, EventFilters>(ExploreFilters.new);

class ExploreFilters extends Notifier<EventFilters> {
  @override
  EventFilters build() => EventFilters(wilaya: ref.read(preferredWilayaProvider));

  void set(EventFilters filters) => state = filters;
}

/// Résultats d'Explorer, page après page (défilement infini).
class ExploreResults {
  const ExploreResults({this.events = const [], this.total = 0, this.page = 0, this.lastPage = 1, this.loading = false, this.error = false});

  final List<EventCard> events;
  final int total;
  final int page;
  final int lastPage;
  final bool loading;
  final bool error;

  bool get hasMore => page < lastPage;
}

final exploreResultsProvider = NotifierProvider<ExploreResultsNotifier, ExploreResults>(ExploreResultsNotifier.new);

class ExploreResultsNotifier extends Notifier<ExploreResults> {
  @override
  ExploreResults build() {
    ref.watch(exploreFiltersProvider);
    ref.watch(localeProvider);
    Future.microtask(loadMore);
    return const ExploreResults(loading: true);
  }

  Future<void> loadMore() async {
    if (state.page > 0 && (!state.hasMore || state.loading)) return;
    final filters = ref.read(exploreFiltersProvider);
    final page = state.page + 1;
    state = ExploreResults(events: state.events, total: state.total, page: state.page, lastPage: state.lastPage, loading: true);
    try {
      final result = await ref.read(repositoryProvider).events(filters, page: page);
      if (ref.read(exploreFiltersProvider) != filters) return;
      state = ExploreResults(events: [...state.events, ...result.events], total: result.total, page: page, lastPage: result.lastPage);
    } catch (_) {
      state = ExploreResults(events: state.events, total: state.total, page: state.page, lastPage: state.lastPage, error: true);
    }
  }
}

final mapPointsProvider = FutureProvider<List<MapPoint>>((ref) {
  ref.watch(localeProvider);
  return ref.watch(repositoryProvider).mapPoints(ref.watch(exploreFiltersProvider));
});
