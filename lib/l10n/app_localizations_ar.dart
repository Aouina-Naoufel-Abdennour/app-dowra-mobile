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
}
