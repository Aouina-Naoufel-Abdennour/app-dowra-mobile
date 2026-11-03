import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'bookings.dart';
import 'providers.dart';

/// Places restantes d'une sortie, en direct.
final availabilityProvider = FutureProvider.family<Availability, String>((ref, slug) {
  ref.watch(localeProvider);
  ref.watch(sessionProvider);
  return ref.watch(repositoryProvider).availability(slug);
});

/// Liste de billets ; [offline] quand elle vient de la copie gardée sur le téléphone.
typedef BookingList = ({List<Booking> bookings, bool offline});

/// « Mes billets » ('upcoming' ou 'past') : chaque réponse est gardée sur le téléphone, et relue sans réseau.
final bookingsProvider = FutureProvider.family<BookingList, String>((ref, scope) async {
  ref.watch(localeProvider);
  if (ref.watch(sessionProvider).value == null) return (bookings: <Booking>[], offline: false);
  final store = ref.read(offlineStoreProvider);
  final key = 'dowra_offline_bookings_$scope';
  try {
    final list = await ref.watch(repositoryProvider).bookingsJson(scope);
    await store.writeJson(key, list);
    for (final item in list) {
      await store.writeJson('dowra_offline_booking_${item['code']}', item);
    }
    return (bookings: [for (final item in list) Booking.fromJson(item)], offline: false);
  } on ApiException catch (e) {
    final cached = await store.readJson(key);
    if (!e.isNetwork || cached is! List) rethrow;
    return (bookings: [for (final item in cached) Booking.fromJson(Map<String, dynamic>.from(item as Map))], offline: true);
  }
});

/// Un billet, avec la même copie hors connexion.
final bookingProvider = FutureProvider.family<({Booking booking, bool offline}), String>((ref, code) async {
  ref.watch(localeProvider);
  final store = ref.read(offlineStoreProvider);
  final key = 'dowra_offline_booking_$code';
  try {
    final json = await ref.watch(repositoryProvider).bookingJson(code);
    await store.writeJson(key, json);
    return (booking: Booking.fromJson(json), offline: false);
  } on ApiException catch (e) {
    final cached = await store.readJson(key);
    if (!e.isNetwork || cached is! Map) rethrow;
    return (booking: Booking.fromJson(Map<String, dynamic>.from(cached)), offline: true);
  }
});

/// Séances que ce compte peut contrôler (mode scan).
final scanSessionsProvider = FutureProvider<List<ScanSession>>((ref) {
  ref.watch(sessionProvider);
  return ref.watch(repositoryProvider).scanSessions();
});

/// Rôles qui ouvrent le mode scan : organisateurs, leur équipe et l'équipe Dowra.
const scanRoles = {'organisateur', 'membre_organisateur', 'super_admin', 'moderateur'};

final giftOptionsProvider = FutureProvider<GiftOptions>((ref) => ref.watch(repositoryProvider).giftOptions());

final myGiftCardsProvider = FutureProvider<List<GiftCard>>((ref) async {
  if (ref.watch(sessionProvider).value == null) return const [];
  return ref.watch(repositoryProvider).myGiftCards();
});
