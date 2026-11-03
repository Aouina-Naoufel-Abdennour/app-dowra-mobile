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

  @override
  String get chooseWilayaTitle => 'Your wilaya';

  @override
  String get allAlgeria => 'All of Algeria';

  @override
  String get weekendTitle => 'This weekend';

  @override
  String get featuredTitle => 'Featured';

  @override
  String get gemsTitle => 'Hidden gems';

  @override
  String get newTitle => 'New';

  @override
  String get wilayaOfDay => 'Wilaya of the day';

  @override
  String seeOutingsIn(String wilaya) {
    return 'Outings in $wilaya';
  }

  @override
  String priceFrom(String price) {
    return 'From $price';
  }

  @override
  String get free => 'Free';

  @override
  String get badgeFeatured => 'Featured';

  @override
  String get badgeGem => 'Hidden gem';

  @override
  String get verified => 'Verified';

  @override
  String distanceKm(String km) {
    return '$km km';
  }

  @override
  String get searchOutings => 'Name, place, artist, organiser…';

  @override
  String get filters => 'Filters';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Clear all';

  @override
  String resultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count outings',
      one: '1 outing',
    );
    return '$_temp0';
  }

  @override
  String get noResults =>
      'No outing matches. Try wider dates or another wilaya.';

  @override
  String get listView => 'List';

  @override
  String get mapView => 'Map';

  @override
  String get nearMe => 'Near me';

  @override
  String get nearMeError => 'Location unavailable: allow location in settings.';

  @override
  String get whenToday => 'Today';

  @override
  String get whenTomorrow => 'Tomorrow';

  @override
  String get whenWeekend => 'This weekend';

  @override
  String get whenWeek => 'This week';

  @override
  String get whenMonth => 'This month';

  @override
  String get priceFree => 'Free';

  @override
  String get priceUnder2000 => 'Under 2,000 DA';

  @override
  String get family => 'Family';

  @override
  String get women => 'Women only';

  @override
  String get pmr => 'Wheelchair accessible';

  @override
  String get hiddenGem => 'Hidden gem';

  @override
  String get indoor => 'Indoor';

  @override
  String get outdoor => 'Outdoor';

  @override
  String get anyValue => 'All';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortDate => 'Date';

  @override
  String get sortPopular => 'Popularity';

  @override
  String get sortPriceAsc => 'Price, low to high';

  @override
  String get sortDistance => 'Distance';

  @override
  String get when => 'When';

  @override
  String get price => 'Price';

  @override
  String get setting => 'Setting';

  @override
  String get category => 'Mood';

  @override
  String get type => 'Kind of outing';

  @override
  String get sessions => 'Dates and times';

  @override
  String get noSessions => 'No upcoming date for now.';

  @override
  String get tickets => 'Tickets';

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
  String get pickups => 'Pick-up points';

  @override
  String get details => 'Good to know';

  @override
  String get program => 'Programme';

  @override
  String get includes => 'Included';

  @override
  String get place => 'Place';

  @override
  String get meetingPoint => 'Meeting point';

  @override
  String get directions => 'Directions';

  @override
  String get organizer => 'Organiser';

  @override
  String followersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '1 follower',
    );
    return '$_temp0';
  }

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get cancellation => 'Cancellation';

  @override
  String get saleMode => 'Sales';

  @override
  String maxPerPerson(int count) {
    return 'Up to $count tickets per person';
  }

  @override
  String ageMin(int age) {
    return 'Ages $age and up';
  }

  @override
  String get weatherForecast => 'Weather forecast';

  @override
  String rainChance(int chance) {
    return '$chance% chance of rain';
  }

  @override
  String get share => 'Share';

  @override
  String get report => 'Report';

  @override
  String get reportTitle => 'Report this outing';

  @override
  String get reportReason => 'Reason';

  @override
  String get reportDetails => 'Details (optional)';

  @override
  String get reportSend => 'Send';

  @override
  String get reportSent =>
      'Thanks, your report has been sent to the Dowra team.';

  @override
  String get favoriteAdded => 'Added to your favourites';

  @override
  String get favoriteRemoved => 'Removed from your favourites';

  @override
  String get similar => 'In the same spirit';

  @override
  String get cancelledEvent => 'This outing is cancelled.';

  @override
  String get endedEvent => 'This outing has ended.';

  @override
  String get upcomingOutings => 'Upcoming outings';

  @override
  String get noUpcoming => 'No upcoming outing for now.';

  @override
  String pastOutings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count past outings',
      one: '1 past outing',
      zero: 'No past outings',
    );
    return '$_temp0';
  }

  @override
  String get about => 'About';

  @override
  String get contact => 'Contact';

  @override
  String get reportOrganizer => 'Report this organiser';

  @override
  String get loginToContinue => 'Log in to continue';

  @override
  String get addToCalendar => 'Add to calendar';

  @override
  String alreadyBooked(int count) {
    return '$count already booked';
  }

  @override
  String get bookChannel => 'How do you want to book?';

  @override
  String get bookChoose => 'Pick at least one ticket.';

  @override
  String get bookConfirmFree => 'Confirm my registration';

  @override
  String get bookGroup => 'Going with friends';

  @override
  String get bookGroupText =>
      'Create a group link and share it: everyone books their spot, or you pay for everyone and each friend collects their ticket.';

  @override
  String get bookHoldInfo =>
      'Your spots are held for 10 minutes while you pay.';

  @override
  String bookHolder(int n) {
    return 'Attendee $n';
  }

  @override
  String get bookHolders => 'Attendee names';

  @override
  String get bookHoldersHint =>
      'Personal tickets: each attendee\'s name is checked at the entrance.';

  @override
  String get bookNotAvailable =>
      'This outing doesn\'t take bookings on Dowra yet.';

  @override
  String get bookNote => 'A message for the organizer (optional)';

  @override
  String get bookOnline => 'Ticket paid online';

  @override
  String get bookOnlineHint =>
      'CIB or Edahabia: your spot is guaranteed right away.';

  @override
  String get bookOptions => 'Options';

  @override
  String bookPay(String amount) {
    return 'Pay $amount';
  }

  @override
  String get bookSendRequest => 'Send the request';

  @override
  String get bookSession => 'Pick your session';

  @override
  String get bookSimple => 'Simple booking';

  @override
  String get bookSimpleHint => 'The organizer confirms within 48 hours.';

  @override
  String get bookTitle => 'Book';

  @override
  String get callOrganizer => 'Call the organizer';

  @override
  String get cancelBooking => 'Cancel the booking';

  @override
  String get cancelBookingConfirm => 'Yes, cancel';

  @override
  String get cancelBookingText =>
      'Tickets will be cancelled and the online payment refunded under the organizer\'s policy.';

  @override
  String cancelledBy(String who) {
    return 'Cancelled by: $who';
  }

  @override
  String get claimShare => 'Send the ticket link';

  @override
  String depositToPay(String amount) {
    return 'Deposit to pay: $amount';
  }

  @override
  String get entryDeadline => 'Entry until';

  @override
  String get findOuting => 'Find an outing';

  @override
  String get fromPrice => 'From';

  @override
  String fromWaitlist(String time) {
    return 'Spot from the waiting list: pay before $time.';
  }

  @override
  String get groupEach => 'Everyone pays their share';

  @override
  String get groupOne => 'I pay for everyone';

  @override
  String get groupShare => 'Group link';

  @override
  String get notCancellable =>
      'Under the organizer\'s policy, this booking can no longer be cancelled.';

  @override
  String payBefore(String time) {
    return 'Spots held until $time';
  }

  @override
  String payNow(String amount) {
    return 'Pay $amount';
  }

  @override
  String get paymentMethod => 'Payment';

  @override
  String get placesAvailable => 'Spots available';

  @override
  String placesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spots left',
      one: '1 spot left',
    );
    return '$_temp0';
  }

  @override
  String get qrHint =>
      'Show this QR code at the entrance. It stays visible offline.';

  @override
  String get refund => 'Refund';

  @override
  String get scanAdmitted => 'Admitted';

  @override
  String get scanAlreadyUsed => 'Already used';

  @override
  String get scanCameraError =>
      'Camera unavailable: type the ticket code below.';

  @override
  String get scanCancelled => 'Cancelled ticket';

  @override
  String get scanCheck => 'Check';

  @override
  String get scanChoose =>
      'Pick the session to check. The ticket list is downloaded so you can scan offline.';

  @override
  String get scanHint => 'Point at the ticket\'s QR code, or type its code.';

  @override
  String get scanManual => 'Ticket code';

  @override
  String get scanMode => 'Scan mode';

  @override
  String get scanNoSession => 'No session to check in the next 7 days.';

  @override
  String get scanOffline => 'Offline';

  @override
  String get scanOnline => 'Synced';

  @override
  String scanPending(int count) {
    return '$count scan(s) to send';
  }

  @override
  String get scanSync => 'Sync';

  @override
  String scanSyncedAt(String date) {
    return 'Last sync: $date';
  }

  @override
  String get scanUnknown => 'Unknown ticket';

  @override
  String get scanValid => 'Valid ticket';

  @override
  String scannedOn(String date) {
    return 'Scanned on $date';
  }

  @override
  String get soldOut => 'Sold out';

  @override
  String get soldOutWaitlist => 'Sold out · waiting list';

  @override
  String get ticketTitle => 'Ticket';

  @override
  String ticketsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets',
      one: '1 ticket',
      zero: 'No ticket',
    );
    return '$_temp0';
  }

  @override
  String get ticketsEmptyPast => 'No past outings yet.';

  @override
  String get ticketsPast => 'Past';

  @override
  String get ticketsUpcoming => 'Upcoming';

  @override
  String get total => 'Total';

  @override
  String get transferLink => 'Or send a link';

  @override
  String get transferName => 'Their name (optional)';

  @override
  String get transferPhone => 'Your friend\'s number';

  @override
  String get transferSend => 'Transfer';

  @override
  String get transferTicket => 'Transfer to a friend';

  @override
  String transferredFrom(String name) {
    return 'From $name';
  }

  @override
  String transferredTo(String name) {
    return 'Transferred to $name';
  }

  @override
  String waitingOrganizer(String date) {
    return 'Waiting for the organizer: reply before $date.';
  }

  @override
  String get waitlistJoin => 'Join the waiting list';

  @override
  String get waitlistJoined =>
      'You\'re on the waiting list. We\'ll let you know as soon as a spot opens.';

  @override
  String get waitlistLeave => 'Leave';

  @override
  String get waitlistOffered =>
      'A spot is waiting: pay for it in “My tickets”.';

  @override
  String get waitlistOn => 'You\'re on the waiting list.';

  @override
  String get offlineCopy => 'Offline: your tickets saved on this phone.';

  @override
  String get paymentCard => 'Payment card';

  @override
  String get paymentFees => 'Payment fees';

  @override
  String get giftCodeOptional => 'Gift card (optional)';

  @override
  String get giftCard => 'Gift card';

  @override
  String get downloadReceipt => 'PDF receipt';

  @override
  String get giftCards => 'Gift cards';

  @override
  String get giftTitle => 'Give an';

  @override
  String get giftTitleEm => 'outing';

  @override
  String get giftLead =>
      'A Dowra gift card, valid for 12 months on every outing booked online. Your friend gets the code by SMS.';

  @override
  String get myGiftCards => 'My gift cards';

  @override
  String get giftOffer => 'Give a card';

  @override
  String giftEvent(String event) {
    return 'You are giving: $event';
  }

  @override
  String get giftOther => 'Other amount';

  @override
  String get giftRecipient => 'Their first name';

  @override
  String get giftRecipientRequired => 'Enter their first name.';

  @override
  String get giftRecipientPhone => 'Their number (code sent by SMS)';

  @override
  String get giftMessage => 'A short note (optional)';

  @override
  String giftSentTo(String name) {
    return 'Given to $name';
  }

  @override
  String get giftReceived => 'Received';

  @override
  String giftBalance(String amount) {
    return 'Balance: $amount';
  }

  @override
  String giftValidUntil(String date) {
    return 'until $date';
  }

  @override
  String get giftThisOuting => 'Give this outing';
}
