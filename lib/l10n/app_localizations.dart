import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dowra'**
  String get appTitle;

  /// No description provided for @welcomeKicker.
  ///
  /// In fr, this message translates to:
  /// **'Yallah, nedowrou !'**
  String get welcomeKicker;

  /// No description provided for @welcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvre l\'Algérie, une sortie à la fois.'**
  String get welcomeTitle;

  /// No description provided for @welcomeLead.
  ///
  /// In fr, this message translates to:
  /// **'Randos, concerts, plages et Grand Sud, réservés en 2 minutes avec des organisateurs vérifiés.'**
  String get welcomeLead;

  /// No description provided for @start.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get start;

  /// No description provided for @haveAccount.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai déjà un compte'**
  String get haveAccount;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton'**
  String get loginTitle;

  /// No description provided for @loginTitleEm.
  ///
  /// In fr, this message translates to:
  /// **'numéro'**
  String get loginTitleEm;

  /// No description provided for @loginLead.
  ///
  /// In fr, this message translates to:
  /// **'Tu reçois un code par SMS. Pas de mot de passe à retenir.'**
  String get loginLead;

  /// No description provided for @phoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de mobile'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In fr, this message translates to:
  /// **'05 50 12 34 56'**
  String get phoneHint;

  /// No description provided for @sendCode.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir le code'**
  String get sendCode;

  /// No description provided for @invalidPhone.
  ///
  /// In fr, this message translates to:
  /// **'Entre un numéro mobile algérien (05, 06 ou 07).'**
  String get invalidPhone;

  /// No description provided for @networkError.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur Dowra ne répond pas. Réessaie dans un instant.'**
  String get networkError;

  /// No description provided for @codeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton'**
  String get codeTitle;

  /// No description provided for @codeTitleEm.
  ///
  /// In fr, this message translates to:
  /// **'code'**
  String get codeTitleEm;

  /// No description provided for @codeSentTo.
  ///
  /// In fr, this message translates to:
  /// **'On a envoyé un SMS au {phone}'**
  String codeSentTo(String phone);

  /// No description provided for @verify.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier'**
  String get verify;

  /// No description provided for @changeNumber.
  ///
  /// In fr, this message translates to:
  /// **'Changer de numéro'**
  String get changeNumber;

  /// No description provided for @testAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes de test'**
  String get testAccounts;

  /// No description provided for @demoHint.
  ///
  /// In fr, this message translates to:
  /// **'Mode test : le numéro d\'un compte de test et le code 123456 sont déjà remplis.'**
  String get demoHint;

  /// No description provided for @terms.
  ///
  /// In fr, this message translates to:
  /// **'En continuant, tu acceptes les conditions d\'utilisation de Dowra.'**
  String get terms;

  /// No description provided for @onboardingKicker.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Dowra !'**
  String get onboardingKicker;

  /// No description provided for @onboardingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fais connaissance avec'**
  String get onboardingTitle;

  /// No description provided for @onboardingTitleEm.
  ///
  /// In fr, this message translates to:
  /// **'Dowri'**
  String get onboardingTitleEm;

  /// No description provided for @onboardingLead.
  ///
  /// In fr, this message translates to:
  /// **'Trois questions et je te propose les sorties qui te ressemblent.'**
  String get onboardingLead;

  /// No description provided for @nameQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Comment tu t\'appelles ?'**
  String get nameQuestion;

  /// No description provided for @wilayaQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Tu pars d\'où ?'**
  String get wilayaQuestion;

  /// No description provided for @interestsQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Qu\'est-ce qui te fait envie ?'**
  String get interestsQuestion;

  /// No description provided for @interestsHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisis autant d\'envies que tu veux.'**
  String get interestsHint;

  /// No description provided for @chooseWilaya.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une wilaya'**
  String get chooseWilaya;

  /// No description provided for @wilayasOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvertes'**
  String get wilayasOpen;

  /// No description provided for @wilayasSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get wilayasSoon;

  /// No description provided for @discover.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir mes sorties'**
  String get discover;

  /// No description provided for @later.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get later;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In fr, this message translates to:
  /// **'Explorer'**
  String get navExplore;

  /// No description provided for @navTickets.
  ///
  /// In fr, this message translates to:
  /// **'Billets'**
  String get navTickets;

  /// No description provided for @navFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get navFavorites;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @homeHello.
  ///
  /// In fr, this message translates to:
  /// **'Salam {name},'**
  String homeHello(String name);

  /// No description provided for @homeHelloGuest.
  ///
  /// In fr, this message translates to:
  /// **'Salam,'**
  String get homeHelloGuest;

  /// No description provided for @homeQuestion.
  ///
  /// In fr, this message translates to:
  /// **'on sort'**
  String get homeQuestion;

  /// No description provided for @homeQuestionEm.
  ///
  /// In fr, this message translates to:
  /// **'où ?'**
  String get homeQuestionEm;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Destination, sortie, organisateur…'**
  String get searchHint;

  /// No description provided for @heroKicker.
  ///
  /// In fr, this message translates to:
  /// **'Grand Sud'**
  String get heroKicker;

  /// No description provided for @heroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce week-end, on part à Taghit'**
  String get heroTitle;

  /// No description provided for @heroText.
  ///
  /// In fr, this message translates to:
  /// **'Les sorties des organisateurs arrivent ici, avec leurs départs et leurs prix.'**
  String get heroText;

  /// No description provided for @typesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Types de sortie'**
  String get typesTitle;

  /// No description provided for @interestsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes envies'**
  String get interestsTitle;

  /// No description provided for @citiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Villes de départ'**
  String get citiesTitle;

  /// No description provided for @open.
  ///
  /// In fr, this message translates to:
  /// **'Ouverte'**
  String get open;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get seeAll;

  /// No description provided for @exploreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Explorer'**
  String get exploreTitle;

  /// No description provided for @exploreLead.
  ///
  /// In fr, this message translates to:
  /// **'Choisis un type de sortie : les départs s\'affichent ici dès que les organisateurs les publient.'**
  String get exploreLead;

  /// No description provided for @ticketsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes'**
  String get ticketsTitle;

  /// No description provided for @ticketsTitleEm.
  ///
  /// In fr, this message translates to:
  /// **'billets'**
  String get ticketsTitleEm;

  /// No description provided for @ticketsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Tes billets apparaîtront ici dès ta première réservation, avec leur code QR.'**
  String get ticketsEmpty;

  /// No description provided for @favoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes'**
  String get favoritesTitle;

  /// No description provided for @favoritesTitleEm.
  ///
  /// In fr, this message translates to:
  /// **'favoris'**
  String get favoritesTitleEm;

  /// No description provided for @favoritesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Touche le cœur d\'une sortie ou d\'un organisateur pour le retrouver ici.'**
  String get favoritesEmpty;

  /// No description provided for @guestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour continuer'**
  String get guestTitle;

  /// No description provided for @guestText.
  ///
  /// In fr, this message translates to:
  /// **'Un numéro de mobile suffit : tes billets, tes favoris et ton passeport t\'attendent.'**
  String get guestText;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get login;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon'**
  String get profileTitle;

  /// No description provided for @profileTitleEm.
  ///
  /// In fr, this message translates to:
  /// **'passeport'**
  String get profileTitleEm;

  /// No description provided for @level.
  ///
  /// In fr, this message translates to:
  /// **'Niveau'**
  String get level;

  /// No description provided for @points.
  ///
  /// In fr, this message translates to:
  /// **'{count} pts'**
  String points(int count);

  /// No description provided for @ambassador.
  ///
  /// In fr, this message translates to:
  /// **'Ambassadeur'**
  String get ambassador;

  /// No description provided for @personalInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get personalInfo;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @display.
  ///
  /// In fr, this message translates to:
  /// **'Affichage'**
  String get display;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get deleteAccount;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ton compte ?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmText.
  ///
  /// In fr, this message translates to:
  /// **'Ton profil et tes préférences sont effacés. Tu pourras recréer un compte avec le même numéro.'**
  String get deleteConfirmText;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In fr, this message translates to:
  /// **'C\'est enregistré.'**
  String get saved;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Prénom et nom'**
  String get name;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'E-mail (facultatif)'**
  String get email;

  /// No description provided for @wilaya.
  ///
  /// In fr, this message translates to:
  /// **'Ma wilaya'**
  String get wilaya;

  /// No description provided for @interests.
  ///
  /// In fr, this message translates to:
  /// **'Mes envies'**
  String get interests;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @emptyReferentials.
  ///
  /// In fr, this message translates to:
  /// **'Les listes s\'affichent dès que le serveur Dowra répond.'**
  String get emptyReferentials;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
