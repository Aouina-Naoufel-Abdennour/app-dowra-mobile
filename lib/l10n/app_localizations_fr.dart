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

  @override
  String get chooseWilayaTitle => 'Ta wilaya';

  @override
  String get allAlgeria => 'Toute l\'Algérie';

  @override
  String get weekendTitle => 'Ce week-end';

  @override
  String get featuredTitle => 'À la une';

  @override
  String get gemsTitle => 'Trésors cachés';

  @override
  String get newTitle => 'Nouveautés';

  @override
  String get wilayaOfDay => 'Wilaya du jour';

  @override
  String seeOutingsIn(String wilaya) {
    return 'Les sorties de $wilaya';
  }

  @override
  String priceFrom(String price) {
    return 'Dès $price';
  }

  @override
  String get free => 'Gratuit';

  @override
  String get badgeFeatured => 'À la une';

  @override
  String get badgeGem => 'Trésor caché';

  @override
  String get verified => 'Vérifié';

  @override
  String distanceKm(String km) {
    return '$km km';
  }

  @override
  String get searchOutings => 'Nom, lieu, artiste, organisateur…';

  @override
  String get filters => 'Filtres';

  @override
  String get apply => 'Appliquer';

  @override
  String get reset => 'Tout effacer';

  @override
  String resultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sorties',
      one: '1 sortie',
    );
    return '$_temp0';
  }

  @override
  String get noResults =>
      'Aucune sortie ne correspond. Essaie d\'élargir les dates ou la wilaya.';

  @override
  String get listView => 'Liste';

  @override
  String get mapView => 'Carte';

  @override
  String get nearMe => 'Près de moi';

  @override
  String get nearMeError =>
      'Position indisponible : autorise la localisation dans les réglages.';

  @override
  String get whenToday => 'Aujourd\'hui';

  @override
  String get whenTomorrow => 'Demain';

  @override
  String get whenWeekend => 'Ce week-end';

  @override
  String get whenWeek => 'Cette semaine';

  @override
  String get whenMonth => 'Ce mois';

  @override
  String get priceFree => 'Gratuit';

  @override
  String get priceUnder2000 => 'Moins de 2 000 DA';

  @override
  String get family => 'En famille';

  @override
  String get women => 'Entre femmes';

  @override
  String get pmr => 'Accessible PMR';

  @override
  String get hiddenGem => 'Trésor caché';

  @override
  String get indoor => 'Intérieur';

  @override
  String get outdoor => 'Plein air';

  @override
  String get anyValue => 'Tous';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortDate => 'Date';

  @override
  String get sortPopular => 'Popularité';

  @override
  String get sortPriceAsc => 'Prix croissant';

  @override
  String get sortDistance => 'Distance';

  @override
  String get when => 'Quand';

  @override
  String get price => 'Prix';

  @override
  String get setting => 'Cadre';

  @override
  String get category => 'Envie';

  @override
  String get type => 'Type de sortie';

  @override
  String get sessions => 'Dates et séances';

  @override
  String get noSessions => 'Aucune séance à venir pour le moment.';

  @override
  String get tickets => 'Billets';

  @override
  String placesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places',
      one: '1 place',
    );
    return '$_temp0';
  }

  @override
  String get pickups => 'Points de ramassage';

  @override
  String get details => 'Les infos utiles';

  @override
  String get program => 'Programme';

  @override
  String get includes => 'Compris';

  @override
  String get place => 'Lieu';

  @override
  String get meetingPoint => 'Point de rendez-vous';

  @override
  String get directions => 'Itinéraire';

  @override
  String get organizer => 'Organisateur';

  @override
  String followersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count abonnés',
      one: '1 abonné',
    );
    return '$_temp0';
  }

  @override
  String get follow => 'S\'abonner';

  @override
  String get following => 'Abonné';

  @override
  String get cancellation => 'Annulation';

  @override
  String get saleMode => 'Vente';

  @override
  String maxPerPerson(int count) {
    return 'Maximum $count billets par personne';
  }

  @override
  String ageMin(int age) {
    return 'À partir de $age ans';
  }

  @override
  String get weatherForecast => 'Météo prévue';

  @override
  String rainChance(int chance) {
    return '$chance % de pluie';
  }

  @override
  String get share => 'Partager';

  @override
  String get report => 'Signaler';

  @override
  String get reportTitle => 'Signaler cette sortie';

  @override
  String get reportReason => 'Motif';

  @override
  String get reportDetails => 'Précisions (facultatif)';

  @override
  String get reportSend => 'Envoyer';

  @override
  String get reportSent =>
      'Merci, ton signalement est envoyé à l\'équipe Dowra.';

  @override
  String get favoriteAdded => 'Ajouté à tes favoris';

  @override
  String get favoriteRemoved => 'Retiré de tes favoris';

  @override
  String get similar => 'Dans le même esprit';

  @override
  String get cancelledEvent => 'Cette sortie est annulée.';

  @override
  String get endedEvent => 'Cette sortie est terminée.';

  @override
  String get upcomingOutings => 'Ses prochaines sorties';

  @override
  String get noUpcoming => 'Pas de sortie à venir pour le moment.';

  @override
  String pastOutings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sorties passées',
      one: '1 sortie passée',
      zero: 'Aucune sortie passée',
    );
    return '$_temp0';
  }

  @override
  String get about => 'À propos';

  @override
  String get contact => 'Contact';

  @override
  String get reportOrganizer => 'Signaler cet organisateur';

  @override
  String get loginToContinue => 'Connecte-toi pour continuer';

  @override
  String get addToCalendar => 'Ajouter au calendrier';

  @override
  String alreadyBooked(int count) {
    return '$count déjà réservé(s)';
  }

  @override
  String get bookChannel => 'Comment veux-tu réserver ?';

  @override
  String get bookChoose => 'Choisis au moins un billet.';

  @override
  String get bookConfirmFree => 'Confirmer mon inscription';

  @override
  String get bookGroup => 'Sortir à plusieurs';

  @override
  String get bookGroupText =>
      'Crée un lien de groupe et partage-le : chacun réserve sa place, ou tu paies pour tout le monde et chacun récupère son billet.';

  @override
  String get bookHoldInfo =>
      'Tes places sont bloquées 10 minutes pendant le paiement.';

  @override
  String bookHolder(int n) {
    return 'Participant $n';
  }

  @override
  String get bookHolders => 'Noms des participants';

  @override
  String get bookHoldersHint =>
      'Billets nominatifs : le nom de chaque participant est contrôlé à l\'entrée.';

  @override
  String get bookNotAvailable =>
      'Cette sortie ne prend pas encore de réservation sur Dowra.';

  @override
  String get bookNote => 'Un message pour l\'organisateur (facultatif)';

  @override
  String get bookOnline => 'Billet payé en ligne';

  @override
  String get bookOnlineHint =>
      'CIB ou Edahabia : ta place est garantie tout de suite.';

  @override
  String get bookOptions => 'Options';

  @override
  String bookPay(String amount) {
    return 'Payer $amount';
  }

  @override
  String get bookSendRequest => 'Envoyer la demande';

  @override
  String get bookSession => 'Choisis ta séance';

  @override
  String get bookSimple => 'Réservation simple';

  @override
  String get bookSimpleHint => 'L\'organisateur confirme sous 48 heures.';

  @override
  String get bookTitle => 'Réserver';

  @override
  String get callOrganizer => 'Appeler l\'organisateur';

  @override
  String get cancelBooking => 'Annuler la réservation';

  @override
  String get cancelBookingConfirm => 'Oui, annuler';

  @override
  String get cancelBookingText =>
      'Les billets seront annulés et le paiement en ligne remboursé selon la règle de l\'organisateur.';

  @override
  String cancelledBy(String who) {
    return 'Annulée par : $who';
  }

  @override
  String get claimShare => 'Envoyer le lien du billet';

  @override
  String depositToPay(String amount) {
    return 'Acompte à régler : $amount';
  }

  @override
  String get entryDeadline => 'Entrée jusqu\'à';

  @override
  String get findOuting => 'Trouver une sortie';

  @override
  String get fromPrice => 'À partir de';

  @override
  String fromWaitlist(String time) {
    return 'Place proposée par la liste d\'attente : paie-la avant $time.';
  }

  @override
  String get groupEach => 'Chacun paie sa part';

  @override
  String get groupOne => 'Je paie pour tout le monde';

  @override
  String get groupShare => 'Lien du groupe';

  @override
  String get notCancellable =>
      'Selon la règle de l\'organisateur, cette réservation ne peut plus être annulée.';

  @override
  String payBefore(String time) {
    return 'Places bloquées jusqu\'à $time';
  }

  @override
  String payNow(String amount) {
    return 'Payer $amount';
  }

  @override
  String get paymentMethod => 'Paiement';

  @override
  String get placesAvailable => 'Places disponibles';

  @override
  String placesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places restantes',
      one: '1 place restante',
    );
    return '$_temp0';
  }

  @override
  String get qrHint =>
      'Présente ce QR code à l\'entrée. Il reste visible sans réseau.';

  @override
  String get refund => 'Remboursement';

  @override
  String get scanAdmitted => 'Entrées';

  @override
  String get scanAlreadyUsed => 'Déjà utilisé';

  @override
  String get scanCameraError =>
      'Caméra indisponible : saisis le code du billet ci-dessous.';

  @override
  String get scanCancelled => 'Billet annulé';

  @override
  String get scanCheck => 'Vérifier';

  @override
  String get scanChoose =>
      'Choisis la séance à contrôler. La liste des billets est téléchargée pour scanner même sans réseau.';

  @override
  String get scanHint => 'Vise le QR code du billet, ou saisis son code.';

  @override
  String get scanManual => 'Code du billet';

  @override
  String get scanMode => 'Mode scan';

  @override
  String get scanNoSession =>
      'Aucune séance à contrôler dans les 7 prochains jours.';

  @override
  String get scanOffline => 'Hors connexion';

  @override
  String get scanOnline => 'Synchronisé';

  @override
  String scanPending(int count) {
    return '$count scan(s) à envoyer';
  }

  @override
  String get scanSync => 'Synchroniser';

  @override
  String scanSyncedAt(String date) {
    return 'Dernière synchronisation : $date';
  }

  @override
  String get scanUnknown => 'Billet inconnu';

  @override
  String get scanValid => 'Billet valide';

  @override
  String scannedOn(String date) {
    return 'Scanné le $date';
  }

  @override
  String get soldOut => 'Complet';

  @override
  String get soldOutWaitlist => 'Complet · liste d\'attente';

  @override
  String get ticketTitle => 'Billet';

  @override
  String ticketsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count billets',
      one: '1 billet',
      zero: 'Aucun billet',
    );
    return '$_temp0';
  }

  @override
  String get ticketsEmptyPast => 'Pas encore de sortie passée.';

  @override
  String get ticketsPast => 'Passés';

  @override
  String get ticketsUpcoming => 'À venir';

  @override
  String get total => 'Total';

  @override
  String get transferLink => 'Ou envoyer un lien';

  @override
  String get transferName => 'Son nom (facultatif)';

  @override
  String get transferPhone => 'Numéro de ton ami';

  @override
  String get transferSend => 'Transférer';

  @override
  String get transferTicket => 'Transférer à un ami';

  @override
  String transferredFrom(String name) {
    return 'Offert par $name';
  }

  @override
  String transferredTo(String name) {
    return 'Transféré à $name';
  }

  @override
  String waitingOrganizer(String date) {
    return 'En attente de l\'organisateur : réponse avant $date.';
  }

  @override
  String get waitlistJoin => 'M\'inscrire sur la liste d\'attente';

  @override
  String get waitlistJoined =>
      'Tu es sur la liste d\'attente. On te prévient dès qu\'une place se libère.';

  @override
  String get waitlistLeave => 'Quitter';

  @override
  String get waitlistOffered =>
      'Une place t\'attend : paie-la dans « Mes billets ».';

  @override
  String get waitlistOn => 'Tu es sur la liste d\'attente.';

  @override
  String get offlineCopy =>
      'Hors connexion : tes billets gardés sur le téléphone.';
}
