// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Dowra';

  @override
  String get welcomeKicker => 'Yallah, nedowrou !';

  @override
  String get welcomeTitle => 'Découvre l\'Algérie, une sortie à la fois.';

  @override
  String get welcomeLead =>
      'Randos, concerts, plages et Grand Sud, réservés en 2 minutes avec des organisateurs vérifiés.';

  @override
  String get start => 'Commencer';

  @override
  String get haveAccount => 'J\'ai déjà un compte';

  @override
  String get loginTitle => 'Entre ton';

  @override
  String get loginTitleEm => 'numéro';

  @override
  String get loginLead =>
      'Tu reçois un code par SMS. Pas de mot de passe à retenir.';

  @override
  String get phoneLabel => 'Numéro de mobile';

  @override
  String get phoneHint => '05 50 12 34 56';

  @override
  String get sendCode => 'Recevoir le code';

  @override
  String get invalidPhone => 'Entre un numéro mobile algérien (05, 06 ou 07).';

  @override
  String get networkError =>
      'Le serveur Dowra ne répond pas. Réessaie dans un instant.';

  @override
  String get codeTitle => 'Entre ton';

  @override
  String get codeTitleEm => 'code';

  @override
  String codeSentTo(String phone) {
    return 'On a envoyé un SMS au $phone';
  }

  @override
  String get verify => 'Vérifier';

  @override
  String get changeNumber => 'Changer de numéro';

  @override
  String get testAccounts => 'Comptes de test';

  @override
  String get demoHint =>
      'Mode test : le numéro d\'un compte de test et le code 123456 sont déjà remplis.';

  @override
  String get terms =>
      'En continuant, tu acceptes les conditions d\'utilisation de Dowra.';

  @override
  String get onboardingKicker => 'Bienvenue sur Dowra !';

  @override
  String get onboardingTitle => 'Fais connaissance avec';

  @override
  String get onboardingTitleEm => 'Dowri';

  @override
  String get onboardingLead =>
      'Trois questions et je te propose les sorties qui te ressemblent.';

  @override
  String get nameQuestion => 'Comment tu t\'appelles ?';

  @override
  String get wilayaQuestion => 'Tu pars d\'où ?';

  @override
  String get interestsQuestion => 'Qu\'est-ce qui te fait envie ?';

  @override
  String get interestsHint => 'Choisis autant d\'envies que tu veux.';

  @override
  String get chooseWilaya => 'Choisir une wilaya';

  @override
  String get wilayasOpen => 'Ouvertes';

  @override
  String get wilayasSoon => 'Bientôt';

  @override
  String get discover => 'Découvrir mes sorties';

  @override
  String get later => 'Plus tard';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navTickets => 'Billets';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navProfile => 'Profil';

  @override
  String homeHello(String name) {
    return 'Salam $name,';
  }

  @override
  String get homeHelloGuest => 'Salam,';

  @override
  String get homeQuestion => 'on sort';

  @override
  String get homeQuestionEm => 'où ?';

  @override
  String get searchHint => 'Destination, sortie, organisateur…';

  @override
  String get heroKicker => 'Grand Sud';

  @override
  String get heroTitle => 'Ce week-end, on part à Taghit';

  @override
  String get heroText =>
      'Les sorties des organisateurs arrivent ici, avec leurs départs et leurs prix.';

  @override
  String get typesTitle => 'Types de sortie';

  @override
  String get interestsTitle => 'Tes envies';

  @override
  String get citiesTitle => 'Villes de départ';

  @override
  String get open => 'Ouverte';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get exploreTitle => 'Explorer';

  @override
  String get exploreLead =>
      'Choisis un type de sortie : les départs s\'affichent ici dès que les organisateurs les publient.';

  @override
  String get ticketsTitle => 'Mes';

  @override
  String get ticketsTitleEm => 'billets';

  @override
  String get ticketsEmpty =>
      'Tes billets apparaîtront ici dès ta première réservation, avec leur code QR.';

  @override
  String get favoritesTitle => 'Mes';

  @override
  String get favoritesTitleEm => 'favoris';

  @override
  String get favoritesEmpty =>
      'Touche le cœur d\'une sortie ou d\'un organisateur pour le retrouver ici.';

  @override
  String get guestTitle => 'Connecte-toi pour continuer';

  @override
  String get guestText =>
      'Un numéro de mobile suffit : tes billets, tes favoris et ton passeport t\'attendent.';

  @override
  String get login => 'Se connecter';

  @override
  String get profileTitle => 'Mon';

  @override
  String get profileTitleEm => 'passeport';

  @override
  String get level => 'Niveau';

  @override
  String points(int count) {
    return '$count pts';
  }

  @override
  String get ambassador => 'Ambassadeur';

  @override
  String get personalInfo => 'Informations personnelles';

  @override
  String get language => 'Langue';

  @override
  String get display => 'Affichage';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer mon compte';

  @override
  String get deleteConfirmTitle => 'Supprimer ton compte ?';

  @override
  String get deleteConfirmText =>
      'Ton profil et tes préférences sont effacés. Tu pourras recréer un compte avec le même numéro.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get saved => 'C\'est enregistré.';

  @override
  String get name => 'Prénom et nom';

  @override
  String get email => 'E-mail (facultatif)';

  @override
  String get wilaya => 'Ma wilaya';

  @override
  String get interests => 'Mes envies';

  @override
  String get retry => 'Réessayer';

  @override
  String get emptyReferentials =>
      'Les listes s\'affichent dès que le serveur Dowra répond.';
}
