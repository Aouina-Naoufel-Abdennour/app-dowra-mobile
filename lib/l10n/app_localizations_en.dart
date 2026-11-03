// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dowra';

  @override
  String get welcomeKicker => 'Yallah, nedowrou!';

  @override
  String get welcomeTitle => 'Discover Algeria, one outing at a time.';

  @override
  String get welcomeLead =>
      'Hikes, concerts, beaches and the Great South, booked in 2 minutes with verified organisers.';

  @override
  String get start => 'Get started';

  @override
  String get haveAccount => 'I already have an account';

  @override
  String get loginTitle => 'Enter your';

  @override
  String get loginTitleEm => 'number';

  @override
  String get loginLead => 'You\'ll get a code by SMS. No password to remember.';

  @override
  String get phoneLabel => 'Mobile number';

  @override
  String get phoneHint => '05 50 12 34 56';

  @override
  String get sendCode => 'Get the code';

  @override
  String get invalidPhone => 'Enter an Algerian mobile number (05, 06 or 07).';

  @override
  String get networkError =>
      'The Dowra server isn\'t responding. Try again in a moment.';

  @override
  String get codeTitle => 'Enter your';

  @override
  String get codeTitleEm => 'code';

  @override
  String codeSentTo(String phone) {
    return 'We sent an SMS to $phone';
  }

  @override
  String get verify => 'Verify';

  @override
  String get changeNumber => 'Change number';

  @override
  String get testAccounts => 'Test accounts';

  @override
  String get demoHint =>
      'Test mode: a test account number and the code 123456 are already filled in.';

  @override
  String get terms => 'By continuing, you accept Dowra\'s terms of use.';

  @override
  String get onboardingKicker => 'Welcome to Dowra!';

  @override
  String get onboardingTitle => 'Meet';

  @override
  String get onboardingTitleEm => 'Dowri';

  @override
  String get onboardingLead =>
      'Three questions and I\'ll suggest outings that suit you.';

  @override
  String get nameQuestion => 'What\'s your name?';

  @override
  String get wilayaQuestion => 'Where do you leave from?';

  @override
  String get interestsQuestion => 'What are you into?';

  @override
  String get interestsHint => 'Pick as many as you like.';

  @override
  String get chooseWilaya => 'Choose a wilaya';

  @override
  String get wilayasOpen => 'Open';

  @override
  String get wilayasSoon => 'Soon';

  @override
  String get discover => 'Discover my outings';

  @override
  String get later => 'Later';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navTickets => 'Tickets';

  @override
  String get navFavorites => 'Favourites';

  @override
  String get navProfile => 'Profile';

  @override
  String homeHello(String name) {
    return 'Salam $name,';
  }

  @override
  String get homeHelloGuest => 'Salam,';

  @override
  String get homeQuestion => 'where are we';

  @override
  String get homeQuestionEm => 'going?';

  @override
  String get searchHint => 'Destination, outing, organiser…';

  @override
  String get heroKicker => 'Great South';

  @override
  String get heroTitle => 'This weekend, we\'re off to Taghit';

  @override
  String get heroText =>
      'Organisers\' outings show up here, with their departures and prices.';

  @override
  String get typesTitle => 'Kinds of outing';

  @override
  String get interestsTitle => 'Your interests';

  @override
  String get citiesTitle => 'Departure cities';

  @override
  String get open => 'Open';

  @override
  String get seeAll => 'See all';

  @override
  String get exploreTitle => 'Explore';

  @override
  String get exploreLead =>
      'Pick a kind of outing: departures show up here as soon as organisers publish them.';

  @override
  String get ticketsTitle => 'My';

  @override
  String get ticketsTitleEm => 'tickets';

  @override
  String get ticketsEmpty =>
      'Your tickets will show up here after your first booking, with their QR code.';

  @override
  String get favoritesTitle => 'My';

  @override
  String get favoritesTitleEm => 'favourites';

  @override
  String get favoritesEmpty =>
      'Tap the heart on an outing or organiser to find it here.';

  @override
  String get guestTitle => 'Log in to continue';

  @override
  String get guestText =>
      'A mobile number is all it takes: your tickets, favourites and passport are waiting.';

  @override
  String get login => 'Log in';

  @override
  String get profileTitle => 'My';

  @override
  String get profileTitleEm => 'passport';

  @override
  String get level => 'Level';

  @override
  String points(int count) {
    return '$count pts';
  }

  @override
  String get ambassador => 'Ambassador';

  @override
  String get personalInfo => 'Personal information';

  @override
  String get language => 'Language';

  @override
  String get display => 'Display';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get logout => 'Log out';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteConfirmTitle => 'Delete your account?';

  @override
  String get deleteConfirmText =>
      'Your profile and preferences are erased. You can create a new account with the same number.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved.';

  @override
  String get name => 'Full name';

  @override
  String get email => 'Email (optional)';

  @override
  String get wilaya => 'My wilaya';

  @override
  String get interests => 'My interests';

  @override
  String get retry => 'Try again';

  @override
  String get emptyReferentials =>
      'Lists appear as soon as the Dowra server responds.';
}
