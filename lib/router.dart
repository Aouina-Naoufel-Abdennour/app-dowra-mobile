import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers.dart';
import 'screens/booking_screen.dart';
import 'screens/code_screen.dart';
import 'screens/event_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/organizer_screen.dart';
import 'screens/phone_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/shell.dart';
import 'screens/splash_screen.dart';
import 'screens/ticket_screen.dart';
import 'screens/tickets_screen.dart';
import 'screens/welcome_screen.dart';

/// Premier passage reporté (« Plus tard ») : Dowri ne redemande pas pendant cette ouverture de l'app.
final onboardingPostponedProvider = NotifierProvider<OnboardingPostponed, bool>(OnboardingPostponed.new);

class OnboardingPostponed extends Notifier<bool> {
  @override
  bool build() => false;

  void postpone() => state = true;
}

/// Adresses de l'app et règles d'accès : bienvenue au premier lancement, premier passage après l'inscription.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(sessionProvider, (_, _) => refresh.value++);
  ref.listen(introSeenProvider, (_, _) => refresh.value++);
  ref.listen(onboardingPostponedProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final location = state.matchedLocation;
      if (session.isLoading && !session.hasValue) return location == '/' ? null : '/';

      final user = session.value;
      final introSeen = ref.read(introSeenProvider);
      final inAuth = location.startsWith('/connexion');

      if (!introSeen && location != '/bienvenue' && !inAuth) return '/bienvenue';
      if (location == '/') return introSeen ? '/accueil' : '/bienvenue';
      if (user != null && inAuth) return user.onboarded ? '/accueil' : '/premiers-pas';
      if (user != null && !user.onboarded && !ref.read(onboardingPostponedProvider) && location != '/premiers-pas') return '/premiers-pas';
      if (user == null && (location == '/premiers-pas' || location == '/profil/infos')) return '/connexion';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/bienvenue', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/connexion', builder: (_, _) => const PhoneScreen()),
      GoRoute(path: '/connexion/code', builder: (_, state) => CodeScreen(phone: state.extra as String? ?? '')),
      GoRoute(path: '/premiers-pas', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/profil/infos', builder: (_, _) => const ProfileEditScreen()),
      GoRoute(path: '/sorties/:slug', builder: (_, state) => EventScreen(slug: state.pathParameters['slug']!)),
      GoRoute(path: '/sorties/:slug/reserver', builder: (_, state) => BookingScreen(slug: state.pathParameters['slug']!)),
      GoRoute(path: '/billets/:code', builder: (_, state) => TicketScreen(code: state.pathParameters['code']!)),
      GoRoute(path: '/scan', builder: (_, _) => const ScanSessionsScreen()),
      GoRoute(path: '/scan/:session', builder: (_, state) => ScanScreen(sessionId: int.parse(state.pathParameters['session']!))),
      GoRoute(path: '/organisateurs/:slug', builder: (_, state) => OrganizerScreen(slug: state.pathParameters['slug']!)),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => DowraShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/accueil', builder: (_, _) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/explorer', builder: (_, _) => const ExploreScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/billets', builder: (_, _) => const TicketsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/favoris', builder: (_, _) => const FavoritesScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/profil', builder: (_, _) => const ProfileScreen())]),
        ],
      ),
    ],
  );
});
