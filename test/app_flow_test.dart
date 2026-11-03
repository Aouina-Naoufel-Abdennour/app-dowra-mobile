import 'package:dowra/app.dart';
import 'package:dowra/core/api.dart';
import 'package:dowra/core/bookings.dart';
import 'package:dowra/core/catalogue.dart';
import 'package:dowra/core/models.dart';
import 'package:dowra/core/offline_store.dart';
import 'package:dowra/core/providers.dart';
import 'package:dowra/core/repository.dart';
import 'package:dowra/screens/scan_screen.dart';
import 'package:dowra/l10n/app_localizations.dart';
import 'package:dowra/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements DowraRepository {}

/// Stockage du téléphone en mémoire (billets hors connexion, listes de scan).
class MemoryStore extends OfflineStore {
  final Map<String, Object?> data = {};

  @override
  Future<Object?> readJson(String key) async => data[key];

  @override
  Future<void> writeJson(String key, Object? value) async => data[key] = value;

  @override
  Future<void> clear() async => data.clear();
}

Map<String, dynamic> bookingJson({String status = 'confirmee'}) => {
      'code': 'DW7K3P9Q',
      'status': {'value': status, 'label': status == 'confirmee' ? 'Confirmée' : 'En attente de paiement'},
      'channel': 'en_ligne',
      'is_buyer': true,
      'event': {
        'slug': 'chrea',
        'title': 'Randonnée des cèdres de Chréa',
        'cover': null,
        'place': 'Chréa',
        'wilaya': 'Blida',
        'coordinates': null,
        'organizer': {'slug': 'djazair-rando', 'name': 'Djazaïr Rando', 'phone': null},
        'cancellation_policy': {'value': 'jusqua_48h', 'label': 'Remboursable jusqu\'à 48 heures avant'},
      },
      'session': {'id': 1, 'starts_at': '2026-11-06T07:30:00+01:00', 'label': null},
      'items': [{'ticket_type_id': 1, 'name': 'Participation', 'quantity': 2, 'unit_price': 0}],
      'options': [],
      'total': 0,
      'tickets': [
        {'code': 'TABCDE2345', 'type': 'Participation', 'holder_name': 'Amina', 'status': {'value': 'valide', 'label': 'Valide'}, 'is_mine': true, 'qr': 'DOWRA:TABCDE2345:abcdefghijkl'},
        {'code': 'TFGHJK6789', 'type': 'Participation', 'status': {'value': 'valide', 'label': 'Valide'}, 'is_mine': true, 'qr': 'DOWRA:TFGHJK6789:abcdefghijkl'},
      ],
      'can_cancel': true,
      'calendar_url': 'http://localhost:8000/api/v1/bookings/DW7K3P9Q/calendar.ics',
    };

Map<String, dynamic> eventJson(String slug, String title) => {
      'id': slug.hashCode,
      'slug': slug,
      'title': title,
      'type': {'slug': 'randonnee', 'name': 'Randonnées et nature', 'icon': 'mountain'},
      'wilaya': {'code': 16, 'name': 'Alger'},
      'place': 'Chréa',
      'organizer': {'slug': 'djazair-rando', 'name': 'Djazaïr Rando', 'verified': true},
      'next_session_at': '2026-11-06T07:30:00+01:00',
      'price_from': 1500,
      'is_free': false,
      'status': 'publie',
      'labels': {'featured': true},
    };

Map<String, dynamic> detailJson() => {
      ...eventJson('chrea', 'Randonnée des cèdres de Chréa'),
      'description': 'Douze kilomètres sous les cèdres.',
      'media': [],
      'categories': [{'slug': 'nature', 'name': 'Nature et randonnée'}],
      'type': {'slug': 'randonnee', 'name': 'Randonnées et nature', 'icon': 'mountain', 'booking_label': 'Une place dans un groupe'},
      'type_fields': {'niveau': 'Moyen', 'distance_km': '12'},
      'includes': ['Guide'],
      'program': [],
      'organizer': {'slug': 'djazair-rando', 'name': 'Djazaïr Rando', 'verified': true, 'is_pro': false, 'rating': 4.9, 'reviews_count': 302, 'followers_count': 3800},
      'sessions': [{'id': 1, 'starts_at': '2026-11-06T07:30:00+01:00', 'capacity': 25, 'remaining': 25, 'pickup_points': []}],
      'tickets': [{'id': 1, 'kind': 'normal', 'name': 'Participation', 'price': 1500, 'seats': 1, 'on_sale': true}],
      'sale_mode': {'label': 'Billet payé en ligne'},
      'cancellation_policy': {'label': 'Remboursable jusqu\'à 48 heures avant'},
      'max_per_person': 10,
      'setting': {'label': 'Plein air'},
      'is_favorite': false,
      'share_url': 'http://localhost:3000/fr/sorties/chrea',
    };

