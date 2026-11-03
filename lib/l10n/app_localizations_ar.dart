// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'دورة';

  @override
  String get welcomeKicker => 'يالله، ندورو!';

  @override
  String get welcomeTitle => 'اكتشف الجزائر، خرجة بعد خرجة.';

  @override
  String get welcomeLead =>
      'رحلات مشي، حفلات، شواطئ والجنوب الكبير، تحجز في دقيقتين مع منظمين موثقين.';

  @override
  String get start => 'ابدأ';

  @override
  String get haveAccount => 'لدي حساب';

  @override
  String get loginTitle => 'أدخل';

  @override
  String get loginTitleEm => 'رقمك';

  @override
  String get loginLead => 'يصلك رمز عبر رسالة قصيرة. لا كلمة سر لتتذكرها.';

  @override
  String get phoneLabel => 'رقم الهاتف المحمول';

  @override
  String get phoneHint => '05 50 12 34 56';

  @override
  String get sendCode => 'استلام الرمز';

  @override
  String get invalidPhone => 'أدخل رقم هاتف محمول جزائري (05 أو 06 أو 07).';

  @override
  String get networkError => 'خادم دورة لا يستجيب. أعد المحاولة بعد لحظة.';

  @override
  String get codeTitle => 'أدخل';

  @override
  String get codeTitleEm => 'الرمز';

  @override
  String codeSentTo(String phone) {
    return 'أرسلنا رسالة قصيرة إلى $phone';
  }

  @override
  String get verify => 'تحقق';

  @override
  String get changeNumber => 'تغيير الرقم';

  @override
  String get testAccounts => 'حسابات تجريبية';

  @override
  String get demoHint =>
      'وضع الاختبار: رقم حساب تجريبي والرمز 123456 مملوءان مسبقا.';

  @override
  String get terms => 'بالمتابعة، أنت توافق على شروط استخدام دورة.';

  @override
  String get onboardingKicker => 'مرحبا بك في دورة!';

  @override
  String get onboardingTitle => 'تعرف على';

  @override
  String get onboardingTitleEm => 'دوري';

  @override
  String get onboardingLead => 'ثلاثة أسئلة وأقترح عليك الخرجات التي تناسبك.';

  @override
  String get nameQuestion => 'ما اسمك؟';

  @override
  String get wilayaQuestion => 'من أين تنطلق؟';

  @override
  String get interestsQuestion => 'ماذا تحب؟';

  @override
  String get interestsHint => 'اختر ما تشاء من الاهتمامات.';

  @override
  String get chooseWilaya => 'اختر ولاية';

  @override
  String get wilayasOpen => 'مفتوحة';

  @override
  String get wilayasSoon => 'قريبا';

  @override
  String get discover => 'اكتشف خرجاتي';

  @override
  String get later => 'لاحقا';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navExplore => 'استكشف';

  @override
  String get navTickets => 'التذاكر';

  @override
  String get navFavorites => 'المفضلة';

  @override
  String get navProfile => 'حسابي';

  @override
  String homeHello(String name) {
    return 'السلام $name،';
  }

  @override
  String get homeHelloGuest => 'السلام،';

  @override
  String get homeQuestion => 'وين';

  @override
  String get homeQuestionEm => 'نخرجو؟';

  @override
  String get searchHint => 'وجهة، خرجة، منظم…';

  @override
  String get heroKicker => 'الجنوب الكبير';

  @override
  String get heroTitle => 'هذا الأسبوع، رايحين إلى تاغيت';

  @override
  String get heroText => 'تظهر هنا خرجات المنظمين مع مواعيد انطلاقها وأسعارها.';

  @override
  String get typesTitle => 'أنواع الخرجات';

  @override
  String get interestsTitle => 'اهتماماتك';

  @override
  String get citiesTitle => 'مدن الانطلاق';

  @override
  String get open => 'مفتوحة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get exploreTitle => 'استكشف';

  @override
  String get exploreLead =>
      'اختر نوع خرجة: تظهر الرحلات هنا بمجرد أن ينشرها المنظمون.';

  @override
  String get ticketsTitle => '';

  @override
  String get ticketsTitleEm => 'تذاكري';

  @override
  String get ticketsEmpty => 'ستظهر تذاكرك هنا بعد أول حجز، مع رمز QR.';

  @override
  String get favoritesTitle => '';

  @override
  String get favoritesTitleEm => 'مفضلتي';

  @override
  String get favoritesEmpty => 'اضغط على قلب خرجة أو منظم لتجده هنا.';

  @override
  String get guestTitle => 'سجل الدخول للمتابعة';

  @override
  String get guestText => 'يكفي رقم هاتفك: تذاكرك ومفضلتك وجوازك في انتظارك.';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get profileTitle => '';

  @override
  String get profileTitleEm => 'جوازي';

  @override
  String get level => 'المستوى';

  @override
  String points(int count) {
    return '$count نقطة';
  }

  @override
  String get ambassador => 'سفير';

  @override
  String get personalInfo => 'المعلومات الشخصية';

  @override
  String get language => 'اللغة';

  @override
  String get display => 'العرض';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'الجهاز';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف حسابي';

  @override
  String get deleteConfirmTitle => 'حذف حسابك؟';

  @override
  String get deleteConfirmText =>
      'يحذف ملفك وتفضيلاتك. يمكنك إنشاء حساب جديد بنفس الرقم.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get saved => 'تم الحفظ.';

  @override
  String get name => 'الاسم واللقب';

  @override
  String get email => 'البريد الإلكتروني (اختياري)';

  @override
  String get wilaya => 'ولايتي';

  @override
  String get interests => 'اهتماماتي';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get emptyReferentials => 'تظهر القوائم بمجرد أن يستجيب خادم دورة.';

  @override
  String get chooseWilayaTitle => 'ولايتك';

  @override
  String get allAlgeria => 'كل الجزائر';

  @override
  String get weekendTitle => 'هذا الأسبوع';

  @override
  String get featuredTitle => 'في الواجهة';

  @override
  String get gemsTitle => 'كنوز مخفية';

  @override
  String get newTitle => 'الجديد';

  @override
  String get wilayaOfDay => 'ولاية اليوم';

  @override
  String seeOutingsIn(String wilaya) {
    return 'خرجات $wilaya';
  }

  @override
  String priceFrom(String price) {
    return 'ابتداء من $price';
  }

  @override
  String get free => 'مجاني';

  @override
  String get badgeFeatured => 'في الواجهة';

  @override
  String get badgeGem => 'كنز مخفي';

  @override
  String get verified => 'موثق';

  @override
  String distanceKm(String km) {
    return '$km كلم';
  }

  @override
  String get searchOutings => 'الاسم، المكان، الفنان، المنظم…';

  @override
  String get filters => 'التصفية';

  @override
  String get apply => 'تطبيق';

  @override
  String get reset => 'مسح الكل';

  @override
  String resultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خرجة',
      two: 'خرجتان',
      one: 'خرجة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get noResults => 'لا توجد خرجة مطابقة. جرب توسيع التواريخ أو الولاية.';

  @override
  String get listView => 'قائمة';

  @override
  String get mapView => 'خريطة';

  @override
  String get nearMe => 'بالقرب مني';

  @override
  String get nearMeError => 'الموقع غير متاح: اسمح بتحديد الموقع في الإعدادات.';

  @override
  String get whenToday => 'اليوم';

  @override
  String get whenTomorrow => 'غدا';

  @override
  String get whenWeekend => 'نهاية الأسبوع';

  @override
  String get whenWeek => 'هذا الأسبوع';

  @override
  String get whenMonth => 'هذا الشهر';

  @override
  String get priceFree => 'مجاني';

  @override
  String get priceUnder2000 => 'أقل من 2000 دج';

  @override
  String get family => 'مع العائلة';

  @override
  String get women => 'بين النساء';

  @override
  String get pmr => 'مهيأ لذوي الإعاقة';

  @override
  String get hiddenGem => 'كنز مخفي';

  @override
  String get indoor => 'داخلي';

  @override
  String get outdoor => 'في الهواء الطلق';

  @override
  String get anyValue => 'الكل';

  @override
  String get sortBy => 'الترتيب حسب';

  @override
  String get sortDate => 'التاريخ';

  @override
  String get sortPopular => 'الشعبية';

  @override
  String get sortPriceAsc => 'السعر تصاعديا';

  @override
  String get sortDistance => 'المسافة';

  @override
  String get when => 'متى';

  @override
  String get price => 'السعر';

  @override
  String get setting => 'الإطار';

  @override
  String get category => 'الرغبة';

  @override
  String get type => 'نوع الخرجة';

  @override
  String get sessions => 'التواريخ والمواعيد';

  @override
  String get noSessions => 'لا يوجد موعد قادم حاليا.';

  @override
  String get tickets => 'التذاكر';

  @override
  String placesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مكان',
      one: 'مكان واحد',
    );
    return '$_temp0';
  }

  @override
  String get pickups => 'نقاط الالتقاء';

  @override
  String get details => 'معلومات مفيدة';

  @override
  String get program => 'البرنامج';

  @override
  String get includes => 'يشمل';

  @override
  String get place => 'المكان';

  @override
  String get meetingPoint => 'نقطة الالتقاء';

  @override
  String get directions => 'المسار';

  @override
  String get organizer => 'المنظم';

  @override
  String followersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مشترك',
      one: 'مشترك واحد',
    );
    return '$_temp0';
  }

  @override
  String get follow => 'اشترك';

  @override
  String get following => 'مشترك';

  @override
  String get cancellation => 'الإلغاء';

  @override
  String get saleMode => 'البيع';

  @override
  String maxPerPerson(int count) {
    return '$count تذاكر كحد أقصى للشخص';
  }

  @override
  String ageMin(int age) {
    return 'ابتداء من $age سنة';
  }

  @override
  String get weatherForecast => 'الطقس المتوقع';

  @override
  String rainChance(int chance) {
    return '$chance % احتمال المطر';
  }

  @override
  String get share => 'مشاركة';

  @override
  String get report => 'إبلاغ';

  @override
  String get reportTitle => 'الإبلاغ عن هذه الخرجة';

  @override
  String get reportReason => 'السبب';

  @override
  String get reportDetails => 'تفاصيل (اختياري)';

  @override
  String get reportSend => 'إرسال';

  @override
  String get reportSent => 'شكرا، تم إرسال بلاغك إلى فريق دورة.';

  @override
  String get favoriteAdded => 'أضيفت إلى مفضلتك';

  @override
  String get favoriteRemoved => 'أزيلت من مفضلتك';

  @override
  String get similar => 'بنفس الروح';

  @override
  String get cancelledEvent => 'هذه الخرجة ملغاة.';

  @override
  String get endedEvent => 'انتهت هذه الخرجة.';

  @override
  String get upcomingOutings => 'خرجاته القادمة';

  @override
  String get noUpcoming => 'لا توجد خرجة قادمة حاليا.';

  @override
  String pastOutings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خرجة سابقة',
      one: 'خرجة سابقة واحدة',
      zero: 'لا توجد خرجات سابقة',
    );
    return '$_temp0';
  }

  @override
  String get about => 'نبذة';

  @override
  String get contact => 'اتصال';

  @override
  String get reportOrganizer => 'الإبلاغ عن هذا المنظم';

  @override
  String get loginToContinue => 'سجل الدخول للمتابعة';

  @override
  String get addToCalendar => 'أضف إلى التقويم';

  @override
  String alreadyBooked(int count) {
    return '$count محجوزة مسبقًا';
  }

  @override
  String get bookChannel => 'كيف تريد الحجز؟';

  @override
  String get bookChoose => 'اختر تذكرة واحدة على الأقل.';

  @override
  String get bookConfirmFree => 'تأكيد التسجيل';

  @override
  String get bookGroup => 'اخرج مع أصدقائك';

  @override
  String get bookGroupText =>
      'أنشئ رابط مجموعة وشاركه: كل واحد يحجز مكانه، أو تدفع للجميع وكل واحد يستلم تذكرته.';

  @override
  String get bookHoldInfo => 'أماكنك محجوزة لمدة 10 دقائق أثناء الدفع.';

  @override
  String bookHolder(int n) {
    return 'المشارك $n';
  }

  @override
  String get bookHolders => 'أسماء المشاركين';

  @override
  String get bookHoldersHint =>
      'تذاكر اسمية: يُتحقق من اسم كل مشارك عند الدخول.';

  @override
  String get bookNotAvailable => 'هذه الخرجة لا تقبل الحجز على دورة حاليًا.';

  @override
  String get bookNote => 'رسالة للمنظّم (اختياري)';

  @override
  String get bookOnline => 'تذكرة مدفوعة عبر الإنترنت';

  @override
  String get bookOnlineHint => 'CIB أو الذهبية: مكانك مضمون فورًا.';

  @override
  String get bookOptions => 'خيارات';

  @override
  String bookPay(String amount) {
    return 'ادفع $amount';
  }

  @override
  String get bookSendRequest => 'إرسال الطلب';

  @override
  String get bookSession => 'اختر الحصة';

  @override
  String get bookSimple => 'حجز بسيط';

  @override
  String get bookSimpleHint => 'يؤكد المنظّم خلال 48 ساعة.';

  @override
  String get bookTitle => 'احجز';

  @override
  String get callOrganizer => 'اتصل بالمنظّم';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get cancelBookingConfirm => 'نعم، ألغِ';

  @override
  String get cancelBookingText =>
      'ستُلغى التذاكر ويُسترجع الدفع حسب قاعدة المنظّم.';

  @override
  String cancelledBy(String who) {
    return 'ألغاه: $who';
  }

  @override
  String get claimShare => 'أرسل رابط التذكرة';

  @override
  String depositToPay(String amount) {
    return 'العربون المطلوب: $amount';
  }

  @override
  String get entryDeadline => 'الدخول حتى';

  @override
  String get findOuting => 'ابحث عن خرجة';

  @override
  String get fromPrice => 'ابتداءً من';

  @override
  String fromWaitlist(String time) {
    return 'مكان من قائمة الانتظار: ادفعه قبل $time.';
  }

  @override
  String get groupEach => 'كل واحد يدفع حصته';

  @override
  String get groupOne => 'أدفع للجميع';

  @override
  String get groupShare => 'رابط المجموعة';

  @override
  String get notCancellable =>
      'حسب قاعدة المنظّم، لم يعد ممكنًا إلغاء هذا الحجز.';

  @override
  String payBefore(String time) {
    return 'الأماكن محجوزة حتى $time';
  }

  @override
  String payNow(String amount) {
    return 'ادفع $amount';
  }

  @override
  String get paymentMethod => 'الدفع';

  @override
  String get placesAvailable => 'أماكن متاحة';

  @override
  String placesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أماكن متبقية',
      one: 'مكان واحد متبقٍ',
    );
    return '$_temp0';
  }

  @override
  String get qrHint => 'اعرض رمز QR هذا عند الدخول. يبقى ظاهرًا دون إنترنت.';

  @override
  String get refund => 'الاسترجاع';

  @override
  String get scanAdmitted => 'الدخول';

  @override
  String get scanAlreadyUsed => 'مستعملة من قبل';

  @override
  String get scanCameraError => 'الكاميرا غير متاحة: أدخل رمز التذكرة أدناه.';

  @override
  String get scanCancelled => 'تذكرة ملغاة';

  @override
  String get scanCheck => 'تحقق';

  @override
  String get scanChoose =>
      'اختر الحصة. تُحمَّل قائمة التذاكر للمسح حتى دون إنترنت.';

  @override
  String get scanHint => 'وجّه الكاميرا نحو رمز QR أو أدخل الرمز.';

  @override
  String get scanManual => 'رمز التذكرة';

  @override
  String get scanMode => 'وضع المسح';

  @override
  String get scanNoSession => 'لا توجد حصص للمراقبة خلال 7 أيام القادمة.';

  @override
  String get scanOffline => 'دون اتصال';

  @override
  String get scanOnline => 'متزامن';

  @override
  String scanPending(int count) {
    return '$count مسح للإرسال';
  }

  @override
  String get scanSync => 'مزامنة';

  @override
  String scanSyncedAt(String date) {
    return 'آخر مزامنة: $date';
  }

  @override
  String get scanUnknown => 'تذكرة غير معروفة';

  @override
  String get scanValid => 'تذكرة صالحة';

  @override
  String scannedOn(String date) {
    return 'مُسحت في $date';
  }

  @override
  String get soldOut => 'مكتمل';

  @override
  String get soldOutWaitlist => 'مكتمل · قائمة الانتظار';

  @override
  String get ticketTitle => 'التذكرة';

  @override
  String ticketsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تذاكر',
      one: 'تذكرة واحدة',
      zero: 'لا تذكرة',
    );
    return '$_temp0';
  }

  @override
  String get ticketsEmptyPast => 'لا توجد خرجات سابقة بعد.';

  @override
  String get ticketsPast => 'السابقة';

  @override
  String get ticketsUpcoming => 'القادمة';

  @override
  String get total => 'المجموع';

  @override
  String get transferLink => 'أو أرسل رابطًا';

  @override
  String get transferName => 'اسمه (اختياري)';

  @override
  String get transferPhone => 'رقم صديقك';

  @override
  String get transferSend => 'تحويل';

  @override
  String get transferTicket => 'حوّل إلى صديق';

  @override
  String transferredFrom(String name) {
    return 'هدية من $name';
  }

  @override
  String transferredTo(String name) {
    return 'حُوّلت إلى $name';
  }

  @override
  String waitingOrganizer(String date) {
    return 'في انتظار المنظّم: الرد قبل $date.';
  }

  @override
  String get waitlistJoin => 'سجّلني في قائمة الانتظار';

  @override
  String get waitlistJoined => 'أنت في قائمة الانتظار. سنعلمك فور تحرّر مكان.';

  @override
  String get waitlistLeave => 'مغادرة';

  @override
  String get waitlistOffered => 'مكان ينتظرك: ادفعه في «تذاكري».';

  @override
  String get waitlistOn => 'أنت في قائمة الانتظار.';

  @override
  String get offlineCopy => 'دون اتصال: تذاكرك المحفوظة على الهاتف.';

  @override
  String get paymentCard => 'بطاقة الدفع';

  @override
  String get paymentFees => 'رسوم الدفع';

  @override
  String get giftCodeOptional => 'بطاقة هدية (اختياري)';

  @override
  String get giftCard => 'بطاقة هدية';

  @override
  String get downloadReceipt => 'الوصل PDF';

  @override
  String get giftCards => 'بطاقات الهدايا';

  @override
  String get giftTitle => 'أهدِ';

  @override
  String get giftTitleEm => 'خرجة';

  @override
  String get giftLead =>
      'بطاقة هدية من دورة، صالحة 12 شهرًا لكل الخرجات القابلة للحجز عبر الإنترنت. يصل الرمز لصديقك برسالة قصيرة.';

  @override
  String get myGiftCards => 'بطاقاتي';

  @override
  String get giftOffer => 'أهدِ بطاقة';

  @override
  String giftEvent(String event) {
    return 'تهدي: $event';
  }

  @override
  String get giftOther => 'مبلغ آخر';

  @override
  String get giftRecipient => 'اسم الشخص';

  @override
  String get giftRecipientRequired => 'أدخل اسم الشخص.';

  @override
  String get giftRecipientPhone => 'رقمه (يُرسل الرمز برسالة قصيرة)';

  @override
  String get giftMessage => 'كلمة صغيرة (اختياري)';

  @override
  String giftSentTo(String name) {
    return 'مهداة إلى $name';
  }

  @override
  String get giftReceived => 'مستلمة';

  @override
  String giftBalance(String amount) {
    return 'الرصيد: $amount';
  }

  @override
  String giftValidUntil(String date) {
    return 'حتى $date';
  }

  @override
  String get giftThisOuting => 'أهدِ هذه الخرجة';

  @override
  String get seatsTitle => 'اختر مقاعدك';

  @override
  String get seatsHint => 'اختر التذكرة، ثم المس مقعدًا شاغرًا في المخطط.';

  @override
  String get seatFree => 'شاغر';

  @override
  String get seatTaken => 'محجوز';

  @override
  String get seatMine => 'مقعدك';

  @override
  String seatsChosen(int count) {
    return '$count مقعد';
  }

  @override
  String get stage => 'المنصة';

  @override
  String get promoCode => 'رمز التخفيض (اختياري)';

  @override
  String get promoHint => 'يُطبّق التخفيض عند التأكيد.';

  @override
  String groupDiscount(int percent) {
    return 'عرض المجموعة (−$percent %)';
  }

  @override
  String groupOffer(int percent, int count) {
    return 'عرض المجموعة: −$percent % ابتداءً من $count تذاكر';
  }

  @override
  String get shuttle => 'النقل';

  @override
  String get organizerSpace => 'فضاء المنظّم';

  @override
  String get organizerSpaceHint =>
      'الأحداث والحجوزات والترويج والمال، على موقع دورة.';
}
