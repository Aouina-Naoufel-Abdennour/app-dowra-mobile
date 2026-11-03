import 'package:dowra/app.dart';
import 'package:dowra/core/models.dart';
import 'package:dowra/core/providers.dart';
import 'package:dowra/core/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements DowraRepository {}

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

  setUp(() {
    repository = MockRepository();
    when(() => repository.currentUser()).thenAnswer((_) async => null);
    when(() => repository.outingTypes()).thenAnswer((_) async => [
          const OutingType(slug: 'randonnee', name: 'Randonnées et nature', bookingLabel: 'Une place dans un groupe', icon: 'mountain'),
        ]);
    when(() => repository.categories()).thenAnswer((_) async => [const Category(slug: 'nature', name: 'Nature et randonnée', icon: 'mountain', color: '#16A34A')]);
    when(() => repository.wilayas()).thenAnswer((_) async => [const Wilaya(id: 16, code: 16, name: 'Alger', isActive: true)]);
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
    expect(find.text('Randonnées et nature'), findsOneWidget);
    expect(find.text('Alger'), findsOneWidget);
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