EventDetail detail() => EventDetail.fromJson(detailJson());

DowraUser user({String? name, bool onboarded = false}) => DowraUser.fromJson({
      'id': 1,
      'phone': '+213770123456',
      'name': name,
      'locale': 'fr',
      'theme_mode': 'systeme',
      'interests': <String>[],
      'level': 'explorateur',
      'level_label': 'Explorateur',
      'points': 0,
      'is_ambassador': false,
      'roles': ['utilisateur'],
      'onboarded': onboarded,
    });

void main() {
  late MockRepository repository;
  late MemoryStore store;

  setUpAll(() => registerFallbackValue(const EventFilters()));

  setUp(() {
    repository = MockRepository();
    store = MemoryStore();
    when(() => repository.currentUser()).thenAnswer((_) async => null);
    when(() => repository.outingTypes()).thenAnswer((_) async => [
          const OutingType(slug: 'randonnee', name: 'Randonnées et nature', bookingLabel: 'Une place dans un groupe', icon: 'mountain'),
        ]);
    when(() => repository.categories()).thenAnswer((_) async => [const Category(slug: 'nature', name: 'Nature et randonnée', icon: 'mountain', color: '#16A34A')]);
    when(() => repository.wilayas()).thenAnswer((_) async => [const Wilaya(id: 16, code: 16, name: 'Alger', isActive: true)]);
    when(() => repository.home(wilaya: any(named: 'wilaya'))).thenAnswer((_) async => HomeData.fromJson({
          'featured': [eventJson('chrea', 'Randonnée des cèdres de Chréa')],
          'this_weekend': {'events': [eventJson('casbah', 'Visite guidée de la Casbah')]},
          'hidden_gems': [],
          'new': [],
        }));
    when(() => repository.events(any(), page: any(named: 'page'))).thenAnswer((invocation) async => (
          events: [EventCard.fromJson(eventJson('chrea', 'Randonnée des cèdres de Chréa'))],
          total: 1,
          lastPage: 1,
        ));
    when(() => repository.event('chrea')).thenAnswer((_) async => detail());
    when(() => repository.similar(any())).thenAnswer((_) async => []);
  });

  Future<void> launch(WidgetTester tester, {bool introSeen = false}) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(repository),
        offlineStoreProvider.overrideWithValue(store),
        startupPrefsProvider.overrideWithValue(StartupPrefs(locale: 'fr', themeMode: null, introSeen: introSeen)),
      ],
      child: const DowraApp(),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('premier lancement : bienvenue, puis accueil en visiteur avec les types de sortie', (tester) async {
    await launch(tester);
    expect(find.text('Découvre l\'Algérie, une sortie à la fois.'), findsOneWidget);

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.text('Salam,'), findsOneWidget);
    expect(find.text('Randonnée des cèdres de Chréa'), findsOneWidget);
    expect(find.text('Ce week-end'), findsOneWidget);
    expect(find.text('Visite guidée de la Casbah'), findsOneWidget);
  });

  testWidgets('un type de sortie de l\'accueil ouvre Explorer filtré', (tester) async {
    await launch(tester, introSeen: true);
    await tester.tap(find.widgetWithText(ActionChip, 'Randonnées et nature'));
    await tester.pumpAndSettle();

    expect(find.text('1 sortie'), findsOneWidget);
    final filters = verify(() => repository.events(captureAny(), page: 1)).captured.last as EventFilters;
    expect(filters.type, 'randonnee');
  });

  testWidgets('la fiche affiche les infos du type et demande un compte pour le favori', (tester) async {
    await launch(tester, introSeen: true);
    await tester.tap(find.text('Randonnée des cèdres de Chréa'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Djazaïr Rando'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Moyen'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Les infos utiles'), findsOneWidget);
    await tester.scrollUntilVisible(find.byTooltip('Favoris'), -300, scrollable: find.byType(Scrollable).first);

    await tester.tap(find.byTooltip('Favoris'));
    await tester.pumpAndSettle();
    expect(find.text('Recevoir le code'), findsOneWidget);
    verifyNever(() => repository.setFavorite(any(), any()));
  });

  testWidgets('l\'arabe passe toute l\'app de droite à gauche', (tester) async {
    await launch(tester);
    await tester.tap(find.text('عربي'));
    await tester.pumpAndSettle();

    expect(find.text('ابدأ'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('ابدأ'))), TextDirection.rtl);
  });

  testWidgets('numéro invalide refusé sans appeler l\'API', (tester) async {
    await launch(tester, introSeen: true);
    await tester.tap(find.bySemanticsLabel('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '021 12 34 56');
    await tester.tap(find.text('Recevoir le code'));
    await tester.pumpAndSettle();

    expect(find.text('Entre un numéro mobile algérien (05, 06 ou 07).'), findsOneWidget);
    verifyNever(() => repository.requestOtp(any()));
  });

  testWidgets('nouveau compte : code SMS, premier passage chez Dowri, puis accueil à son prénom', (tester) async {
    when(() => repository.requestOtp('+213770123456')).thenAnswer((_) async {});
    when(() => repository.verifyOtp('+213770123456', '123456', deviceName: any(named: 'deviceName'))).thenAnswer((_) async => user());
    when(() => repository.updateProfile(any())).thenAnswer((_) async => user(name: 'Yacine Test', onboarded: true));

    await launch(tester);
    await tester.tap(find.text('J\'ai déjà un compte'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '07 70 12 34 56');
    await tester.tap(find.text('Recevoir le code'));
    await tester.pumpAndSettle();
    expect(find.textContaining('05 50').evaluate().isEmpty, isTrue);

    await tester.tap(find.text('Vérifier'));
    await tester.pumpAndSettle();
    expect(find.text('Comment tu t\'appelles ?'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Yacine Test');
    await tester.tap(find.text('Nature et randonnée'));
    await tester.ensureVisible(find.text('Découvrir mes sorties'));
    await tester.tap(find.text('Découvrir mes sorties'));
    await tester.pumpAndSettle();

    final sent = verify(() => repository.updateProfile(captureAny())).captured.last as Map<String, Object?>;
    expect(sent['name'], 'Yacine Test');
    expect(sent['interests'], ['nature']);
    expect(sent['onboarded'], true);
    expect(find.text('Salam Yacine,'), findsOneWidget);
  });

  testWidgets('réserver une inscription gratuite ouvre le billet avec ses QR codes', (tester) async {
    final free = EventDetail.fromJson({
      ...detailJson(),
      'tickets': [{'id': 1, 'kind': 'inscription', 'name': 'Participation', 'price': 0, 'seats': 1, 'on_sale': true}],
      'is_free': true,
      'bookable': true,
    });
    when(() => repository.currentUser()).thenAnswer((_) async => user(name: 'Amina', onboarded: true));
    when(() => repository.event('chrea')).thenAnswer((_) async => free);
    when(() => repository.availability('chrea')).thenAnswer((_) async => Availability.fromJson({
          'sessions': [{'id': 1, 'starts_at': '2026-11-06T07:30:00+01:00', 'capacity': 25, 'remaining': 25, 'sold_out': false, 'tickets_remaining': {'1': 25}, 'pickup_points': []}],
          'max_per_person': 10,
          'already_booked': 0,
          'waitlist': [],
        }));
    when(() => repository.book(any())).thenAnswer((_) async => Booking.fromJson(bookingJson()));
    when(() => repository.bookingJson('DW7K3P9Q')).thenAnswer((_) async => bookingJson());
    when(() => repository.bookingsJson(any())).thenAnswer((_) async => [bookingJson()]);

    await launch(tester, introSeen: true);
    await tester.tap(find.text('Randonnée des cèdres de Chréa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Réserver'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('+').first);
    await tester.pump();
    await tester.tap(find.byTooltip('+').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmer mon inscription'));
    await tester.pumpAndSettle();

    final sent = verify(() => repository.book(captureAny())).captured.single as Map<String, Object?>;
    expect(sent['items'], [{'ticket_type_id': 1, 'quantity': 2}]);
    expect(find.text('DW7K3P9Q'), findsOneWidget);
    expect(find.text('TABCDE2345'), findsOneWidget);
    expect(store.data['dowra_offline_booking_DW7K3P9Q'], isNotNull);
  });

  testWidgets('sans réseau, Mes billets affiche la copie gardée sur le téléphone', (tester) async {
    when(() => repository.currentUser()).thenAnswer((_) async => user(name: 'Amina', onboarded: true));
    when(() => repository.bookingsJson(any())).thenThrow(ApiException('network'));
    store.data['dowra_offline_bookings_upcoming'] = [bookingJson()];

    await launch(tester, introSeen: true);
    await tester.tap(find.bySemanticsLabel('Billets'));
    await tester.pumpAndSettle();

    expect(find.text('Hors connexion : tes billets gardés sur le téléphone.'), findsOneWidget);
    expect(find.text('Randonnée des cèdres de Chréa'), findsOneWidget);
    expect(find.text('2 billets'), findsOneWidget);
  });

  testWidgets('mode scan : vert, puis orange pour le même billet, rouge pour un inconnu, et envoi des scans', (tester) async {
    when(() => repository.scanTickets(5)).thenAnswer((_) async => {
          'session': {'id': 5, 'event': 'Nuit dans les dunes de Taghit'},
          'downloaded_at': '2026-11-05T18:00:00+01:00',
          'tickets': [
            {'code': 'TABCDE2345', 'type': 'Place en tente', 'holder_name': 'Lina Bouzid', 'status': 'valide'},
            {'code': 'TFGHJK6789', 'type': 'Place en tente', 'holder_name': 'Walid Cherif', 'status': 'annule'},
          ],
        });
    when(() => repository.syncScans(5, any(), since: any(named: 'since'), device: any(named: 'device')))
        .thenAnswer((_) async => {'tickets': [], 'synced_at': '2026-11-05T18:01:00+01:00'});

    await tester.pumpWidget(ProviderScope(
      overrides: [repositoryProvider.overrideWithValue(repository), offlineStoreProvider.overrideWithValue(store)],
      child: MaterialApp(
        theme: dowraTheme(brightness: Brightness.light, locale: 'fr'),
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ScanScreen(sessionId: 5, camera: false),
      ),
    ));
    await tester.pumpAndSettle();

    Future<void> scan(String code) async {
      await tester.enterText(find.byType(TextField), code);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 4));
    }

    await scan('DOWRA:TABCDE2345:abcdefghijkl');
    expect(find.text('Billet valide'), findsOneWidget);
    expect(find.text('1 / 1'), findsOneWidget);
    await scan('TABCDE2345');
    expect(find.text('Déjà utilisé'), findsOneWidget);
    await scan('TFGHJK6789');
    expect(find.text('Billet annulé'), findsOneWidget);
    await scan('TZZZZZZZZZ');
    expect(find.text('Billet inconnu'), findsOneWidget);

    final sent = verify(() => repository.syncScans(5, captureAny(), since: any(named: 'since'), device: any(named: 'device'))).captured;
    expect(sent.whereType<List>().expand((batch) => batch).map((scan) => (scan as Map)['code']), contains('DOWRA:TABCDE2345:abcdefghijkl'));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('offrir une carte cadeau envoie le montant, le destinataire et la carte choisie', (tester) async {
    when(() => repository.currentUser()).thenAnswer((_) async => user(name: 'Amina', onboarded: true));
    when(() => repository.myGiftCards()).thenAnswer((_) async => []);
    when(() => repository.giftOptions()).thenAnswer((_) async => GiftOptions.fromJson({
          'min': 1000,
          'max': 50000,
          'suggested': [2000, 5000, 10000],
          'payment_fees': {'cib': 1.5, 'edahabia': 2, 'minimum': 20},
        }));
    when(() => repository.buyGiftCard(any())).thenAnswer((_) async => 'http://localhost:8000/paiement-simule/PAYTEST');

    await launch(tester, introSeen: true);
    await tester.tap(find.bySemanticsLabel('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cartes cadeaux'));
    await tester.pumpAndSettle();

    expect(find.text('Payer 5 075 DA'), findsOneWidget);
    await tester.tap(find.text('Edahabia'));
    await tester.enterText(find.widgetWithText(TextField, 'Prénom de la personne'), 'Lina');
    await tester.enterText(find.widgetWithText(TextField, 'Son numéro (code envoyé par SMS)'), '0550000098');
    await tester.pumpAndSettle();
    expect(find.text('Payer 5 100 DA'), findsOneWidget);
    await tester.ensureVisible(find.text('Payer 5 100 DA'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Payer 5 100 DA'));
    await tester.pump(const Duration(milliseconds: 500));

    final sent = verify(() => repository.buyGiftCard(captureAny())).captured.single as Map<String, Object?>;
    expect(sent, {'amount': 5000, 'recipient_name': 'Lina', 'recipient_phone': '0550000098', 'method': 'edahabia'});
  });
}
