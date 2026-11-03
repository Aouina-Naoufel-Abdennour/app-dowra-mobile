import 'package:dowra/app.dart';
import 'package:dowra/core/catalogue.dart';
import 'package:dowra/core/models.dart';
import 'package:dowra/core/providers.dart';
import 'package:dowra/core/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements DowraRepository {}

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

EventDetail detail() => EventDetail.fromJson({
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
    });

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

  setUpAll(() => registerFallbackValue(const EventFilters()));

  setUp(() {
    repository = MockRepository();
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
}
