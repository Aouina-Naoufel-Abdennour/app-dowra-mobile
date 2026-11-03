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

  /// No description provided for @chooseWilayaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta wilaya'**
  String get chooseWilayaTitle;

  /// No description provided for @allAlgeria.
  ///
  /// In fr, this message translates to:
  /// **'Toute l\'Algérie'**
  String get allAlgeria;

  /// No description provided for @weekendTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce week-end'**
  String get weekendTitle;

  /// No description provided for @featuredTitle.
  ///
  /// In fr, this message translates to:
  /// **'À la une'**
  String get featuredTitle;

  /// No description provided for @gemsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Trésors cachés'**
  String get gemsTitle;

  /// No description provided for @newTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveautés'**
  String get newTitle;

  /// No description provided for @wilayaOfDay.
  ///
  /// In fr, this message translates to:
  /// **'Wilaya du jour'**
  String get wilayaOfDay;

  /// No description provided for @seeOutingsIn.
  ///
  /// In fr, this message translates to:
  /// **'Les sorties de {wilaya}'**
  String seeOutingsIn(String wilaya);

  /// No description provided for @priceFrom.
  ///
  /// In fr, this message translates to:
  /// **'Dès {price}'**
  String priceFrom(String price);

  /// No description provided for @free.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get free;

  /// No description provided for @badgeFeatured.
  ///
  /// In fr, this message translates to:
  /// **'À la une'**
  String get badgeFeatured;

  /// No description provided for @badgeGem.
  ///
  /// In fr, this message translates to:
  /// **'Trésor caché'**
  String get badgeGem;

  /// No description provided for @verified.
  ///
  /// In fr, this message translates to:
  /// **'Vérifié'**
  String get verified;

  /// No description provided for @distanceKm.
  ///
  /// In fr, this message translates to:
  /// **'{km} km'**
  String distanceKm(String km);

  /// No description provided for @searchOutings.
  ///
  /// In fr, this message translates to:
  /// **'Nom, lieu, artiste, organisateur…'**
  String get searchOutings;

  /// No description provided for @filters.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filters;

  /// No description provided for @apply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In fr, this message translates to:
  /// **'Tout effacer'**
  String get reset;

  /// No description provided for @resultsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 sortie} other{{count} sorties}}'**
  String resultsCount(int count);

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sortie ne correspond. Essaie d\'élargir les dates ou la wilaya.'**
  String get noResults;

  /// No description provided for @listView.
  ///
  /// In fr, this message translates to:
  /// **'Liste'**
  String get listView;

  /// No description provided for @mapView.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get mapView;

  /// No description provided for @nearMe.
  ///
  /// In fr, this message translates to:
  /// **'Près de moi'**
  String get nearMe;

  /// No description provided for @nearMeError.
  ///
  /// In fr, this message translates to:
  /// **'Position indisponible : autorise la localisation dans les réglages.'**
  String get nearMeError;

  /// No description provided for @whenToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get whenToday;

  /// No description provided for @whenTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Demain'**
  String get whenTomorrow;

  /// No description provided for @whenWeekend.
  ///
  /// In fr, this message translates to:
  /// **'Ce week-end'**
  String get whenWeekend;

  /// No description provided for @whenWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get whenWeek;

  /// No description provided for @whenMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get whenMonth;

  /// No description provided for @priceFree.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get priceFree;

  /// No description provided for @priceUnder2000.
  ///
  /// In fr, this message translates to:
  /// **'Moins de 2 000 DA'**
  String get priceUnder2000;

  /// No description provided for @family.
  ///
  /// In fr, this message translates to:
  /// **'En famille'**
  String get family;

  /// No description provided for @women.
  ///
  /// In fr, this message translates to:
  /// **'Entre femmes'**
  String get women;

  /// No description provided for @pmr.
  ///
  /// In fr, this message translates to:
  /// **'Accessible PMR'**
  String get pmr;

  /// No description provided for @hiddenGem.
  ///
  /// In fr, this message translates to:
  /// **'Trésor caché'**
  String get hiddenGem;

  /// No description provided for @indoor.
  ///
  /// In fr, this message translates to:
  /// **'Intérieur'**
  String get indoor;

  /// No description provided for @outdoor.
  ///
  /// In fr, this message translates to:
  /// **'Plein air'**
  String get outdoor;

  /// No description provided for @anyValue.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get anyValue;

  /// No description provided for @sortBy.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get sortBy;

  /// No description provided for @sortDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get sortDate;

  /// No description provided for @sortPopular.
  ///
  /// In fr, this message translates to:
  /// **'Popularité'**
  String get sortPopular;

  /// No description provided for @sortPriceAsc.
  ///
  /// In fr, this message translates to:
  /// **'Prix croissant'**
  String get sortPriceAsc;

  /// No description provided for @sortDistance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get sortDistance;

  /// No description provided for @when.
  ///
  /// In fr, this message translates to:
  /// **'Quand'**
  String get when;

  /// No description provided for @price.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get price;

  /// No description provided for @setting.
  ///
  /// In fr, this message translates to:
  /// **'Cadre'**
  String get setting;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Envie'**
  String get category;

  /// No description provided for @type.
  ///
  /// In fr, this message translates to:
  /// **'Type de sortie'**
  String get type;

  /// No description provided for @sessions.
  ///
  /// In fr, this message translates to:
  /// **'Dates et séances'**
  String get sessions;

  /// No description provided for @noSessions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune séance à venir pour le moment.'**
  String get noSessions;

  /// No description provided for @tickets.
  ///
  /// In fr, this message translates to:
  /// **'Billets'**
  String get tickets;

  /// No description provided for @placesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 place} other{{count} places}}'**
  String placesCount(int count);

  /// No description provided for @pickups.
  ///
  /// In fr, this message translates to:
  /// **'Points de ramassage'**
  String get pickups;

  /// No description provided for @details.
  ///
  /// In fr, this message translates to:
  /// **'Les infos utiles'**
  String get details;

  /// No description provided for @program.
  ///
  /// In fr, this message translates to:
  /// **'Programme'**
  String get program;

  /// No description provided for @includes.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get includes;

  /// No description provided for @place.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get place;

  /// No description provided for @meetingPoint.
  ///
  /// In fr, this message translates to:
  /// **'Point de rendez-vous'**
  String get meetingPoint;

  /// No description provided for @directions.
  ///
  /// In fr, this message translates to:
  /// **'Itinéraire'**
  String get directions;

  /// No description provided for @organizer.
  ///
  /// In fr, this message translates to:
  /// **'Organisateur'**
  String get organizer;

  /// No description provided for @followersCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 abonné} other{{count} abonnés}}'**
  String followersCount(int count);

  /// No description provided for @follow.
  ///
  /// In fr, this message translates to:
  /// **'S\'abonner'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In fr, this message translates to:
  /// **'Abonné'**
  String get following;

  /// No description provided for @cancellation.
  ///
  /// In fr, this message translates to:
  /// **'Annulation'**
  String get cancellation;

  /// No description provided for @saleMode.
  ///
  /// In fr, this message translates to:
  /// **'Vente'**
  String get saleMode;

  /// No description provided for @maxPerPerson.
  ///
  /// In fr, this message translates to:
  /// **'Maximum {count} billets par personne'**
  String maxPerPerson(int count);

  /// No description provided for @ageMin.
  ///
  /// In fr, this message translates to:
  /// **'À partir de {age} ans'**
  String ageMin(int age);

  /// No description provided for @weatherForecast.
  ///
  /// In fr, this message translates to:
  /// **'Météo prévue'**
  String get weatherForecast;

  /// No description provided for @rainChance.
  ///
  /// In fr, this message translates to:
  /// **'{chance} % de pluie'**
  String rainChance(int chance);

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @report.
  ///
  /// In fr, this message translates to:
  /// **'Signaler'**
  String get report;

  /// No description provided for @reportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Signaler cette sortie'**
  String get reportTitle;

  /// No description provided for @reportReason.
  ///
  /// In fr, this message translates to:
  /// **'Motif'**
  String get reportReason;

  /// No description provided for @reportDetails.
  ///
  /// In fr, this message translates to:
  /// **'Précisions (facultatif)'**
  String get reportDetails;

  /// No description provided for @reportSend.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get reportSend;

  /// No description provided for @reportSent.
  ///
  /// In fr, this message translates to:
  /// **'Merci, ton signalement est envoyé à l\'équipe Dowra.'**
  String get reportSent;

  /// No description provided for @favoriteAdded.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté à tes favoris'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Retiré de tes favoris'**
  String get favoriteRemoved;

  /// No description provided for @similar.
  ///
  /// In fr, this message translates to:
  /// **'Dans le même esprit'**
  String get similar;

  /// No description provided for @cancelledEvent.
  ///
  /// In fr, this message translates to:
  /// **'Cette sortie est annulée.'**
  String get cancelledEvent;

  /// No description provided for @endedEvent.
  ///
  /// In fr, this message translates to:
  /// **'Cette sortie est terminée.'**
  String get endedEvent;

  /// No description provided for @upcomingOutings.
  ///
  /// In fr, this message translates to:
  /// **'Ses prochaines sorties'**
  String get upcomingOutings;

  /// No description provided for @noUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'Pas de sortie à venir pour le moment.'**
  String get noUpcoming;

  /// No description provided for @pastOutings.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune sortie passée} =1{1 sortie passée} other{{count} sorties passées}}'**
  String pastOutings(int count);

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @contact.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @reportOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Signaler cet organisateur'**
  String get reportOrganizer;

  /// No description provided for @loginToContinue.
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour continuer'**
  String get loginToContinue;

  /// No description provided for @addToCalendar.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au calendrier'**
  String get addToCalendar;

  /// No description provided for @alreadyBooked.
  ///
  /// In fr, this message translates to:
  /// **'{count} déjà réservé(s)'**
  String alreadyBooked(int count);

  /// No description provided for @bookChannel.
  ///
  /// In fr, this message translates to:
  /// **'Comment veux-tu réserver ?'**
  String get bookChannel;

  /// No description provided for @bookChoose.
  ///
  /// In fr, this message translates to:
  /// **'Choisis au moins un billet.'**
  String get bookChoose;

  /// No description provided for @bookConfirmFree.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer mon inscription'**
  String get bookConfirmFree;

  /// No description provided for @bookGroup.
  ///
  /// In fr, this message translates to:
  /// **'Sortir à plusieurs'**
  String get bookGroup;

  /// No description provided for @bookGroupText.
  ///
  /// In fr, this message translates to:
  /// **'Crée un lien de groupe et partage-le : chacun réserve sa place, ou tu paies pour tout le monde et chacun récupère son billet.'**
  String get bookGroupText;

  /// No description provided for @bookHoldInfo.
  ///
  /// In fr, this message translates to:
  /// **'Tes places sont bloquées 10 minutes pendant le paiement.'**
  String get bookHoldInfo;

  /// No description provided for @bookHolder.
  ///
  /// In fr, this message translates to:
  /// **'Participant {n}'**
  String bookHolder(int n);

  /// No description provided for @bookHolders.
  ///
  /// In fr, this message translates to:
  /// **'Noms des participants'**
  String get bookHolders;

  /// No description provided for @bookHoldersHint.
  ///
  /// In fr, this message translates to:
  /// **'Billets nominatifs : le nom de chaque participant est contrôlé à l\'entrée.'**
  String get bookHoldersHint;

  /// No description provided for @bookNotAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Cette sortie ne prend pas encore de réservation sur Dowra.'**
  String get bookNotAvailable;

  /// No description provided for @bookNote.
  ///
  /// In fr, this message translates to:
  /// **'Un message pour l\'organisateur (facultatif)'**
  String get bookNote;

  /// No description provided for @bookOnline.
  ///
  /// In fr, this message translates to:
  /// **'Billet payé en ligne'**
  String get bookOnline;

  /// No description provided for @bookOnlineHint.
  ///
  /// In fr, this message translates to:
  /// **'CIB ou Edahabia : ta place est garantie tout de suite.'**
  String get bookOnlineHint;

  /// No description provided for @bookOptions.
  ///
  /// In fr, this message translates to:
  /// **'Options'**
  String get bookOptions;

  /// No description provided for @bookPay.
  ///
  /// In fr, this message translates to:
  /// **'Payer {amount}'**
  String bookPay(String amount);

  /// No description provided for @bookSendRequest.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la demande'**
  String get bookSendRequest;

  /// No description provided for @bookSession.
  ///
  /// In fr, this message translates to:
  /// **'Choisis ta séance'**
  String get bookSession;

  /// No description provided for @bookSimple.
  ///
  /// In fr, this message translates to:
  /// **'Réservation simple'**
  String get bookSimple;

  /// No description provided for @bookSimpleHint.
  ///
  /// In fr, this message translates to:
  /// **'L\'organisateur confirme sous 48 heures.'**
  String get bookSimpleHint;

  /// No description provided for @bookTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réserver'**
  String get bookTitle;

  /// No description provided for @callOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Appeler l\'organisateur'**
  String get callOrganizer;

  /// No description provided for @cancelBooking.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get cancelBooking;

  /// No description provided for @cancelBookingConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Oui, annuler'**
  String get cancelBookingConfirm;

  /// No description provided for @cancelBookingText.
  ///
  /// In fr, this message translates to:
  /// **'Les billets seront annulés et le paiement en ligne remboursé selon la règle de l\'organisateur.'**
  String get cancelBookingText;

  /// No description provided for @cancelledBy.
  ///
  /// In fr, this message translates to:
  /// **'Annulée par : {who}'**
  String cancelledBy(String who);

  /// No description provided for @claimShare.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien du billet'**
  String get claimShare;

  /// No description provided for @depositToPay.
  ///
  /// In fr, this message translates to:
  /// **'Acompte à régler : {amount}'**
  String depositToPay(String amount);

  /// No description provided for @entryDeadline.
  ///
  /// In fr, this message translates to:
  /// **'Entrée jusqu\'à'**
  String get entryDeadline;

  /// No description provided for @findOuting.
  ///
  /// In fr, this message translates to:
  /// **'Trouver une sortie'**
  String get findOuting;

  /// No description provided for @fromPrice.
  ///
  /// In fr, this message translates to:
  /// **'À partir de'**
  String get fromPrice;

  /// No description provided for @fromWaitlist.
  ///
  /// In fr, this message translates to:
  /// **'Place proposée par la liste d\'attente : paie-la avant {time}.'**
  String fromWaitlist(String time);

  /// No description provided for @groupEach.
  ///
  /// In fr, this message translates to:
  /// **'Chacun paie sa part'**
  String get groupEach;

  /// No description provided for @groupOne.
  ///
  /// In fr, this message translates to:
  /// **'Je paie pour tout le monde'**
  String get groupOne;

  /// No description provided for @groupShare.
  ///
  /// In fr, this message translates to:
  /// **'Lien du groupe'**
  String get groupShare;

  /// No description provided for @notCancellable.
  ///
  /// In fr, this message translates to:
  /// **'Selon la règle de l\'organisateur, cette réservation ne peut plus être annulée.'**
  String get notCancellable;

  /// No description provided for @payBefore.
  ///
  /// In fr, this message translates to:
  /// **'Places bloquées jusqu\'à {time}'**
  String payBefore(String time);

  /// No description provided for @payNow.
  ///
  /// In fr, this message translates to:
  /// **'Payer {amount}'**
  String payNow(String amount);

  /// No description provided for @paymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get paymentMethod;

  /// No description provided for @placesAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Places disponibles'**
  String get placesAvailable;

  /// No description provided for @placesLeft.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 place restante} other{{count} places restantes}}'**
  String placesLeft(int count);

  /// No description provided for @qrHint.
  ///
  /// In fr, this message translates to:
  /// **'Présente ce QR code à l\'entrée. Il reste visible sans réseau.'**
  String get qrHint;

  /// No description provided for @refund.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement'**
  String get refund;

  /// No description provided for @scanAdmitted.
  ///
  /// In fr, this message translates to:
  /// **'Entrées'**
  String get scanAdmitted;

  /// No description provided for @scanAlreadyUsed.
  ///
  /// In fr, this message translates to:
  /// **'Déjà utilisé'**
  String get scanAlreadyUsed;

  /// No description provided for @scanCameraError.
  ///
  /// In fr, this message translates to:
  /// **'Caméra indisponible : saisis le code du billet ci-dessous.'**
  String get scanCameraError;

  /// No description provided for @scanCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Billet annulé'**
  String get scanCancelled;

  /// No description provided for @scanCheck.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier'**
  String get scanCheck;

  /// No description provided for @scanChoose.
  ///
  /// In fr, this message translates to:
  /// **'Choisis la séance à contrôler. La liste des billets est téléchargée pour scanner même sans réseau.'**
  String get scanChoose;

  /// No description provided for @scanHint.
  ///
  /// In fr, this message translates to:
  /// **'Vise le QR code du billet, ou saisis son code.'**
  String get scanHint;

  /// No description provided for @scanManual.
  ///
  /// In fr, this message translates to:
  /// **'Code du billet'**
  String get scanManual;

  /// No description provided for @scanMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode scan'**
  String get scanMode;

  /// No description provided for @scanNoSession.
  ///
  /// In fr, this message translates to:
  /// **'Aucune séance à contrôler dans les 7 prochains jours.'**
  String get scanNoSession;

  /// No description provided for @scanOffline.
  ///
  /// In fr, this message translates to:
  /// **'Hors connexion'**
  String get scanOffline;

  /// No description provided for @scanOnline.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisé'**
  String get scanOnline;

  /// No description provided for @scanPending.
  ///
  /// In fr, this message translates to:
  /// **'{count} scan(s) à envoyer'**
  String scanPending(int count);

  /// No description provided for @scanSync.
  ///
  /// In fr, this message translates to:
  /// **'Synchroniser'**
  String get scanSync;

  /// No description provided for @scanSyncedAt.
  ///
  /// In fr, this message translates to:
  /// **'Dernière synchronisation : {date}'**
  String scanSyncedAt(String date);

  /// No description provided for @scanUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Billet inconnu'**
  String get scanUnknown;

  /// No description provided for @scanValid.
  ///
  /// In fr, this message translates to:
  /// **'Billet valide'**
  String get scanValid;

  /// No description provided for @scannedOn.
  ///
  /// In fr, this message translates to:
  /// **'Scanné le {date}'**
  String scannedOn(String date);

  /// No description provided for @soldOut.
  ///
  /// In fr, this message translates to:
  /// **'Complet'**
  String get soldOut;

  /// No description provided for @soldOutWaitlist.
  ///
  /// In fr, this message translates to:
  /// **'Complet · liste d\'attente'**
  String get soldOutWaitlist;

  /// No description provided for @ticketTitle.
  ///
  /// In fr, this message translates to:
  /// **'Billet'**
  String get ticketTitle;

  /// No description provided for @ticketsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun billet} =1{1 billet} other{{count} billets}}'**
  String ticketsCount(int count);

  /// No description provided for @ticketsEmptyPast.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de sortie passée.'**
  String get ticketsEmptyPast;

  /// No description provided for @ticketsPast.
  ///
  /// In fr, this message translates to:
  /// **'Passés'**
  String get ticketsPast;

  /// No description provided for @ticketsUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get ticketsUpcoming;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @transferLink.
  ///
  /// In fr, this message translates to:
  /// **'Ou envoyer un lien'**
  String get transferLink;

  /// No description provided for @transferName.
  ///
  /// In fr, this message translates to:
  /// **'Son nom (facultatif)'**
  String get transferName;

  /// No description provided for @transferPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de ton ami'**
  String get transferPhone;

  /// No description provided for @transferSend.
  ///
  /// In fr, this message translates to:
  /// **'Transférer'**
  String get transferSend;

  /// No description provided for @transferTicket.
  ///
  /// In fr, this message translates to:
  /// **'Transférer à un ami'**
  String get transferTicket;

  /// No description provided for @transferredFrom.
  ///
  /// In fr, this message translates to:
  /// **'Offert par {name}'**
  String transferredFrom(String name);

  /// No description provided for @transferredTo.
  ///
  /// In fr, this message translates to:
  /// **'Transféré à {name}'**
  String transferredTo(String name);

  /// No description provided for @waitingOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'En attente de l\'organisateur : réponse avant {date}.'**
  String waitingOrganizer(String date);

  /// No description provided for @waitlistJoin.
  ///
  /// In fr, this message translates to:
  /// **'M\'inscrire sur la liste d\'attente'**
  String get waitlistJoin;

  /// No description provided for @waitlistJoined.
  ///
  /// In fr, this message translates to:
  /// **'Tu es sur la liste d\'attente. On te prévient dès qu\'une place se libère.'**
  String get waitlistJoined;

  /// No description provided for @waitlistLeave.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get waitlistLeave;

  /// No description provided for @waitlistOffered.
  ///
  /// In fr, this message translates to:
  /// **'Une place t\'attend : paie-la dans « Mes billets ».'**
  String get waitlistOffered;

  /// No description provided for @waitlistOn.
  ///
  /// In fr, this message translates to:
  /// **'Tu es sur la liste d\'attente.'**
  String get waitlistOn;

  /// No description provided for @offlineCopy.
  ///
  /// In fr, this message translates to:
  /// **'Hors connexion : tes billets gardés sur le téléphone.'**
  String get offlineCopy;

  /// No description provided for @paymentCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte de paiement'**
  String get paymentCard;

  /// No description provided for @paymentFees.
  ///
  /// In fr, this message translates to:
  /// **'Frais de paiement'**
  String get paymentFees;

  /// No description provided for @giftCodeOptional.
  ///
  /// In fr, this message translates to:
  /// **'Carte cadeau (facultatif)'**
  String get giftCodeOptional;

  /// No description provided for @giftCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte cadeau'**
  String get giftCard;

  /// No description provided for @downloadReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Reçu PDF'**
  String get downloadReceipt;

  /// No description provided for @giftCards.
  ///
  /// In fr, this message translates to:
  /// **'Cartes cadeaux'**
  String get giftCards;

  /// No description provided for @giftTitle.
  ///
  /// In fr, this message translates to:
  /// **'Offre une'**
  String get giftTitle;

  /// No description provided for @giftTitleEm.
  ///
  /// In fr, this message translates to:
  /// **'sortie'**
  String get giftTitleEm;

  /// No description provided for @giftLead.
  ///
  /// In fr, this message translates to:
  /// **'Une carte cadeau Dowra, valable 12 mois sur toutes les sorties réservables en ligne. Ton ami reçoit son code par SMS.'**
  String get giftLead;

  /// No description provided for @myGiftCards.
  ///
  /// In fr, this message translates to:
  /// **'Mes cartes cadeaux'**
  String get myGiftCards;

  /// No description provided for @giftOffer.
  ///
  /// In fr, this message translates to:
  /// **'Offrir une carte'**
  String get giftOffer;

  /// No description provided for @giftEvent.
  ///
  /// In fr, this message translates to:
  /// **'Tu offres : {event}'**
  String giftEvent(String event);

  /// No description provided for @giftOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre montant'**
  String get giftOther;

  /// No description provided for @giftRecipient.
  ///
  /// In fr, this message translates to:
  /// **'Prénom de la personne'**
  String get giftRecipient;

  /// No description provided for @giftRecipientRequired.
  ///
  /// In fr, this message translates to:
  /// **'Indique le prénom de la personne.'**
  String get giftRecipientRequired;

  /// No description provided for @giftRecipientPhone.
  ///
  /// In fr, this message translates to:
  /// **'Son numéro (code envoyé par SMS)'**
  String get giftRecipientPhone;

  /// No description provided for @giftMessage.
  ///
  /// In fr, this message translates to:
  /// **'Un petit mot (facultatif)'**
  String get giftMessage;

  /// No description provided for @giftSentTo.
  ///
  /// In fr, this message translates to:
  /// **'Offerte à {name}'**
  String giftSentTo(String name);

  /// No description provided for @giftReceived.
  ///
  /// In fr, this message translates to:
  /// **'Reçue'**
  String get giftReceived;

  /// No description provided for @giftBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde : {amount}'**
  String giftBalance(String amount);

  /// No description provided for @giftValidUntil.
  ///
  /// In fr, this message translates to:
  /// **'jusqu\'au {date}'**
  String giftValidUntil(String date);

  /// No description provided for @giftThisOuting.
  ///
  /// In fr, this message translates to:
  /// **'Offrir cette sortie'**
  String get giftThisOuting;

  /// No description provided for @seatsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisis tes places'**
  String get seatsTitle;

  /// No description provided for @seatsHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisis le billet, puis touche une place libre sur le plan.'**
  String get seatsHint;

  /// No description provided for @seatFree.
  ///
  /// In fr, this message translates to:
  /// **'Libre'**
  String get seatFree;

  /// No description provided for @seatTaken.
  ///
  /// In fr, this message translates to:
  /// **'Prise'**
  String get seatTaken;

  /// No description provided for @seatMine.
  ///
  /// In fr, this message translates to:
  /// **'Ta place'**
  String get seatMine;

  /// No description provided for @seatsChosen.
  ///
  /// In fr, this message translates to:
  /// **'{count} place(s)'**
  String seatsChosen(int count);

  /// No description provided for @stage.
  ///
  /// In fr, this message translates to:
  /// **'Scène'**
  String get stage;

  /// No description provided for @promoCode.
  ///
  /// In fr, this message translates to:
  /// **'Code promo (facultatif)'**
  String get promoCode;

  /// No description provided for @promoHint.
  ///
  /// In fr, this message translates to:
  /// **'La remise s\'applique quand tu valides.'**
  String get promoHint;

  /// No description provided for @groupDiscount.
  ///
  /// In fr, this message translates to:
  /// **'Offre de groupe (−{percent} %)'**
  String groupDiscount(int percent);

  /// No description provided for @groupOffer.
  ///
  /// In fr, this message translates to:
  /// **'Offre de groupe : −{percent} % dès {count} billets'**
  String groupOffer(int percent, int count);

  /// No description provided for @shuttle.
  ///
  /// In fr, this message translates to:
  /// **'Navette'**
  String get shuttle;

  /// No description provided for @organizerSpace.
  ///
  /// In fr, this message translates to:
  /// **'Espace organisateur'**
  String get organizerSpace;

  /// No description provided for @organizerSpaceHint.
  ///
  /// In fr, this message translates to:
  /// **'Événements, réservations, promotion et argent, sur le site Dowra.'**
  String get organizerSpaceHint;
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
