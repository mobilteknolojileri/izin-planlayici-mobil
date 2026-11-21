import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// App bar title of the about screen.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izin hakkını hesaplar, izinlerini takip eder ve köprü günlerini önerir.'**
  String get aboutDescription;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutPrivacyBody.
  ///
  /// In tr, this message translates to:
  /// **'Verilerin sadece bu telefonda saklanır, hiçbir sunucuya gönderilmez. Uygulama internete bağlanmaz. Hesap, reklam ve analitik yoktur. Uygulamanın istediği tek izin bildirim izni, o da bir hatırlatmayı açtığında sorulur.'**
  String get aboutPrivacyBody;

  /// No description provided for @aboutSourcesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mevzuat kaynakları'**
  String get aboutSourcesTitle;

  /// No description provided for @aboutSourcesBody.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplar bu kaynaklara dayanır. Kaynaklar en son 20 Kasım 2026\'da kontrol edildi.'**
  String get aboutSourcesBody;

  /// No description provided for @aboutSourceLabor.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu'**
  String get aboutSourceLabor;

  /// No description provided for @aboutSourceRegulation.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık Ücretli İzin Yönetmeliği'**
  String get aboutSourceRegulation;

  /// No description provided for @aboutSourceCivil.
  ///
  /// In tr, this message translates to:
  /// **'657 sayılı Devlet Memurları Kanunu'**
  String get aboutSourceCivil;

  /// No description provided for @aboutSourceHolidays.
  ///
  /// In tr, this message translates to:
  /// **'2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun'**
  String get aboutSourceHolidays;

  /// No description provided for @aboutOpenGuide.
  ///
  /// In tr, this message translates to:
  /// **'Mevzuat rehberini aç'**
  String get aboutOpenGuide;

  /// No description provided for @aboutLicenseTitle.
  ///
  /// In tr, this message translates to:
  /// **'Açık kaynak'**
  String get aboutLicenseTitle;

  /// No description provided for @aboutLicenseBody.
  ///
  /// In tr, this message translates to:
  /// **'İzin Planla açık kaynaklıdır ve GPL-3.0 lisansıyla dağıtılır. Kaynak kodu GitHub\'da herkese açıktır.'**
  String get aboutLicenseBody;

  /// No description provided for @aboutSourceCode.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak kodu (GitHub)'**
  String get aboutSourceCode;

  /// No description provided for @aboutLegalese.
  ///
  /// In tr, this message translates to:
  /// **'GPL-3.0 lisansıyla dağıtılır.'**
  String get aboutLegalese;

  /// No description provided for @aboutPackages.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılan paketlerin lisansları'**
  String get aboutPackages;

  /// No description provided for @aboutDisclaimerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yasal uyarı'**
  String get aboutDisclaimerTitle;

  /// No description provided for @aboutDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'İzin Planla bilgilendirme amaçlıdır, hukuki tavsiye değildir. Hesaplar mevzuat rehberindeki kaynaklara ve kaynakların son kontrol edildiği 20 Kasım 2026 tarihindeki mevzuata dayanır. Mevzuat ve yargı kararları değişebilir, uygulama hata içerebilir. Kesin bilgi için işverenine, insan kaynaklarına veya bir hukukçuya danış. Uygulama hiçbir garanti verilmeden sunulur. Kullanımından doğan sonuçlardan, yasaların izin verdiği ölçüde, geliştirici sorumlu tutulamaz (GPL-3.0 madde 15 ve 16).'**
  String get aboutDisclaimer;

  /// Large title of the bridge tab.
  ///
  /// In tr, this message translates to:
  /// **'Köprü'**
  String get bridgeTitle;

  /// Card title: how many leave days the user wants to spend.
  ///
  /// In tr, this message translates to:
  /// **'İzin bütçen'**
  String get bridgeBudgetTitle;

  /// No description provided for @bridgeBudgetRemaining.
  ///
  /// In tr, this message translates to:
  /// **'Kalan iznin {days} gün.'**
  String bridgeBudgetRemaining(double days);

  /// No description provided for @bridgeBudgetHint.
  ///
  /// In tr, this message translates to:
  /// **'Öneriler bu bütçeye göre seçilir.'**
  String get bridgeBudgetHint;

  /// No description provided for @bridgeBudgetDecrease.
  ///
  /// In tr, this message translates to:
  /// **'Bütçeyi bir gün azalt'**
  String get bridgeBudgetDecrease;

  /// No description provided for @bridgeBudgetIncrease.
  ///
  /// In tr, this message translates to:
  /// **'Bütçeyi bir gün artır'**
  String get bridgeBudgetIncrease;

  /// No description provided for @bridgePlanTitle.
  ///
  /// In tr, this message translates to:
  /// **'{year} için en iyi plan'**
  String bridgePlanTitle(int year);

  /// No description provided for @bridgePlanUnit.
  ///
  /// In tr, this message translates to:
  /// **'gün tatil'**
  String get bridgePlanUnit;

  /// No description provided for @bridgePlanCaption.
  ///
  /// In tr, this message translates to:
  /// **'Toplam {leave} gün izinle {count} ayrı tatil yaparsın.'**
  String bridgePlanCaption(double leave, int count);

  /// No description provided for @bridgePlanNone.
  ///
  /// In tr, this message translates to:
  /// **'Bu bütçeyle köprü yapılamıyor.'**
  String get bridgePlanNone;

  /// No description provided for @bridgeSortEfficiency.
  ///
  /// In tr, this message translates to:
  /// **'En verimli'**
  String get bridgeSortEfficiency;

  /// No description provided for @bridgeSortLength.
  ///
  /// In tr, this message translates to:
  /// **'En uzun'**
  String get bridgeSortLength;

  /// Sort chips of the suggestion list.
  ///
  /// In tr, this message translates to:
  /// **'Tarihe göre'**
  String get bridgeSortDate;

  /// Main sentence of a suggestion: '2 gün izinle 5 gün tatil, 20-24 Nisan'.
  ///
  /// In tr, this message translates to:
  /// **'{leave} gün izinle {total} gün tatil, {range}'**
  String bridgeSuggestionSentence(double leave, int total, String range);

  /// Card title of a suggestion without an official holiday.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonu tatili'**
  String get bridgeSuggestionWeekend;

  /// No description provided for @bridgeInPlan.
  ///
  /// In tr, this message translates to:
  /// **'En iyi planda'**
  String get bridgeInPlan;

  /// No description provided for @bridgePlanAction.
  ///
  /// In tr, this message translates to:
  /// **'Planla'**
  String get bridgePlanAction;

  /// No description provided for @bridgePlannedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Planlandı'**
  String get bridgePlannedLabel;

  /// No description provided for @bridgePlannedMessage.
  ///
  /// In tr, this message translates to:
  /// **'İzin planına eklendi.'**
  String get bridgePlannedMessage;

  /// No description provided for @bridgeFailedMessage.
  ///
  /// In tr, this message translates to:
  /// **'İzin eklenemedi. Tekrar dene.'**
  String get bridgeFailedMessage;

  /// No description provided for @bridgeEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu yıl için köprü önerisi yok.'**
  String get bridgeEmptyMessage;

  /// No description provided for @bridgeEmptyAction.
  ///
  /// In tr, this message translates to:
  /// **'Takvimi aç'**
  String get bridgeEmptyAction;

  /// No description provided for @bridgeNoProfileMessage.
  ///
  /// In tr, this message translates to:
  /// **'Köprü önerilerini görmek için önce kurulumu tamamla.'**
  String get bridgeNoProfileMessage;

  /// No description provided for @bridgeNoProfileAction.
  ///
  /// In tr, this message translates to:
  /// **'Kuruluma başla'**
  String get bridgeNoProfileAction;

  /// No description provided for @bridgeLoading.
  ///
  /// In tr, this message translates to:
  /// **'Öneriler yükleniyor'**
  String get bridgeLoading;

  /// No description provided for @bridgeError.
  ///
  /// In tr, this message translates to:
  /// **'Öneriler açılamadı. Biraz sonra tekrar dene.'**
  String get bridgeError;

  /// Large title of the calendar tab.
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get calendarTitle;

  /// No description provided for @calendarViewMonth.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get calendarViewMonth;

  /// Chips that switch between the month and the year view.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık'**
  String get calendarViewYear;

  /// Chip that shows the leave of every person on the calendar.
  ///
  /// In tr, this message translates to:
  /// **'Herkesi göster'**
  String get calendarEveryone;

  /// Chip that turns on range selection for a new leave.
  ///
  /// In tr, this message translates to:
  /// **'Aralık seç'**
  String get calendarRangeMode;

  /// No description provided for @calendarPreviousMonth.
  ///
  /// In tr, this message translates to:
  /// **'Önceki ay'**
  String get calendarPreviousMonth;

  /// No description provided for @calendarNextMonth.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki ay'**
  String get calendarNextMonth;

  /// No description provided for @calendarPreviousYear.
  ///
  /// In tr, this message translates to:
  /// **'Önceki yıl'**
  String get calendarPreviousYear;

  /// No description provided for @calendarNextYear.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki yıl'**
  String get calendarNextYear;

  /// No description provided for @calendarToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get calendarToday;

  /// A leave on the selected day, such as 'Yıllık izin, 6-10 Temmuz'.
  ///
  /// In tr, this message translates to:
  /// **'{type}, {range}'**
  String calendarLeaveItem(String type, String range);

  /// A leave of a named person in the everyone view.
  ///
  /// In tr, this message translates to:
  /// **'{person}: {type}, {range}'**
  String calendarPersonLeaveItem(String person, String type, String range);

  /// A bridge suggestion that contains the selected day.
  ///
  /// In tr, this message translates to:
  /// **'{leave} gün izinle {total} gün tatil, {range}'**
  String calendarBridgeItem(double leave, int total, String range);

  /// No description provided for @calendarPickDay.
  ///
  /// In tr, this message translates to:
  /// **'Ayrıntıyı görmek için bir güne dokun.'**
  String get calendarPickDay;

  /// No description provided for @calendarRangeHint.
  ///
  /// In tr, this message translates to:
  /// **'İznin ilk gününe, sonra son gününe dokun.'**
  String get calendarRangeHint;

  /// No description provided for @calendarRangePickEnd.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi iznin son gününe dokun.'**
  String get calendarRangePickEnd;

  /// No description provided for @calendarRangeSelected.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğin aralık {range}, toplam {count} gün.'**
  String calendarRangeSelected(int count, String range);

  /// No description provided for @calendarAddLeaveDay.
  ///
  /// In tr, this message translates to:
  /// **'Bu güne izin ekle'**
  String get calendarAddLeaveDay;

  /// No description provided for @calendarAddLeaveRange.
  ///
  /// In tr, this message translates to:
  /// **'Bu tarihlere izin ekle'**
  String get calendarAddLeaveRange;

  /// Part of a month summary in the year view.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün resmî tatil'**
  String calendarMonthHolidays(int count);

  /// No description provided for @calendarMonthLeaves.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün izin'**
  String calendarMonthLeaves(int count);

  /// No description provided for @calendarMonthBridges.
  ///
  /// In tr, this message translates to:
  /// **'{count} önerilen izin günü'**
  String calendarMonthBridges(int count);

  /// No description provided for @calendarMonthNothing.
  ///
  /// In tr, this message translates to:
  /// **'Tatil ve izin yok'**
  String get calendarMonthNothing;

  /// Screen reader label of a month in the year view.
  ///
  /// In tr, this message translates to:
  /// **'{month}, {summary}'**
  String calendarMonthSemantics(String month, String summary);

  /// No description provided for @calendarLoading.
  ///
  /// In tr, this message translates to:
  /// **'Takvim yükleniyor'**
  String get calendarLoading;

  /// No description provided for @calendarError.
  ///
  /// In tr, this message translates to:
  /// **'Takvim açılamadı. Biraz sonra tekrar dene.'**
  String get calendarError;

  /// App name shown by the system.
  ///
  /// In tr, this message translates to:
  /// **'İzin Planla'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa'**
  String get navHome;

  /// No description provided for @navLeaves.
  ///
  /// In tr, this message translates to:
  /// **'İzinlerim'**
  String get navLeaves;

  /// No description provided for @navCalendar.
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get navCalendar;

  /// No description provided for @navBridge.
  ///
  /// In tr, this message translates to:
  /// **'Köprü'**
  String get navBridge;

  /// Bottom navigation labels.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get navSettings;

  /// Legend label: annual leave days still available.
  ///
  /// In tr, this message translates to:
  /// **'Kalan'**
  String get coreMeaningRemaining;

  /// Legend label: leave days already taken.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılan'**
  String get coreMeaningUsed;

  /// Legend label: leave days planned for the future.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan'**
  String get coreMeaningPlanned;

  /// Legend label: full-day official holiday.
  ///
  /// In tr, this message translates to:
  /// **'Resmî tatil'**
  String get coreMeaningHoliday;

  /// Legend label: eve or 28 October, off from 13.00.
  ///
  /// In tr, this message translates to:
  /// **'Arife (yarım gün)'**
  String get coreMeaningEve;

  /// Legend label: weekly rest day or non-working Saturday.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonu'**
  String get coreMeaningWeekend;

  /// Legend label: leave day suggested by the bridge planner.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen izin'**
  String get coreMeaningBridge;

  /// Legend label: normal working day.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma günü'**
  String get coreMeaningWorkday;

  /// A number of days, for example in the balance legend.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün'**
  String coreDays(double days);

  /// Under the large remaining number in the balance ring.
  ///
  /// In tr, this message translates to:
  /// **'gün kaldı'**
  String get coreBalanceRingCenter;

  /// Screen reader text of the balance ring.
  ///
  /// In tr, this message translates to:
  /// **'Kalan {remaining} gün, kullanılan {used} gün, planlanan {planned} gün'**
  String coreBalanceRingSemantics(
    double remaining,
    double used,
    double planned,
  );

  /// Why a day in a leave range counts: a normal working day.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma günü'**
  String get coreDayReasonWorkday;

  /// Weekly rest day, not counted (4857).
  ///
  /// In tr, this message translates to:
  /// **'Hafta tatili'**
  String get coreDayReasonWeeklyRest;

  /// Full-day official holiday without a known name.
  ///
  /// In tr, this message translates to:
  /// **'Resmî tatil'**
  String get coreDayReasonHoliday;

  /// Full-day official holiday with its name.
  ///
  /// In tr, this message translates to:
  /// **'Resmî tatil: {name}'**
  String coreDayReasonHolidayNamed(String name);

  /// Non-working Saturday or other contractual rest day.
  ///
  /// In tr, this message translates to:
  /// **'Çalışmadığın gün'**
  String get coreDayReasonContractualRest;

  /// Eve or 28 October without a known name.
  ///
  /// In tr, this message translates to:
  /// **'Arife, öğleden sonra tatil'**
  String get coreDayReasonHalfDay;

  /// Eve or 28 October with its name.
  ///
  /// In tr, this message translates to:
  /// **'{name}, öğleden sonra tatil'**
  String coreDayReasonHalfDayNamed(String name);

  /// Administrative leave day of a civil servant (657).
  ///
  /// In tr, this message translates to:
  /// **'İdari izin'**
  String get coreDayReasonAdministrativeLeave;

  /// Weekend inside a civil servant's leave, counted (657).
  ///
  /// In tr, this message translates to:
  /// **'İzin içinde kalan hafta sonu'**
  String get coreDayReasonWeekendInsideLeave;

  /// Weekend or holiday at the edge of a civil servant's leave.
  ///
  /// In tr, this message translates to:
  /// **'İznin başındaki veya sonundaki tatil'**
  String get coreDayReasonTrimmedEdge;

  /// Days deducted for one day of a leave range.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün'**
  String coreDayCounted(double days);

  /// Half a day deducted for one day of a leave range.
  ///
  /// In tr, this message translates to:
  /// **'Yarım gün'**
  String get coreDayHalfCounted;

  /// The day is not deducted from the leave balance.
  ///
  /// In tr, this message translates to:
  /// **'Sayılmaz'**
  String get coreDayNotCounted;

  /// Screen reader text of one day in the breakdown list.
  ///
  /// In tr, this message translates to:
  /// **'{date}, {reason}: {value}'**
  String coreDayBreakdownSemantics(String date, String reason, String value);

  /// Screen reader text of one day in the week strip.
  ///
  /// In tr, this message translates to:
  /// **'{date}, {meaning}'**
  String coreWeekStripDaySemantics(String date, String meaning);

  /// Screen reader title of the colour legend.
  ///
  /// In tr, this message translates to:
  /// **'Renklerin anlamı'**
  String get coreLegendSemantics;

  /// Tooltip and screen reader label of the question mark button.
  ///
  /// In tr, this message translates to:
  /// **'{term} nedir?'**
  String coreInfoTipTooltip(String term);

  /// Closes a dialog.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get coreOk;

  /// Undo action after a delete or edit.
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get coreUndo;

  /// Setup progress shown in the app bar.
  ///
  /// In tr, this message translates to:
  /// **'Adım {step}/{total}'**
  String coreStepProgress(int step, int total);

  /// Screen reader text of the setup progress.
  ///
  /// In tr, this message translates to:
  /// **'Adım {step}, toplam {total} adım'**
  String coreStepProgressSemantics(int step, int total);

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'2026 için 14 gün kullandın, 4 gün planladın.'**
  String get coreGalleryBigNumberCaption;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl hesaplandı?'**
  String get coreGalleryHowCalculated;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'Arife'**
  String get coreGalleryInfoTerm;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'Bayramdan önceki gün, öğleden sonrası resmî tatildir.'**
  String get coreGalleryInfoMessage;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'Henüz izin eklemedin.'**
  String get coreGalleryEmptyMessage;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'İzin ekle'**
  String get coreGalleryAddLeave;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get coreGalleryCancel;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'İşe ne zaman başladın?'**
  String get coreGalleryStepQuestion;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'İzin hakkın bu tarihe göre hesaplanır.'**
  String get coreGalleryStepReason;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get coreGalleryNext;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'İzin silindi.'**
  String get coreGalleryUndoMessage;

  /// Debug component gallery sample.
  ///
  /// In tr, this message translates to:
  /// **'1 gün izinle 4 gün tatil, 23-26 Nisan'**
  String get coreGalleryBridgeCaption;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'İzin durumun'**
  String get coreGalleryHomeTitle;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'Kalan izin'**
  String get coreGalleryHomeRemaining;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get coreGalleryHomeDaysUnit;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'Yeni izin hakkı'**
  String get coreGalleryHomeNextAccrual;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'14 Nisan 2027\'de 14 gün eklenecek'**
  String get coreGalleryHomeNextAccrualDetail;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki tatil'**
  String get coreGalleryHomeNextHoliday;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'Yılbaşı, 1 Ocak'**
  String get coreGalleryHomeNextHolidayDetail;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'Köprü önerisi'**
  String get coreGalleryHomeBridgeTitle;

  /// Debug home screen prototype sample.
  ///
  /// In tr, this message translates to:
  /// **'1 gün izinle 6 gün tatil, 9-14 Mart'**
  String get coreGalleryHomeBridgeCaption;

  /// Tooltip of the button that opens a source link in the browser.
  ///
  /// In tr, this message translates to:
  /// **'{name} bağlantısını aç'**
  String coreOpenLink(String name);

  /// Shown when no browser could open a link, so it was copied instead.
  ///
  /// In tr, this message translates to:
  /// **'Tarayıcı açılamadı. Bağlantı kopyalandı.'**
  String get coreLinkCopied;

  /// App bar title of the explain screen.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl hesaplandı?'**
  String get explainTitle;

  /// Card title of the balance arithmetic.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın özeti'**
  String get explainSummaryTitle;

  /// Row label: annual leave days earned.
  ///
  /// In tr, this message translates to:
  /// **'Hak ettiğin'**
  String get explainEarned;

  /// Row label: annual leave days used.
  ///
  /// In tr, this message translates to:
  /// **'Kullandığın'**
  String get explainUsed;

  /// Row label: annual leave days planned.
  ///
  /// In tr, this message translates to:
  /// **'Planladığın'**
  String get explainPlanned;

  /// Row label: annual leave days remaining.
  ///
  /// In tr, this message translates to:
  /// **'Kalan'**
  String get explainRemaining;

  /// Leave used before tracking started.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı kullanmadan önce aldığın {days} gün izin, kullandığın izne dâhil.'**
  String explainUsedBeforeNote(double days);

  /// Days dropped at year end (657 art. 103).
  ///
  /// In tr, this message translates to:
  /// **'Kullanmazsan {days} gün yıl sonunda düşer.'**
  String explainExpiringNote(double days);

  /// Card title of the facts the calculation uses.
  ///
  /// In tr, this message translates to:
  /// **'Bilgilerin'**
  String get explainProfileHeader;

  /// Employment type: Labour Law 4857.
  ///
  /// In tr, this message translates to:
  /// **'İşçi, İş Kanunu'**
  String get explainEmploymentLabor;

  /// Employment type: Civil Servants Law 657.
  ///
  /// In tr, this message translates to:
  /// **'Memur, Devlet Memurları Kanunu'**
  String get explainEmploymentCivil;

  /// Start date of the job.
  ///
  /// In tr, this message translates to:
  /// **'İşe başlama: {date}'**
  String explainStartDate(String date);

  /// Prior service added to the calculation.
  ///
  /// In tr, this message translates to:
  /// **'Önceki çalışma: {years} yıl {months} ay {days} gün'**
  String explainPriorService(int years, int months, int days);

  /// Term explained by the question mark button.
  ///
  /// In tr, this message translates to:
  /// **'Önceki çalışma'**
  String get explainPriorServiceTerm;

  /// Prior service explanation for a worker.
  ///
  /// In tr, this message translates to:
  /// **'Aynı işverende daha önce çalıştığın süre. İzin hakkın bu süre de eklenerek hesaplanır.'**
  String get explainPriorServiceInfoLabor;

  /// Prior service explanation for a civil servant.
  ///
  /// In tr, this message translates to:
  /// **'Kamuda daha önce geçen hizmetin. İzin hakkın bu süre de eklenerek hesaplanır.'**
  String get explainPriorServiceInfoCivil;

  /// Section of the accrual periods.
  ///
  /// In tr, this message translates to:
  /// **'Hak edişlerin'**
  String get explainPeriodsHeader;

  /// Days earned on one accrual date.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün hak ettin'**
  String explainPeriodDays(int days);

  /// Calendar year an accrual belongs to (657).
  ///
  /// In tr, this message translates to:
  /// **'{year} yılı için'**
  String explainPeriodYear(int year);

  /// Day the unused part of an accrual is dropped (657).
  ///
  /// In tr, this message translates to:
  /// **'Kullanmazsan {date} günü düşer.'**
  String explainPeriodExpires(String date);

  /// A legal rule applied to an accrual, for example: 4857 md. 53 uygulandı.
  ///
  /// In tr, this message translates to:
  /// **'{reference} uygulandı.'**
  String explainRuleApplied(String reference);

  /// Entitlement rule laborAnniversary. 4857: right earned on each service anniversary.
  ///
  /// In tr, this message translates to:
  /// **'İşe başladığın günün {serviceYears}. yıl dönümünde bu hakkı kazandın.'**
  String explainRuleLaborAnniversary(String serviceYears);

  /// Entitlement rule laborPriorService. 4857: prior service with the same employer.
  ///
  /// In tr, this message translates to:
  /// **'Aynı işverendeki önceki {years} yıl {months} ay {days} gün çalışman eklendi. Bu yüzden {serviceStart} günü başlamış sayılırsın.'**
  String explainRuleLaborPriorService(
    String years,
    String months,
    String days,
    String serviceStart,
  );

  /// Entitlement rule laborAbsenceShift. 4857: absences moved the accrual date.
  ///
  /// In tr, this message translates to:
  /// **'Girdiğin devamsızlık yüzünden hak ediş tarihin {shiftDays} gün ileri kaydı.'**
  String explainRuleLaborAbsenceShift(String shiftDays);

  /// Entitlement rule laborContinuousService. 4857: continuous work assumed.
  ///
  /// In tr, this message translates to:
  /// **'Devamsızlık girmediğin için ara vermeden çalıştığın varsayıldı.'**
  String get explainRuleLaborContinuousService;

  /// Entitlement rule laborSeniorityUpToFive. 4857: 1 to 5 years of service.
  ///
  /// In tr, this message translates to:
  /// **'Bu iş yerinde {serviceYears} yılını doldurdun. Kıdemi 5 yıla kadar (5 dâhil) olanın izni {days} gündür.'**
  String explainRuleLaborSeniorityUpToFive(String serviceYears, String days);

  /// Entitlement rule laborSeniorityFiveToFifteen. 4857: more than 5 and less than 15 years.
  ///
  /// In tr, this message translates to:
  /// **'Bu iş yerinde {serviceYears} yılını doldurdun. Kıdemi 5 yıldan fazla, 15 yıldan az olanın izni {days} gündür.'**
  String explainRuleLaborSeniorityFiveToFifteen(
    String serviceYears,
    String days,
  );

  /// Entitlement rule laborSeniorityFifteenOrMore. 4857: 15 years or more.
  ///
  /// In tr, this message translates to:
  /// **'Bu iş yerinde {serviceYears} yılını doldurdun. Kıdemi 15 yıl ve daha fazla olanın izni {days} gündür.'**
  String explainRuleLaborSeniorityFifteenOrMore(
    String serviceYears,
    String days,
  );

  /// Entitlement rule laborAgeEighteenOrYounger. 4857: age minimum for 18 or younger.
  ///
  /// In tr, this message translates to:
  /// **'Hak ediş gününde {age} yaşındaydın. Yaşı 18 veya altında olanın izni en az {days} gündür.'**
  String explainRuleLaborAgeEighteenOrYounger(String age, String days);

  /// Entitlement rule laborAgeFiftyOrOlder. 4857: age minimum for 50 or older.
  ///
  /// In tr, this message translates to:
  /// **'Hak ediş gününde {age} yaşındaydın. Yaşı 50 veya üstünde olanın izni en az {days} gündür.'**
  String explainRuleLaborAgeFiftyOrOlder(String age, String days);

  /// Entitlement rule laborUnderground. 4857: underground work adds days.
  ///
  /// In tr, this message translates to:
  /// **'Yer altı işinde çalıştığın için {extraDays} gün eklendi.'**
  String explainRuleLaborUnderground(String extraDays);

  /// Entitlement rule laborContractExtra. 4857: extra days from a contract.
  ///
  /// In tr, this message translates to:
  /// **'Sözleşmen sana {extraDays} gün ek izin veriyor.'**
  String explainRuleLaborContractExtra(String extraDays);

  /// Entitlement rule laborNoExpiry. 4857: unused days never expire.
  ///
  /// In tr, this message translates to:
  /// **'Kullanmadığın izin yanmaz, sonraki yıllara geçer.'**
  String get explainRuleLaborNoExpiry;

  /// Entitlement rule civilFirstRight. 657: first right when service reaches one year.
  ///
  /// In tr, this message translates to:
  /// **'Kamudaki hizmetin {firstRightDate} günü bir yılı doldurdu. İlk izin hakkın o gün, {calendarYear} yılı için doğdu.'**
  String explainRuleCivilFirstRight(String firstRightDate, String calendarYear);

  /// Entitlement rule civilFirstRightOnDutyStart. 657: first right on the start of duty.
  ///
  /// In tr, this message translates to:
  /// **'İlk izin hakkın göreve başladığın {firstRightDate} günü doğdu, çünkü önceki hizmetin bir yılı geçiyordu. Bu hak {calendarYear} yılı için.'**
  String explainRuleCivilFirstRightOnDutyStart(
    String firstRightDate,
    String calendarYear,
  );

  /// Entitlement rule civilCalendarYear. 657: later rights on 1 January.
  ///
  /// In tr, this message translates to:
  /// **'Memurlarda izin hakkı her yıl 1 Ocak\'ta yenilenir. Bu yüzden {calendarYear} yılının izni 1 Ocak\'ta doğdu.'**
  String explainRuleCivilCalendarYear(String calendarYear);

  /// Entitlement rule civilPriorService. 657: counted prior public service.
  ///
  /// In tr, this message translates to:
  /// **'Kamudaki önceki {years} yıl {months} ay {days} gün hizmetin eklendi. Bu yüzden {serviceStart} günü başlamış sayılırsın.'**
  String explainRuleCivilPriorService(
    String years,
    String months,
    String days,
    String serviceStart,
  );

  /// Entitlement rule civilUpToTenYears. 657: 1 to 10 years of service.
  ///
  /// In tr, this message translates to:
  /// **'Hizmetin {serviceYears} yıl. Hizmeti 10 yıla kadar (10 dâhil) olanın izni {days} gündür.'**
  String explainRuleCivilUpToTenYears(String serviceYears, String days);

  /// Entitlement rule civilOverTenYears. 657: over 10 years of service.
  ///
  /// In tr, this message translates to:
  /// **'Hizmetin {serviceYears} yıl. Hizmeti 10 yıldan fazla olanın izni {days} gündür.'**
  String explainRuleCivilOverTenYears(String serviceYears, String days);

  /// Entitlement rule civilTenYearTransition. 657: 10 year transition during the year.
  ///
  /// In tr, this message translates to:
  /// **'Hizmetin {transitionDate} günü 10 yılı geçti. Bu yüzden {calendarYear} yılı için aradaki {days} gün eklendi.'**
  String explainRuleCivilTenYearTransition(
    String transitionDate,
    String calendarYear,
    String days,
  );

  /// Entitlement rule civilCarryOver. 657: unused days carry over one year.
  ///
  /// In tr, this message translates to:
  /// **'Kullanmadığın {calendarYear} izni bir yıl daha kullanılabilir. Bu izin {expiresOn} günü düşer.'**
  String explainRuleCivilCarryOver(String calendarYear, String expiresOn);

  /// Shown before the first accrual.
  ///
  /// In tr, this message translates to:
  /// **'Henüz izin hakkın doğmadı.'**
  String get explainNoPeriods;

  /// Card title of the next accrual.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki hak ediş'**
  String get explainNextHeader;

  /// When the next accrual happens and how many days it adds.
  ///
  /// In tr, this message translates to:
  /// **'{date} günü {days} gün eklenecek.'**
  String explainNextDetail(String date, int days);

  /// Card title of the assumptions of the calculation.
  ///
  /// In tr, this message translates to:
  /// **'Bilmen gerekenler'**
  String get explainNotesHeader;

  /// Assumption when no absence period is entered (4857 art. 54/2).
  ///
  /// In tr, this message translates to:
  /// **'Devamsızlık girmediğin için hesap, ara vermeden çalıştığın varsayımıyla yapıldı.'**
  String get explainNoAbsenceNote;

  /// Half day setting: half.
  ///
  /// In tr, this message translates to:
  /// **'Arife ve 28 Ekim sabahı izninden yarım gün düşer.'**
  String get explainHalfDayHalf;

  /// Half day setting: zero.
  ///
  /// In tr, this message translates to:
  /// **'Arife ve 28 Ekim sabahı izninden düşmez.'**
  String get explainHalfDayZero;

  /// Half day setting: full.
  ///
  /// In tr, this message translates to:
  /// **'Arife ve 28 Ekim sabahı izninden bir gün düşer.'**
  String get explainHalfDayFull;

  /// Why the half day setting exists.
  ///
  /// In tr, this message translates to:
  /// **'Kanun bunu açıkça yazmıyor. Bu ayarı çalışma düzeninden değiştirebilirsin.'**
  String get explainHalfDayUnclear;

  /// Saturday setting: counts as leave.
  ///
  /// In tr, this message translates to:
  /// **'Çalışmadığın cumartesiler izninden düşer. Yargıtayın güncel görüşü budur.'**
  String get explainSaturdayCounts;

  /// Saturday setting: does not count as leave.
  ///
  /// In tr, this message translates to:
  /// **'Çalışmadığın cumartesiler izninden düşmez. Sözleşmende cumartesi hafta tatili olarak yazıyorsa bu doğrudur.'**
  String get explainSaturdayNotCounted;

  /// Why a teacher has no annual leave (657 art. 103/2).
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenler yaz ve dinlenme tatillerinde izinli sayılır. Bu yüzden ayrıca yıllık izin verilmez.'**
  String get explainTeacherMessage;

  /// Empty state before the first setup.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı görmek için önce kurulumu tamamla.'**
  String get explainNoProfileMessage;

  /// Opens the setup.
  ///
  /// In tr, this message translates to:
  /// **'Kuruluma başla'**
  String get explainNoProfileAction;

  /// Shown when the data could not be loaded.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler yüklenemedi.'**
  String get explainErrorMessage;

  /// Loads the data again.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get explainRetry;

  /// Screen reader label of the loading indicator.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get explainLoading;

  /// Start of the exported leave history file name. Converted to lowercase ASCII with dashes, e.g. izin-gecmisi.
  ///
  /// In tr, this message translates to:
  /// **'İzin geçmişi'**
  String get exportLeavesFileStem;

  /// Start of the backup file name. Converted to lowercase ASCII with dashes, e.g. izin-planla-yedek.
  ///
  /// In tr, this message translates to:
  /// **'İzin Planla yedek'**
  String get exportBackupFileStem;

  /// Title of the PDF report.
  ///
  /// In tr, this message translates to:
  /// **'İzin geçmişi'**
  String get exportPdfTitle;

  /// Under the PDF title. The date is formatted as dd.MM.yyyy.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturulma tarihi: {date}'**
  String exportGeneratedOn(String date);

  /// PDF footer page number.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {page} / {total}'**
  String exportPageNumber(int page, int total);

  /// PDF section heading: profile summary.
  ///
  /// In tr, this message translates to:
  /// **'Kişi bilgileri'**
  String get exportSectionProfile;

  /// PDF section heading: earned, used, planned and remaining annual leave.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izin durumu'**
  String get exportSectionBalance;

  /// PDF section heading: annual leave earned on each accrual date.
  ///
  /// In tr, this message translates to:
  /// **'Hak edişler'**
  String get exportSectionEntitlements;

  /// PDF section heading: leave records.
  ///
  /// In tr, this message translates to:
  /// **'İzinler'**
  String get exportSectionLeaves;

  /// PDF section heading above the legal disclaimer.
  ///
  /// In tr, this message translates to:
  /// **'Yasal uyarı'**
  String get exportSectionDisclaimer;

  /// Legal disclaimer at the end of the PDF. User-facing variant of the Yasal uyarı section of the root README.md: same claims, but the sentence about docs/mevzuat.md is replaced by the laws the calculations are based on, because a PDF reader cannot open repo files.
  ///
  /// In tr, this message translates to:
  /// **'İzin Planla bilgilendirme amaçlıdır, hukuki tavsiye değildir. Hesaplar, uygulamanın bu sürümü hazırlanırken yürürlükte olan 4857 sayılı İş Kanunu\'na, 657 sayılı Devlet Memurları Kanunu\'na ve bunlara bağlı yönetmeliklere dayanır. Mevzuat ve yargı kararları değişebilir, uygulama hata içerebilir. Kesin bilgi için işverenine, insan kaynaklarına veya bir hukukçuya danış. Uygulama hiçbir garanti verilmeden sunulur. Kullanımından doğan sonuçlardan, yasaların izin verdiği ölçüde, geliştirici sorumlu tutulamaz (GPL-3.0 madde 15 ve 16).'**
  String get exportDisclaimer;

  /// Profile summary label: person's name.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get exportFieldName;

  /// Profile summary label: Labour Law 4857 or Civil Servants Law 657.
  ///
  /// In tr, this message translates to:
  /// **'Tabi olduğu kanun'**
  String get exportFieldLaw;

  /// Value of exportFieldLaw for a worker.
  ///
  /// In tr, this message translates to:
  /// **'İş Kanunu (4857)'**
  String get exportLawLabor;

  /// Value of exportFieldLaw for a civil servant.
  ///
  /// In tr, this message translates to:
  /// **'Devlet Memurları Kanunu (657)'**
  String get exportLawCivilServant;

  /// Profile summary label: hire date of a worker.
  ///
  /// In tr, this message translates to:
  /// **'İşe giriş tarihi'**
  String get exportFieldStartDateLabor;

  /// Profile summary label: start of duty of a civil servant.
  ///
  /// In tr, this message translates to:
  /// **'Göreve başlama tarihi'**
  String get exportFieldStartDateCivilServant;

  /// Profile summary label: prior service entered by the user.
  ///
  /// In tr, this message translates to:
  /// **'Önceki hizmet süresi'**
  String get exportFieldPriorService;

  /// Profile summary label: prior service plus service since the start date, up to the report date.
  ///
  /// In tr, this message translates to:
  /// **'Toplam hizmet süresi'**
  String get exportFieldTotalService;

  /// A length of service.
  ///
  /// In tr, this message translates to:
  /// **'{years} yıl {months} ay {days} gün'**
  String exportServiceDuration(int years, int months, int days);

  /// Profile summary label: absence days that shift accrual dates (4857 art. 54/2).
  ///
  /// In tr, this message translates to:
  /// **'Hak edişi kaydıran devamsızlık'**
  String get exportFieldAbsence;

  /// Profile summary label: extra leave days granted by contract or union agreement.
  ///
  /// In tr, this message translates to:
  /// **'Sözleşmeyle gelen ek gün'**
  String get exportFieldContractExtraDays;

  /// Profile summary label: the person works underground.
  ///
  /// In tr, this message translates to:
  /// **'Yer altı işi'**
  String get exportFieldUnderground;

  /// Profile summary label: the civil servant is a teacher.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen'**
  String get exportFieldTeacher;

  /// Value of a yes or no field in the profile summary.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get exportYes;

  /// Profile summary label: annual leave days used before the app started tracking.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamadan önce kullanılan izin'**
  String get exportFieldUsedBeforeTracking;

  /// Balance label: annual leave days earned.
  ///
  /// In tr, this message translates to:
  /// **'Hak edilen'**
  String get exportFieldEarned;

  /// Balance label: annual leave days used.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılan'**
  String get exportFieldUsed;

  /// Balance label: annual leave days planned for the future.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan'**
  String get exportFieldPlanned;

  /// Balance label: annual leave days still available. May be negative.
  ///
  /// In tr, this message translates to:
  /// **'Kalan'**
  String get exportFieldRemaining;

  /// Balance label: days a civil servant loses at year end if unused.
  ///
  /// In tr, this message translates to:
  /// **'Yıl sonunda düşecek'**
  String get exportFieldExpiring;

  /// Balance label: date and days of the next accrual.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki hak ediş'**
  String get exportFieldNextAccrual;

  /// Value of exportFieldNextAccrual. The date is dd.MM.yyyy, days is a formatted number.
  ///
  /// In tr, this message translates to:
  /// **'{date}, {days} gün'**
  String exportNextAccrual(String date, String days);

  /// A number of days. Days is a formatted number such as 1,5.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün'**
  String exportDays(String days);

  /// Excel summary sheet column header: label.
  ///
  /// In tr, this message translates to:
  /// **'Bilgi'**
  String get exportColumnField;

  /// Excel summary sheet column header: value.
  ///
  /// In tr, this message translates to:
  /// **'Değer'**
  String get exportColumnValue;

  /// Entitlement table column header.
  ///
  /// In tr, this message translates to:
  /// **'Hak ediş tarihi'**
  String get exportColumnAccrualDate;

  /// Entitlement table column header: calendar year of a civil servant's right.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get exportColumnYear;

  /// Entitlement table column header: days earned.
  ///
  /// In tr, this message translates to:
  /// **'Gün'**
  String get exportColumnDays;

  /// Entitlement table column header: day the unused part is dropped (657 art. 103).
  ///
  /// In tr, this message translates to:
  /// **'Kullanılmazsa düşeceği tarih'**
  String get exportColumnExpiresOn;

  /// Entitlement table column header: legal articles applied, e.g. 4857 md. 53.
  ///
  /// In tr, this message translates to:
  /// **'Dayanak'**
  String get exportColumnLegalBasis;

  /// Leave table column header: leave type.
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get exportColumnType;

  /// Leave table column header: first day.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get exportColumnStart;

  /// Leave table column header: last day.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş'**
  String get exportColumnEnd;

  /// Leave table column header: calendar days, half day or hours.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get exportColumnDuration;

  /// Leave table column header: days deducted from the annual balance.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izinden düşen gün'**
  String get exportColumnAnnualDays;

  /// Leave table column header: used or planned.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get exportColumnStatus;

  /// Leave table column header: user's note.
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get exportColumnNote;

  /// Leave duration in calendar days, both ends included.
  ///
  /// In tr, this message translates to:
  /// **'{days} takvim günü'**
  String exportDurationDays(int days);

  /// Leave duration of a half day record.
  ///
  /// In tr, this message translates to:
  /// **'Yarım gün'**
  String get exportDurationHalfDay;

  /// Leave duration of an hourly record. Hours is a formatted number such as 2,5.
  ///
  /// In tr, this message translates to:
  /// **'{hours} saat'**
  String exportDurationHours(String hours);

  /// Leave status: the leave has started or ended.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıldı'**
  String get exportStatusUsed;

  /// Leave status: the leave starts after today.
  ///
  /// In tr, this message translates to:
  /// **'Planlandı'**
  String get exportStatusPlanned;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izin'**
  String get exportLeaveTypeAnnual;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık ve rapor'**
  String get exportLeaveTypeSick;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz izin'**
  String get exportLeaveTypeUnpaid;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Doğum izni'**
  String get exportLeaveTypeMaternity;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Babalık izni'**
  String get exportLeaveTypePaternity;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Evlenme izni'**
  String get exportLeaveTypeMarriage;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Ölüm izni'**
  String get exportLeaveTypeBereavement;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Evlat edinme izni'**
  String get exportLeaveTypeAdoption;

  /// Leave type name in exports: care of a child with at least 70% disability or a chronic illness.
  ///
  /// In tr, this message translates to:
  /// **'Engelli veya kronik hasta çocuk izni'**
  String get exportLeaveTypeDisabledChildCare;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Sendika izni'**
  String get exportLeaveTypeUnion;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Mazeret izni'**
  String get exportLeaveTypeExcuse;

  /// Leave type name in exports.
  ///
  /// In tr, this message translates to:
  /// **'Yol izni'**
  String get exportLeaveTypeTravel;

  /// Leave type name in exports when the user gave no custom name.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get exportLeaveTypeOther;

  /// PDF text when the profile has no accrual yet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz hak ediş yok.'**
  String get exportNoEntitlements;

  /// PDF text when the profile has no leave record.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı izin yok.'**
  String get exportNoLeaves;

  /// Excel sheet tab name. At most 31 characters.
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get exportSheetSummary;

  /// Excel sheet tab name. At most 31 characters.
  ///
  /// In tr, this message translates to:
  /// **'Hak edişler'**
  String get exportSheetEntitlements;

  /// Excel sheet tab name. At most 31 characters.
  ///
  /// In tr, this message translates to:
  /// **'İzinler'**
  String get exportSheetLeaves;

  /// App bar title of the guide screen.
  ///
  /// In tr, this message translates to:
  /// **'Mevzuat rehberi'**
  String get guideTitle;

  /// No description provided for @guideIntro.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izin kurallarını burada sade dille bulursun. Her bölümün altında dayandığı kaynak yazar.'**
  String get guideIntro;

  /// No description provided for @guideLaborLaw.
  ///
  /// In tr, this message translates to:
  /// **'İşçi (4857)'**
  String get guideLaborLaw;

  /// Chips that choose the law the guide explains.
  ///
  /// In tr, this message translates to:
  /// **'Memur (657)'**
  String get guideCivilServant;

  /// No description provided for @guideSource.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: {source}'**
  String guideSource(String source);

  /// No description provided for @guideRightTitle.
  ///
  /// In tr, this message translates to:
  /// **'İzin hakkın ne zaman başlar?'**
  String get guideRightTitle;

  /// No description provided for @guideRightLabor.
  ///
  /// In tr, this message translates to:
  /// **'İşe başladığın günden bir yıl sonra yıllık izin hakkın doğar. Deneme süresi de bu bir yıla dâhildir. Sonraki her hak, bir önceki haktan bir yıl sonra doğar.'**
  String get guideRightLabor;

  /// No description provided for @guideRightLaborMerge.
  ///
  /// In tr, this message translates to:
  /// **'Aynı işverenin farklı iş yerlerinde çalıştığın süreler birleştirilir. Başka işverenlerde geçen süre eklenmez.'**
  String get guideRightLaborMerge;

  /// No description provided for @guideRightLaborSource.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu, madde 53 ve 54'**
  String get guideRightLaborSource;

  /// No description provided for @guideRightCivil.
  ///
  /// In tr, this message translates to:
  /// **'İlk izin hakkın hizmetin bir yılı doldurduğu gün doğar ve o yıla aittir. Sonraki haklar her yıl 1 Ocak\'ta doğar. Hak tam süredir, yılın kalanına göre azaltılmaz.'**
  String get guideRightCivil;

  /// No description provided for @guideRightCivilService.
  ///
  /// In tr, this message translates to:
  /// **'Hizmet süresine kamu kurumlarında hangi statüde olursa olsun geçen süreler, kazanılmış hak aylığında sayılan süreler ve askerlik dâhildir.'**
  String get guideRightCivilService;

  /// No description provided for @guideRightCivilSource.
  ///
  /// In tr, this message translates to:
  /// **'657 sayılı Devlet Memurları Kanunu, madde 102 ve 103'**
  String get guideRightCivilSource;

  /// No description provided for @guideDurationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaç gün izin hakkın var?'**
  String get guideDurationTitle;

  /// No description provided for @guideDurationLaborShort.
  ///
  /// In tr, this message translates to:
  /// **'1 yıldan 5 yıla kadar (5. yıl dâhil)'**
  String get guideDurationLaborShort;

  /// No description provided for @guideDurationLaborMiddle.
  ///
  /// In tr, this message translates to:
  /// **'5 yıldan fazla, 15 yıldan az'**
  String get guideDurationLaborMiddle;

  /// No description provided for @guideDurationLaborLong.
  ///
  /// In tr, this message translates to:
  /// **'15 yıl ve fazlası'**
  String get guideDurationLaborLong;

  /// No description provided for @guideDurationLaborAge.
  ///
  /// In tr, this message translates to:
  /// **'Yaşın 18 veya altında ya da 50 veya üstündeyse iznin en az 20 gündür.'**
  String get guideDurationLaborAge;

  /// No description provided for @guideDurationLaborUnderground.
  ///
  /// In tr, this message translates to:
  /// **'Yer altında çalışıyorsan her süreye 4 gün eklenir.'**
  String get guideDurationLaborUnderground;

  /// No description provided for @guideDurationLaborContract.
  ///
  /// In tr, this message translates to:
  /// **'İş sözleşmen veya toplu iş sözleşmesi bu süreleri artırabilir.'**
  String get guideDurationLaborContract;

  /// No description provided for @guideDurationLaborSource.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu, madde 53'**
  String get guideDurationLaborSource;

  /// No description provided for @guideDurationCivilShort.
  ///
  /// In tr, this message translates to:
  /// **'1 yıldan 10 yıla kadar (10. yıl dâhil)'**
  String get guideDurationCivilShort;

  /// No description provided for @guideDurationCivilLong.
  ///
  /// In tr, this message translates to:
  /// **'10 yıldan fazla'**
  String get guideDurationCivilLong;

  /// No description provided for @guideDurationCivilTeacher.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenler yaz ve dinlenme tatillerinde izinli sayılır, ayrıca yıllık izin verilmez.'**
  String get guideDurationCivilTeacher;

  /// No description provided for @guideDurationCivilSource.
  ///
  /// In tr, this message translates to:
  /// **'657 sayılı Devlet Memurları Kanunu, madde 102 ve 103'**
  String get guideDurationCivilSource;

  /// No description provided for @guideCountTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hangi günler izinden düşmez?'**
  String get guideCountTitle;

  /// No description provided for @guideCountLabor.
  ///
  /// In tr, this message translates to:
  /// **'Hafta tatili ve resmî tatiller izninden düşmez.'**
  String get guideCountLabor;

  /// No description provided for @guideCountLaborSaturday.
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi çalışmıyorsan, Yargıtayın güncel görüşüne göre cumartesi yine izninden düşer. Sözleşmende cumartesi hafta tatili olarak yazıyorsa düşmez. Bunu ayarlardan değiştirebilirsin.'**
  String get guideCountLaborSaturday;

  /// No description provided for @guideCountLaborSource.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu, madde 56. Yargıtay 9. Hukuk Dairesi, 2020'**
  String get guideCountLaborSource;

  /// No description provided for @guideCountCivil.
  ///
  /// In tr, this message translates to:
  /// **'İznin içinde kalan cumartesi ve pazar izninden düşer. Hafta içine denk gelen resmî tatiller ve idari izin günleri düşmez. İznin başındaki ve sonundaki hafta sonu sayılmaz.'**
  String get guideCountCivil;

  /// No description provided for @guideCountCivilSource.
  ///
  /// In tr, this message translates to:
  /// **'Devlet Personel Başkanlığı görüşü, 29 Nisan 2016'**
  String get guideCountCivilSource;

  /// No description provided for @guideCountExample.
  ///
  /// In tr, this message translates to:
  /// **'Örnek: 26-30 Ekim 2026 arasındaki izninden 3,5 gün düşer, çünkü 28 Ekim yarım gün sayılır, 29 Ekim hiç sayılmaz.'**
  String get guideCountExample;

  /// No description provided for @guideHalfDayTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arife ve 28 Ekim'**
  String get guideHalfDayTitle;

  /// No description provided for @guideHalfDay.
  ///
  /// In tr, this message translates to:
  /// **'Bayram arifelerinde ve 28 Ekim\'de saat 13.00\'ten sonrası resmî tatildir. Mevzuat bu günlerin izinden ne kadar düşeceğini açıkça yazmaz. Uygulama varsayılan olarak yarım gün düşer. İstersen ayarlardan değiştirebilirsin.'**
  String get guideHalfDay;

  /// No description provided for @guideHalfDaySource.
  ///
  /// In tr, this message translates to:
  /// **'2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun'**
  String get guideHalfDaySource;

  /// No description provided for @guideSplitTitle.
  ///
  /// In tr, this message translates to:
  /// **'İzni bölebilir misin?'**
  String get guideSplitTitle;

  /// No description provided for @guideSplitLabor.
  ///
  /// In tr, this message translates to:
  /// **'İşverenin iznini tek başına bölemez. İşverenle anlaşırsan izni parçalara bölebilirsin. Parçalardan biri en az 10 gün olmalı.'**
  String get guideSplitLabor;

  /// No description provided for @guideSplitLaborSource.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu, madde 56'**
  String get guideSplitLaborSource;

  /// No description provided for @guideSplitCivil.
  ///
  /// In tr, this message translates to:
  /// **'İznini tek seferde veya parça parça kullanabilirsin. En kısa parça için bir sınır yok.'**
  String get guideSplitCivil;

  /// No description provided for @guideSplitCivilSource.
  ///
  /// In tr, this message translates to:
  /// **'657 sayılı Devlet Memurları Kanunu, madde 103'**
  String get guideSplitCivilSource;

  /// No description provided for @guideUnusedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kullanmadığın izin ne olur?'**
  String get guideUnusedTitle;

  /// No description provided for @guideUnusedLabor.
  ///
  /// In tr, this message translates to:
  /// **'Kullanmadığın izin yanmaz, sonraki yıllara geçer. İşten ayrılınca kullanmadığın günlerin ücreti ödenir. İzin hakkından vazgeçemezsin.'**
  String get guideUnusedLabor;

  /// No description provided for @guideUnusedLaborSource.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu, madde 53 ve 59'**
  String get guideUnusedLaborSource;

  /// No description provided for @guideUnusedCivil.
  ///
  /// In tr, this message translates to:
  /// **'Bu yılın ve geçen yılın iznini birlikte kullanabilirsin. Daha eski yıllardan kalan izin düşer. İzin kullandığında önce geçen yıldan kalan günler düşülür.'**
  String get guideUnusedCivil;

  /// No description provided for @guideUnusedCivilSource.
  ///
  /// In tr, this message translates to:
  /// **'657 sayılı Devlet Memurları Kanunu, madde 103'**
  String get guideUnusedCivilSource;

  /// No description provided for @guideTravelTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yol izni'**
  String get guideTravelTitle;

  /// No description provided for @guideTravelLabor.
  ///
  /// In tr, this message translates to:
  /// **'İznini iş yerinin bulunduğu yerden başka bir yerde geçireceksen ve bunu belgelersen, gidiş ve dönüş için toplam 4 güne kadar ücretsiz yol izni alabilirsin.'**
  String get guideTravelLabor;

  /// No description provided for @guideTravelLaborSource.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu, madde 56'**
  String get guideTravelLaborSource;

  /// No description provided for @guideTravelCivil.
  ///
  /// In tr, this message translates to:
  /// **'İznini belediye ve köy sınırları dışında geçireceksen ve amirin uygun görürse, iznine gidiş ve dönüş için en çok ikişer gün eklenebilir. Yol izni yılda toplam 4 günü geçemez ve ertesi yıla aktarılmaz.'**
  String get guideTravelCivil;

  /// No description provided for @guideTravelCivilSource.
  ///
  /// In tr, this message translates to:
  /// **'657 sayılı Devlet Memurları Kanunu, madde 102'**
  String get guideTravelCivilSource;

  /// No description provided for @guideExcuseTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mazeret izinleri'**
  String get guideExcuseTitle;

  /// No description provided for @guideExcuseLabor.
  ///
  /// In tr, this message translates to:
  /// **'Bu izinler ücretlidir ve yıllık izninden düşmez.'**
  String get guideExcuseLabor;

  /// No description provided for @guideExcuseMarriage.
  ///
  /// In tr, this message translates to:
  /// **'Evlenme'**
  String get guideExcuseMarriage;

  /// No description provided for @guideExcuseAdoption.
  ///
  /// In tr, this message translates to:
  /// **'Evlat edinme'**
  String get guideExcuseAdoption;

  /// No description provided for @guideExcuseLaborBereavement.
  ///
  /// In tr, this message translates to:
  /// **'Anne, baba, eş, kardeş veya çocuğun ölümü'**
  String get guideExcuseLaborBereavement;

  /// No description provided for @guideExcusePaternity.
  ///
  /// In tr, this message translates to:
  /// **'Eşinin doğum yapması'**
  String get guideExcusePaternity;

  /// No description provided for @guideExcuseLaborChild.
  ///
  /// In tr, this message translates to:
  /// **'En az %70 engelli veya süreğen hastalığı olan çocuğunun tedavisi'**
  String get guideExcuseLaborChild;

  /// No description provided for @guideExcuseYearly.
  ///
  /// In tr, this message translates to:
  /// **'Yılda 10 güne kadar'**
  String get guideExcuseYearly;

  /// No description provided for @guideExcuseLaborPaternityNote.
  ///
  /// In tr, this message translates to:
  /// **'Babalık izni, 1 Mayıs 2026\'dan önceki doğumlarda 5 gündür.'**
  String get guideExcuseLaborPaternityNote;

  /// No description provided for @guideExcuseLaborSource.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu ek madde 2 ve 7578 sayılı Kanun'**
  String get guideExcuseLaborSource;

  /// No description provided for @guideExcuseCivilMarriage.
  ///
  /// In tr, this message translates to:
  /// **'Kendinin veya çocuğunun evlenmesi'**
  String get guideExcuseCivilMarriage;

  /// No description provided for @guideExcuseCivilBereavement.
  ///
  /// In tr, this message translates to:
  /// **'Eşinin, çocuğunun, kendinin veya eşinin anne, baba ve kardeşinin ölümü'**
  String get guideExcuseCivilBereavement;

  /// No description provided for @guideExcuseCivilOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer mazeretler, amirin uygun görürse'**
  String get guideExcuseCivilOther;

  /// No description provided for @guideExcuseCivilOtherValue.
  ///
  /// In tr, this message translates to:
  /// **'Yılda 10 gün'**
  String get guideExcuseCivilOtherValue;

  /// No description provided for @guideExcuseCivilChild.
  ///
  /// In tr, this message translates to:
  /// **'En az %70 engelli veya süreğen hastalığı olan çocuğunun hastalanması'**
  String get guideExcuseCivilChild;

  /// No description provided for @guideExcuseCivilMaternity.
  ///
  /// In tr, this message translates to:
  /// **'Doğum (analık)'**
  String get guideExcuseCivilMaternity;

  /// No description provided for @guideExcuseCivilMaternityValue.
  ///
  /// In tr, this message translates to:
  /// **'24 hafta'**
  String get guideExcuseCivilMaternityValue;

  /// No description provided for @guideExcuseCivil.
  ///
  /// In tr, this message translates to:
  /// **'Diğer mazeretler için zorunlu hâlde 10 gün daha verilebilir. Bu ikinci 10 gün yıllık izninden düşer. Öteki mazeret izinleri yıllık izninden düşmez.'**
  String get guideExcuseCivil;

  /// No description provided for @guideExcuseCivilSource.
  ///
  /// In tr, this message translates to:
  /// **'657 sayılı Devlet Memurları Kanunu, madde 104'**
  String get guideExcuseCivilSource;

  /// No description provided for @guideHolidaysTitle.
  ///
  /// In tr, this message translates to:
  /// **'Resmî tatiller'**
  String get guideHolidaysTitle;

  /// No description provided for @guideHolidayNewYear.
  ///
  /// In tr, this message translates to:
  /// **'1 Ocak, Yılbaşı'**
  String get guideHolidayNewYear;

  /// No description provided for @guideHolidayApril.
  ///
  /// In tr, this message translates to:
  /// **'23 Nisan, Ulusal Egemenlik ve Çocuk Bayramı'**
  String get guideHolidayApril;

  /// No description provided for @guideHolidayLabour.
  ///
  /// In tr, this message translates to:
  /// **'1 Mayıs, Emek ve Dayanışma Günü'**
  String get guideHolidayLabour;

  /// No description provided for @guideHolidayYouth.
  ///
  /// In tr, this message translates to:
  /// **'19 Mayıs, Atatürk\'ü Anma, Gençlik ve Spor Bayramı'**
  String get guideHolidayYouth;

  /// No description provided for @guideHolidayDemocracy.
  ///
  /// In tr, this message translates to:
  /// **'15 Temmuz, Demokrasi ve Millî Birlik Günü'**
  String get guideHolidayDemocracy;

  /// No description provided for @guideHolidayVictory.
  ///
  /// In tr, this message translates to:
  /// **'30 Ağustos, Zafer Bayramı'**
  String get guideHolidayVictory;

  /// No description provided for @guideHolidayRepublicEve.
  ///
  /// In tr, this message translates to:
  /// **'28 Ekim, saat 13.00\'ten sonra'**
  String get guideHolidayRepublicEve;

  /// No description provided for @guideHolidayRepublic.
  ///
  /// In tr, this message translates to:
  /// **'29 Ekim, Cumhuriyet Bayramı'**
  String get guideHolidayRepublic;

  /// No description provided for @guideHolidayRamadan.
  ///
  /// In tr, this message translates to:
  /// **'Ramazan Bayramı, arifenin öğleden sonrası ve 3 gün'**
  String get guideHolidayRamadan;

  /// No description provided for @guideHolidaySacrifice.
  ///
  /// In tr, this message translates to:
  /// **'Kurban Bayramı, arifenin öğleden sonrası ve 4 gün'**
  String get guideHolidaySacrifice;

  /// No description provided for @guideHolidaysNote.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonuna denk gelen tatil için yerine başka gün verilmez.'**
  String get guideHolidaysNote;

  /// No description provided for @guideHolidaysSource.
  ///
  /// In tr, this message translates to:
  /// **'2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun'**
  String get guideHolidaysSource;

  /// No description provided for @guideSourcesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaynaklar'**
  String get guideSourcesTitle;

  /// No description provided for @guideSourcesChecked.
  ///
  /// In tr, this message translates to:
  /// **'Kaynaklar en son 20 Kasım 2026\'da kontrol edildi.'**
  String get guideSourcesChecked;

  /// No description provided for @guideSourceLabor.
  ///
  /// In tr, this message translates to:
  /// **'4857 sayılı İş Kanunu'**
  String get guideSourceLabor;

  /// No description provided for @guideSourceRegulation.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık Ücretli İzin Yönetmeliği'**
  String get guideSourceRegulation;

  /// No description provided for @guideSourceCivil.
  ///
  /// In tr, this message translates to:
  /// **'657 sayılı Devlet Memurları Kanunu'**
  String get guideSourceCivil;

  /// No description provided for @guideSourceHolidays.
  ///
  /// In tr, this message translates to:
  /// **'2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun'**
  String get guideSourceHolidays;

  /// No description provided for @guideSourcePaternity.
  ///
  /// In tr, this message translates to:
  /// **'7578 sayılı Kanun'**
  String get guideSourcePaternity;

  /// No description provided for @guideSourceDiyanet.
  ///
  /// In tr, this message translates to:
  /// **'Diyanet İşleri Başkanlığı, dinî günler'**
  String get guideSourceDiyanet;

  /// No description provided for @guideDisclaimerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yasal uyarı'**
  String get guideDisclaimerTitle;

  /// No description provided for @guideDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'İzin Planla bilgilendirme amaçlıdır, hukuki tavsiye değildir. Hesaplar bu rehberdeki kaynaklara ve kaynakların son kontrol edildiği 20 Kasım 2026 tarihindeki mevzuata dayanır. Mevzuat ve yargı kararları değişebilir, uygulama hata içerebilir. Kesin bilgi için işverenine, insan kaynaklarına veya bir hukukçuya danış. Uygulama hiçbir garanti verilmeden sunulur. Kullanımından doğan sonuçlardan, yasaların izin verdiği ölçüde, geliştirici sorumlu tutulamaz (GPL-3.0 madde 15 ve 16).'**
  String get guideDisclaimer;

  /// No description provided for @guideLoading.
  ///
  /// In tr, this message translates to:
  /// **'Rehber yükleniyor'**
  String get guideLoading;

  /// Large title of the home tab.
  ///
  /// In tr, this message translates to:
  /// **'İzin durumun'**
  String get homeTitle;

  /// Title of the hero card with the remaining annual leave.
  ///
  /// In tr, this message translates to:
  /// **'Kalan izin'**
  String get homeRemainingTitle;

  /// Word after the large remaining number.
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get homeDaysUnit;

  /// Sentence under the remaining number.
  ///
  /// In tr, this message translates to:
  /// **'Toplam {earned} gün hak ettin, {used} gün kullandın, {planned} gün planladın.'**
  String homeRemainingCaption(double earned, double used, double planned);

  /// Sentence under the remaining number when the balance is negative.
  ///
  /// In tr, this message translates to:
  /// **'Hakkından {days} gün fazla izin kullandın veya planladın.'**
  String homeOverdrawnCaption(double days);

  /// Opens the calculation explanation screen.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl hesaplandı?'**
  String get homeHowCalculated;

  /// Main button of the home screen.
  ///
  /// In tr, this message translates to:
  /// **'İzin ekle'**
  String get homeAddLeave;

  /// Card title: days until the next annual leave accrual.
  ///
  /// In tr, this message translates to:
  /// **'Yeni izin hakkı'**
  String get homeNextAccrualTitle;

  /// Words under a countdown number.
  ///
  /// In tr, this message translates to:
  /// **'gün kaldı'**
  String get homeDaysLeftUnit;

  /// When the next accrual happens and how many days it adds.
  ///
  /// In tr, this message translates to:
  /// **'{date} günü {days} gün eklenecek.'**
  String homeNextAccrualDetail(String date, int days);

  /// Card title: days until the next official holiday.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki tatil'**
  String get homeNextHolidayTitle;

  /// Name and date of the next official holiday.
  ///
  /// In tr, this message translates to:
  /// **'{name}, {date}'**
  String homeNextHolidayDetail(String name, String date);

  /// Card title of the best bridge suggestion.
  ///
  /// In tr, this message translates to:
  /// **'Köprü önerisi'**
  String get homeBridgeTitle;

  /// One sentence about a bridge suggestion, for example: 2 gün izinle 5 gün tatil, 20-24 Nisan 2026.
  ///
  /// In tr, this message translates to:
  /// **'{leaveDays} gün izinle {totalDays} gün tatil, {dates}'**
  String homeBridgeCaption(double leaveDays, int totalDays, String dates);

  /// Link to the statistics screen.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler'**
  String get homeStatsLink;

  /// Link to the legislation guide.
  ///
  /// In tr, this message translates to:
  /// **'İzin kuralları'**
  String get homeGuideLink;

  /// Empty state before the first setup.
  ///
  /// In tr, this message translates to:
  /// **'İzin hakkını görmek için birkaç soruyu cevapla.'**
  String get homeNoProfileMessage;

  /// Opens the setup.
  ///
  /// In tr, this message translates to:
  /// **'Kuruluma başla'**
  String get homeNoProfileAction;

  /// Card title for a teacher, who gets no annual leave.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izin hesabı yok'**
  String get homeTeacherTitle;

  /// Why a teacher has no annual leave balance (657 art. 103/2).
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenler yaz ve dinlenme tatillerinde izinli sayılır. Bu yüzden ayrıca yıllık izin verilmez.'**
  String get homeTeacherMessage;

  /// Shown when the data could not be loaded.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler yüklenemedi.'**
  String get homeErrorMessage;

  /// Loads the data again.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get homeRetry;

  /// Screen reader label of the loading indicator.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get homeLoading;

  /// Home screen widget, under the large number of remaining annual leave days, for example 18.
  ///
  /// In tr, this message translates to:
  /// **'gün izin hakkın kaldı'**
  String get homeWidgetRemainingCaption;

  /// Home screen widget, under the large number when the balance is negative. The number is shown without a minus sign.
  ///
  /// In tr, this message translates to:
  /// **'gün fazla izin aldın'**
  String get homeWidgetOverdrawnCaption;

  /// Screen reader text of the widget balance.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün izin hakkın kaldı'**
  String homeWidgetRemainingSentence(String days);

  /// Screen reader text of the widget balance when it is negative. The number has no minus sign.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün fazla izin aldın'**
  String homeWidgetOverdrawnSentence(String days);

  /// Home screen widget, the official holiday is today.
  ///
  /// In tr, this message translates to:
  /// **'Bugün resmî tatil: {name}'**
  String homeWidgetHolidayToday(String name);

  /// Home screen widget, the next official holiday is tomorrow.
  ///
  /// In tr, this message translates to:
  /// **'Yarın resmî tatil: {name}'**
  String homeWidgetHolidayTomorrow(String name);

  /// Home screen widget, days until the next official holiday.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün sonra resmî tatil: {name}'**
  String homeWidgetHolidayInDays(String days, String name);

  /// Home screen widget, the bundled holiday list has no later holiday.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki resmî tatil bilgisi yok'**
  String get homeWidgetNoHoliday;

  /// Home screen widget before the first setup is finished.
  ///
  /// In tr, this message translates to:
  /// **'İzin hakkını görmek için uygulamayı aç'**
  String get homeWidgetSetup;

  /// Home screen widget for a teacher, who gets no annual leave (657 art. 103/2).
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenlere yıllık izin verilmez'**
  String get homeWidgetTeacher;

  /// Home screen widget when the app has not been opened for a long time and the saved days ran out.
  ///
  /// In tr, this message translates to:
  /// **'Güncel bilgi için uygulamayı aç'**
  String get homeWidgetStale;

  /// Screen reader text of the whole widget: the balance sentence, then the holiday line.
  ///
  /// In tr, this message translates to:
  /// **'{balance}. {holiday}'**
  String homeWidgetDescription(String balance, String holiday);

  /// App bar title of the leave form for a new leave.
  ///
  /// In tr, this message translates to:
  /// **'İzin ekle'**
  String get leaveFormTitle;

  /// App bar title of the leave form for an existing leave.
  ///
  /// In tr, this message translates to:
  /// **'İzni düzenle'**
  String get leaveFormEditTitle;

  /// Field that opens the leave type list.
  ///
  /// In tr, this message translates to:
  /// **'İzin türü'**
  String get leaveFormTypeLabel;

  /// Leave type.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izin'**
  String get leaveFormTypeAnnual;

  /// Leave type.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık ve rapor'**
  String get leaveFormTypeSick;

  /// Leave type.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz izin'**
  String get leaveFormTypeUnpaid;

  /// Leave type: maternity.
  ///
  /// In tr, this message translates to:
  /// **'Doğum izni'**
  String get leaveFormTypeMaternity;

  /// Leave type.
  ///
  /// In tr, this message translates to:
  /// **'Babalık izni'**
  String get leaveFormTypePaternity;

  /// Leave type.
  ///
  /// In tr, this message translates to:
  /// **'Evlenme izni'**
  String get leaveFormTypeMarriage;

  /// Leave type: bereavement.
  ///
  /// In tr, this message translates to:
  /// **'Ölüm izni'**
  String get leaveFormTypeBereavement;

  /// Leave type.
  ///
  /// In tr, this message translates to:
  /// **'Evlat edinme izni'**
  String get leaveFormTypeAdoption;

  /// Leave type: care of a child with a disability or chronic illness.
  ///
  /// In tr, this message translates to:
  /// **'Engelli veya kronik hasta çocuk izni'**
  String get leaveFormTypeDisabledChildCare;

  /// Leave type.
  ///
  /// In tr, this message translates to:
  /// **'Sendika izni'**
  String get leaveFormTypeUnion;

  /// Leave type.
  ///
  /// In tr, this message translates to:
  /// **'Mazeret izni'**
  String get leaveFormTypeExcuse;

  /// Leave type: travel days added to annual leave.
  ///
  /// In tr, this message translates to:
  /// **'Yol izni'**
  String get leaveFormTypeTravel;

  /// Leave type named by the user.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get leaveFormTypeOther;

  /// Name field for the other leave type.
  ///
  /// In tr, this message translates to:
  /// **'İznin adı'**
  String get leaveFormCustomNameLabel;

  /// Error when the other leave type has no name.
  ///
  /// In tr, this message translates to:
  /// **'İzne bir ad ver.'**
  String get leaveFormCustomNameError;

  /// Title of the full day, half day or hourly choice.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get leaveFormUnitLabel;

  /// Leave measured in whole days.
  ///
  /// In tr, this message translates to:
  /// **'Tam gün'**
  String get leaveFormUnitDays;

  /// Leave of half a day.
  ///
  /// In tr, this message translates to:
  /// **'Yarım gün'**
  String get leaveFormUnitHalfDay;

  /// Leave measured in hours.
  ///
  /// In tr, this message translates to:
  /// **'Saatlik'**
  String get leaveFormUnitHours;

  /// First day of the leave.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get leaveFormStartLabel;

  /// Last day of the leave.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş'**
  String get leaveFormEndLabel;

  /// The day of a half day or hourly leave.
  ///
  /// In tr, this message translates to:
  /// **'Gün'**
  String get leaveFormDayLabel;

  /// Error when no date is chosen.
  ///
  /// In tr, this message translates to:
  /// **'Tarihi seç.'**
  String get leaveFormDateError;

  /// Hours field of an hourly leave.
  ///
  /// In tr, this message translates to:
  /// **'Kaç saat?'**
  String get leaveFormHoursLabel;

  /// Error when the hours are missing or not a number.
  ///
  /// In tr, this message translates to:
  /// **'Saati yaz, örneğin 2 veya 1,5.'**
  String get leaveFormHoursError;

  /// Error when the hours exceed one working day.
  ///
  /// In tr, this message translates to:
  /// **'Günlük çalışma saatin {hours}. Daha uzun izin için tam gün seç.'**
  String leaveFormHoursTooMany(double hours);

  /// Note for half day and hourly leave.
  ///
  /// In tr, this message translates to:
  /// **'Kanunda yarım gün ve saatlik izin yok. Bu kayıt iş yerinin uygulamasına göre tutulur.'**
  String get leaveFormWorkplaceNote;

  /// Birth date of the child for paternity leave.
  ///
  /// In tr, this message translates to:
  /// **'Çocuğun doğum tarihi'**
  String get leaveFormEventDateLabel;

  /// Legal number of days for an excuse leave type.
  ///
  /// In tr, this message translates to:
  /// **'Kanuna göre bu izin {days} gün.'**
  String leaveFormSuggestion(int days);

  /// Switch for the second excuse block of a civil servant.
  ///
  /// In tr, this message translates to:
  /// **'Yılın ikinci 10 günlük mazeret izni'**
  String get leaveFormSecondExcuseLabel;

  /// Term explained by the question mark button.
  ///
  /// In tr, this message translates to:
  /// **'İkinci mazeret izni'**
  String get leaveFormSecondExcuseTerm;

  /// One sentence explanation of the second excuse block (657 art. 104/C).
  ///
  /// In tr, this message translates to:
  /// **'Memurlar yılda 10 gün mazeret izni alabilir. Zorunlu durumda verilen ikinci 10 gün yıllık izinden düşülür.'**
  String get leaveFormSecondExcuseInfo;

  /// Note field.
  ///
  /// In tr, this message translates to:
  /// **'Not (isteğe bağlı)'**
  String get leaveFormNoteLabel;

  /// Card title of the live day count.
  ///
  /// In tr, this message translates to:
  /// **'İzninden düşülecek'**
  String get leaveFormDeductTitle;

  /// Live day count of the chosen range.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izninden {days} gün düşülecek.'**
  String leaveFormDeductDays(double days);

  /// Live day count of a half day leave.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izninden yarım gün düşülecek.'**
  String get leaveFormDeductHalfDay;

  /// Live count of an hourly leave.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izninden {hours} saat düşülecek.'**
  String leaveFormDeductHours(double hours);

  /// Balance after the leave.
  ///
  /// In tr, this message translates to:
  /// **'Bu izinden sonra {days} gün iznin kalır.'**
  String leaveFormRemainingAfter(double days);

  /// Shown for leave types that do not reduce the balance.
  ///
  /// In tr, this message translates to:
  /// **'Bu izin yıllık izninden düşmez.'**
  String get leaveFormNotDeducted;

  /// Shown before a date is chosen.
  ///
  /// In tr, this message translates to:
  /// **'Tarihi seçince kaç gün düşüleceğini burada görürsün.'**
  String get leaveFormPickDatesHint;

  /// Card title of the day by day breakdown.
  ///
  /// In tr, this message translates to:
  /// **'Gün gün döküm'**
  String get leaveFormBreakdownTitle;

  /// Card title of the warnings.
  ///
  /// In tr, this message translates to:
  /// **'Dikkat'**
  String get leaveFormWarningTitle;

  /// Warning when the leave exceeds the remaining balance.
  ///
  /// In tr, this message translates to:
  /// **'Bu izinle iznin {days} gün eksiye düşer. Yine de kaydedebilirsin.'**
  String leaveFormBalanceWarning(double days);

  /// Split rule warning (4857 art. 56).
  ///
  /// In tr, this message translates to:
  /// **'Yıllık izni bölerek kullanıyorsan parçalardan biri en az 10 gün olmalı.'**
  String get leaveFormSplitWarning;

  /// Travel leave limit warning.
  ///
  /// In tr, this message translates to:
  /// **'Yol izni bu dönemde toplam 4 günü geçemez.'**
  String get leaveFormTravelWarning;

  /// Main button of the leave form.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get leaveFormSave;

  /// Tooltip of the delete button in the app bar.
  ///
  /// In tr, this message translates to:
  /// **'İzni sil'**
  String get leaveFormDeleteTooltip;

  /// Message after a leave is deleted.
  ///
  /// In tr, this message translates to:
  /// **'İzin silindi.'**
  String get leaveFormDeleted;

  /// Message after a leave is edited.
  ///
  /// In tr, this message translates to:
  /// **'İzin güncellendi.'**
  String get leaveFormUpdated;

  /// Shown when saving fails.
  ///
  /// In tr, this message translates to:
  /// **'İzin kaydedilemedi. Tekrar dene.'**
  String get leaveFormSaveError;

  /// Empty state before the first setup.
  ///
  /// In tr, this message translates to:
  /// **'İzin eklemek için önce kurulumu tamamla.'**
  String get leaveFormNoProfileMessage;

  /// Opens the setup.
  ///
  /// In tr, this message translates to:
  /// **'Kuruluma başla'**
  String get leaveFormNoProfileAction;

  /// Shown when the data could not be loaded.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler yüklenemedi.'**
  String get leaveFormErrorMessage;

  /// Loads the data again.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get leaveFormRetry;

  /// Screen reader label of the loading indicator.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get leaveFormLoading;

  /// Large title of the leaves tab.
  ///
  /// In tr, this message translates to:
  /// **'İzinlerim'**
  String get leavesTitle;

  /// Section switch: leave records.
  ///
  /// In tr, this message translates to:
  /// **'İzinler'**
  String get leavesTabLeaves;

  /// Section switch: hourly leave and overtime.
  ///
  /// In tr, this message translates to:
  /// **'Saat ve mesai'**
  String get leavesTabHours;

  /// Button that opens the year filter.
  ///
  /// In tr, this message translates to:
  /// **'Yıl: {year}'**
  String leavesYearFilter(int year);

  /// Button that opens the leave type filter.
  ///
  /// In tr, this message translates to:
  /// **'Tür: {type}'**
  String leavesTypeFilter(String type);

  /// Type filter value: every leave type.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get leavesTypeAll;

  /// Title of the year filter sheet.
  ///
  /// In tr, this message translates to:
  /// **'Yıl seç'**
  String get leavesYearSheetTitle;

  /// Title of the type filter sheet.
  ///
  /// In tr, this message translates to:
  /// **'İzin türü seç'**
  String get leavesTypeSheetTitle;

  /// Section of leaves that start after today.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan'**
  String get leavesPlannedHeader;

  /// Section of leaves already started or taken.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılan'**
  String get leavesUsedHeader;

  /// Length of a leave that does not reduce the annual balance.
  ///
  /// In tr, this message translates to:
  /// **'{days} takvim günü'**
  String leavesCalendarDays(int days);

  /// A number of hours.
  ///
  /// In tr, this message translates to:
  /// **'{hours} saat'**
  String leavesHours(double hours);

  /// Empty state of the leaves tab.
  ///
  /// In tr, this message translates to:
  /// **'Henüz izin eklemedin.'**
  String get leavesEmptyMessage;

  /// Main button of the leaves section.
  ///
  /// In tr, this message translates to:
  /// **'İzin ekle'**
  String get leavesAdd;

  /// Shown when the filters hide every leave.
  ///
  /// In tr, this message translates to:
  /// **'Bu seçime uyan izin yok.'**
  String get leavesNoMatch;

  /// Card title: overtime hours in the chosen year.
  ///
  /// In tr, this message translates to:
  /// **'Fazla mesai'**
  String get leavesOvertimeTitle;

  /// Card title: hourly leave in the chosen year.
  ///
  /// In tr, this message translates to:
  /// **'Saatlik izin'**
  String get leavesHourlyTitle;

  /// Word under an hour total.
  ///
  /// In tr, this message translates to:
  /// **'saat'**
  String get leavesHourUnit;

  /// Section of overtime records.
  ///
  /// In tr, this message translates to:
  /// **'Fazla mesai kayıtları'**
  String get leavesOvertimeHeader;

  /// Section of hourly leave records.
  ///
  /// In tr, this message translates to:
  /// **'Saatlik izinler'**
  String get leavesHourlyHeader;

  /// Shown when the hours section has no record in the chosen year.
  ///
  /// In tr, this message translates to:
  /// **'Bu yıl için fazla mesai veya saatlik izin kaydın yok.'**
  String get leavesHoursEmpty;

  /// Main button of the hours section.
  ///
  /// In tr, this message translates to:
  /// **'Fazla mesai ekle'**
  String get leavesAddOvertime;

  /// Title of the overtime form.
  ///
  /// In tr, this message translates to:
  /// **'Fazla mesai'**
  String get leavesOvertimeSheetTitle;

  /// Date field of the overtime form.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get leavesOvertimeDate;

  /// Hours field of the overtime form.
  ///
  /// In tr, this message translates to:
  /// **'Kaç saat?'**
  String get leavesOvertimeHoursLabel;

  /// Error when the hours are missing or not a number.
  ///
  /// In tr, this message translates to:
  /// **'Saati yaz, örneğin 2 veya 1,5.'**
  String get leavesOvertimeHoursError;

  /// Note field of the overtime form.
  ///
  /// In tr, this message translates to:
  /// **'Not (isteğe bağlı)'**
  String get leavesOvertimeNote;

  /// Saves the overtime record.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get leavesSave;

  /// Deletes the overtime record.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get leavesDelete;

  /// Message after an overtime record is deleted.
  ///
  /// In tr, this message translates to:
  /// **'Fazla mesai kaydı silindi.'**
  String get leavesOvertimeDeleted;

  /// Empty state before the first setup.
  ///
  /// In tr, this message translates to:
  /// **'İzinlerini görmek için önce kurulumu tamamla.'**
  String get leavesNoProfileMessage;

  /// Opens the setup.
  ///
  /// In tr, this message translates to:
  /// **'Kuruluma başla'**
  String get leavesNoProfileAction;

  /// Shown when the data could not be loaded.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler yüklenemedi.'**
  String get leavesErrorMessage;

  /// Loads the data again.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get leavesRetry;

  /// Screen reader label of the loading indicator.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get leavesLoading;

  /// Android notification channel name, shown in the system notification settings.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar'**
  String get notificationsChannelName;

  /// Android notification channel description, shown in the system notification settings.
  ///
  /// In tr, this message translates to:
  /// **'Resmî tatil, köprü, hak ediş ve izin hatırlatmaları'**
  String get notificationsChannelDescription;

  /// Notification title: an official holiday is coming.
  ///
  /// In tr, this message translates to:
  /// **'Resmî tatil yaklaşıyor'**
  String get notificationsHolidayTitle;

  /// Notification body: which holiday and how many days are left.
  ///
  /// In tr, this message translates to:
  /// **'{days, plural, =0{Bugün {holiday}.} =1{Yarın {holiday}.} other{{holiday} için {days} gün kaldı.}}'**
  String notificationsHolidayBody(int days, String holiday);

  /// Notification title: a few leave days turn the coming holiday into a long break.
  ///
  /// In tr, this message translates to:
  /// **'Köprü fırsatı'**
  String get notificationsBridgeTitle;

  /// Notification body: the coming holiday, the leave days to take and the length of the whole break.
  ///
  /// In tr, this message translates to:
  /// **'{days, plural, =0{Bugün {holiday}.} =1{Yarın {holiday}.} other{{holiday} için {days} gün kaldı.}} Bu tatile {leaveDays} gün izin eklersen toplam {totalDays} gün tatil yaparsın.'**
  String notificationsBridgeBody(
    int days,
    String holiday,
    double leaveDays,
    int totalDays,
  );

  /// Notification title: a profile earns annual leave today.
  ///
  /// In tr, this message translates to:
  /// **'Yeni izin hakkı'**
  String get notificationsAccrualTitle;

  /// Notification body: profile name and the annual leave days earned today.
  ///
  /// In tr, this message translates to:
  /// **'{name} için bugün {days} gün yıllık izin hakkı doğdu.'**
  String notificationsAccrualBody(String name, int days);

  /// Notification title: a planned leave starts soon.
  ///
  /// In tr, this message translates to:
  /// **'İzin yaklaşıyor'**
  String get notificationsLeaveStartTitle;

  /// Notification body: profile name and when the planned leave starts.
  ///
  /// In tr, this message translates to:
  /// **'{days, plural, =0{{name} için planlanan izin bugün başlıyor.} =1{{name} için planlanan izin yarın başlıyor.} other{{name} için planlanan izin {days} gün sonra başlıyor.}}'**
  String notificationsLeaveStartBody(String name, int days);

  /// Notification title: the leave is ending, sent the evening before the return day.
  ///
  /// In tr, this message translates to:
  /// **'İzin bitiyor'**
  String get notificationsLeaveReturnTitle;

  /// Notification body: the profile goes back to work tomorrow.
  ///
  /// In tr, this message translates to:
  /// **'{name} için yarın işe dönüş günü.'**
  String notificationsLeaveReturnBody(String name);

  /// Notification title for civil servants (657): unused leave is dropped on 1 January.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılmamış izin düşecek'**
  String get notificationsYearEndExpiringTitle;

  /// Notification body for civil servants (657): profile name and the days dropped on 1 January if unused.
  ///
  /// In tr, this message translates to:
  /// **'{name} için {days} gün izin yıl sonuna kadar kullanılmazsa 1 Ocak\'ta düşecek.'**
  String notificationsYearEndExpiringBody(String name, double days);

  /// Notification title for workers (4857): there is unused leave. Information only.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılmamış izin var'**
  String get notificationsYearEndUnusedTitle;

  /// Notification body for workers (4857): unused leave days, which carry over to the next year.
  ///
  /// In tr, this message translates to:
  /// **'{name} için {days} gün kullanılmamış izin var. Bu izin yıl sonunda düşmez, sonraki yıla geçer.'**
  String notificationsYearEndUnusedBody(String name, double days);

  /// Title of the test notification shown right away.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler açık'**
  String get notificationsTestTitle;

  /// Body of the test notification shown right away.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar böyle görünecek.'**
  String get notificationsTestBody;

  /// Name of the setup flow.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum'**
  String get onboardingTitle;

  /// Goes to the next setup step.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get onboardingNext;

  /// Saves the answers on the last setup step.
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get onboardingFinish;

  /// Setup step 1: employment type.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl çalışıyorsun?'**
  String get onboardingTypeQuestion;

  /// Why step 1 is asked.
  ///
  /// In tr, this message translates to:
  /// **'İzin hakkı işçide ve memurda farklı hesaplanır.'**
  String get onboardingTypeReason;

  /// Employment type option: Labour Law 4857.
  ///
  /// In tr, this message translates to:
  /// **'İşçiyim'**
  String get onboardingTypeLabor;

  /// Detail of the worker option.
  ///
  /// In tr, this message translates to:
  /// **'Özel sektörde veya kamuda işçi, İş Kanunu'**
  String get onboardingTypeLaborDetail;

  /// Employment type option: Civil Servants Law 657.
  ///
  /// In tr, this message translates to:
  /// **'Devlet memuruyum'**
  String get onboardingTypeCivil;

  /// Detail of the civil servant option.
  ///
  /// In tr, this message translates to:
  /// **'Devlet Memurları Kanunu'**
  String get onboardingTypeCivilDetail;

  /// Setup step 2 for a worker: start date.
  ///
  /// In tr, this message translates to:
  /// **'Bu iş yerinde ne zaman başladın?'**
  String get onboardingStartQuestionLabor;

  /// Setup step 2 for a civil servant: start date.
  ///
  /// In tr, this message translates to:
  /// **'Memurluğa ne zaman başladın?'**
  String get onboardingStartQuestionCivil;

  /// Why step 2 is asked, worker.
  ///
  /// In tr, this message translates to:
  /// **'İzin hakkın bu iş yerinde çalıştığın süreye göre artar.'**
  String get onboardingStartReasonLabor;

  /// Why step 2 is asked, civil servant.
  ///
  /// In tr, this message translates to:
  /// **'İzin hakkın kamuda çalıştığın süreye göre artar.'**
  String get onboardingStartReasonCivil;

  /// Start date field.
  ///
  /// In tr, this message translates to:
  /// **'İşe başlama tarihi'**
  String get onboardingStartLabel;

  /// Setup step 3: birth date.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihin ne?'**
  String get onboardingBirthQuestion;

  /// Why step 3 is asked, worker (4857 art. 53/5).
  ///
  /// In tr, this message translates to:
  /// **'Yaşın 18 veya altında ya da 50 veya üstündeyse izin hakkın en az 20 gün olur.'**
  String get onboardingBirthReasonLabor;

  /// Birth date field.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi'**
  String get onboardingBirthLabel;

  /// Setup step 4 for a worker: Saturday work.
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi çalışıyor musun?'**
  String get onboardingSaturdayQuestion;

  /// Why step 4 is asked.
  ///
  /// In tr, this message translates to:
  /// **'İzne denk gelen cumartesilerin nasıl sayılacağı buna bağlı.'**
  String get onboardingSaturdayReason;

  /// Saturday option.
  ///
  /// In tr, this message translates to:
  /// **'Evet, çalışıyorum'**
  String get onboardingSaturdayYes;

  /// Saturday option.
  ///
  /// In tr, this message translates to:
  /// **'Hayır, çalışmıyorum'**
  String get onboardingSaturdayNo;

  /// Name of the first person, the user. Can be changed on the people screen.
  ///
  /// In tr, this message translates to:
  /// **'Ben'**
  String get onboardingDefaultName;

  /// Shown when saving fails.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler kaydedilemedi. Tekrar dene.'**
  String get onboardingSaveError;

  /// App bar title of the people screen.
  ///
  /// In tr, this message translates to:
  /// **'Kişiler'**
  String get peopleTitle;

  /// Hint under the people list.
  ///
  /// In tr, this message translates to:
  /// **'Eşini veya çalışanını da ekleyip izinlerini ayrı takip edebilirsin.'**
  String get peopleHint;

  /// Explains that tapping a person makes them active.
  ///
  /// In tr, this message translates to:
  /// **'Dokunduğun kişi ana sayfada görünür.'**
  String get peopleSelectHint;

  /// Empty state of the people screen.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kimseyi eklemedin.'**
  String get peopleEmptyMessage;

  /// Main button of the people screen.
  ///
  /// In tr, this message translates to:
  /// **'Kişi ekle'**
  String get peopleAdd;

  /// Marks the active person.
  ///
  /// In tr, this message translates to:
  /// **'Seçili'**
  String get peopleSelected;

  /// Tooltip of the edit button of a person.
  ///
  /// In tr, this message translates to:
  /// **'{name} bilgilerini düzenle'**
  String peopleEditTooltip(String name);

  /// Employment type: Labour Law 4857.
  ///
  /// In tr, this message translates to:
  /// **'İşçi, İş Kanunu'**
  String get peopleLabor;

  /// Employment type: Civil Servants Law 657.
  ///
  /// In tr, this message translates to:
  /// **'Memur, Devlet Memurları Kanunu'**
  String get peopleCivil;

  /// Message after a person is deleted.
  ///
  /// In tr, this message translates to:
  /// **'{name} silindi.'**
  String peopleDeleted(String name);

  /// Shown when saving fails.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler kaydedilemedi. Tekrar dene.'**
  String get peopleSaveError;

  /// App bar title of the form for a new person.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kişi'**
  String get peopleFormNewTitle;

  /// App bar title of the form for an existing person.
  ///
  /// In tr, this message translates to:
  /// **'Kişiyi düzenle'**
  String get peopleFormEditTitle;

  /// Name field.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get peopleFormName;

  /// Error when the name is empty.
  ///
  /// In tr, this message translates to:
  /// **'Bir ad yaz.'**
  String get peopleFormNameError;

  /// Title of the employment type choice.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma şekli'**
  String get peopleFormTypeLabel;

  /// Employment type option.
  ///
  /// In tr, this message translates to:
  /// **'İşçi'**
  String get peopleTypeLaborTitle;

  /// Detail of the worker option.
  ///
  /// In tr, this message translates to:
  /// **'Özel sektörde veya kamuda işçi, İş Kanunu'**
  String get peopleTypeLaborDetail;

  /// Employment type option.
  ///
  /// In tr, this message translates to:
  /// **'Devlet memuru'**
  String get peopleTypeCivilTitle;

  /// Detail of the civil servant option.
  ///
  /// In tr, this message translates to:
  /// **'Devlet Memurları Kanunu'**
  String get peopleTypeCivilDetail;

  /// Start date field.
  ///
  /// In tr, this message translates to:
  /// **'İşe başlama tarihi'**
  String get peopleFormStart;

  /// Birth date field.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi'**
  String get peopleFormBirth;

  /// Error when no date is chosen.
  ///
  /// In tr, this message translates to:
  /// **'Tarihi seç.'**
  String get peopleFormDateError;

  /// Switch: the person works on Saturdays.
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi iş günü'**
  String get peopleFormSaturday;

  /// Main button of the person form.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get peopleFormSave;

  /// Tooltip of the delete button in the app bar.
  ///
  /// In tr, this message translates to:
  /// **'Kişiyi sil'**
  String get peopleFormDeleteTooltip;

  /// Shown in a date field before a date is chosen.
  ///
  /// In tr, this message translates to:
  /// **'Tarih seç'**
  String get peopleDatePlaceholder;

  /// Optional section with less common profile fields.
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş (isteğe bağlı)'**
  String get peopleAdvancedTitle;

  /// Prior service, entered as years, months and days.
  ///
  /// In tr, this message translates to:
  /// **'Önceki çalışma süresi'**
  String get peoplePriorServiceLabel;

  /// Prior service explanation for a worker (4857 art. 54).
  ///
  /// In tr, this message translates to:
  /// **'Aynı işverenin başka iş yerlerinde çalıştığın süre de izin hakkına eklenir. Başka işverenlerdeki süre eklenmez.'**
  String get peoplePriorServiceInfoLabor;

  /// Prior service explanation for a civil servant.
  ///
  /// In tr, this message translates to:
  /// **'Kamu kurumlarında geçen süreler ve askerlik hizmete sayılır.'**
  String get peoplePriorServiceInfoCivil;

  /// Years part of a duration.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get peopleYears;

  /// Months part of a duration.
  ///
  /// In tr, this message translates to:
  /// **'Ay'**
  String get peopleMonths;

  /// Days part of a duration.
  ///
  /// In tr, this message translates to:
  /// **'Gün'**
  String get peopleDays;

  /// Annual leave days used before the app started tracking.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamadan önce kullanılan izin (gün)'**
  String get peopleUsedBeforeLabel;

  /// Help under the leave used before tracking field: only days used from the still valid balance, deducted from today's balance.
  ///
  /// In tr, this message translates to:
  /// **'Hâlâ geçerli izin hakkından, uygulamayı kullanmaya başlamadan önce kullandığın günleri yaz. Süresi dolup düşen eski yılların iznini yazma.'**
  String get peopleUsedBeforeHelp;

  /// Extra days above the law from a contract or union agreement.
  ///
  /// In tr, this message translates to:
  /// **'Sözleşmeyle gelen ek izin (gün)'**
  String get peopleContractLabel;

  /// Switch: underground work adds days (4857).
  ///
  /// In tr, this message translates to:
  /// **'Yer altı işi, örneğin maden'**
  String get peopleUndergroundLabel;

  /// Switch: teachers get no annual leave (657).
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen'**
  String get peopleTeacherLabel;

  /// Working hours per day, for hourly leave.
  ///
  /// In tr, this message translates to:
  /// **'Günlük çalışma saati'**
  String get peopleDailyHoursLabel;

  /// Error when a number field holds no number.
  ///
  /// In tr, this message translates to:
  /// **'Sayı yaz, örneğin 4 veya 4,5.'**
  String get peopleNumberError;

  /// Shown when the data could not be loaded.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler yüklenemedi.'**
  String get peopleErrorMessage;

  /// Loads the data again.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get peopleRetry;

  /// Screen reader label of the loading indicator.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get peopleLoading;

  /// Large title of the settings tab.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsPeopleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kişiler'**
  String get settingsPeopleTitle;

  /// No description provided for @settingsPeopleSummary.
  ///
  /// In tr, this message translates to:
  /// **'{name} seçili. Toplam {count} kişi.'**
  String settingsPeopleSummary(String name, int count);

  /// No description provided for @settingsPeopleEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kişi eklemedin.'**
  String get settingsPeopleEmpty;

  /// No description provided for @settingsScheduleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma düzeni'**
  String get settingsScheduleTitle;

  /// No description provided for @settingsScheduleFor.
  ///
  /// In tr, this message translates to:
  /// **'{name} için geçerli.'**
  String settingsScheduleFor(String name);

  /// No description provided for @settingsWorkDays.
  ///
  /// In tr, this message translates to:
  /// **'Çalıştığın günler'**
  String get settingsWorkDays;

  /// No description provided for @settingsSaturdayTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalışmadığın cumartesi izinden düşsün'**
  String get settingsSaturdayTitle;

  /// No description provided for @settingsSaturdayHelp.
  ///
  /// In tr, this message translates to:
  /// **'Sözleşmende veya toplu iş sözleşmende cumartesi hafta tatili olarak yazıyorsa kapat.'**
  String get settingsSaturdayHelp;

  /// No description provided for @settingsSaturdayInfoTerm.
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi'**
  String get settingsSaturdayInfoTerm;

  /// No description provided for @settingsSaturdayInfo.
  ///
  /// In tr, this message translates to:
  /// **'Yargıtayın güncel görüşüne göre çalışmadığın cumartesi izninden düşer. Eski kararlarda ve bazı bölge mahkemelerinde düşmez.'**
  String get settingsSaturdayInfo;

  /// No description provided for @settingsHalfDayTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arife ve 28 Ekim sabahı'**
  String get settingsHalfDayTitle;

  /// No description provided for @settingsHalfDayHelp.
  ///
  /// In tr, this message translates to:
  /// **'Mevzuat bunu açıkça yazmaz. Uygulama varsayılan olarak yarım gün düşer.'**
  String get settingsHalfDayHelp;

  /// No description provided for @settingsHalfDayZero.
  ///
  /// In tr, this message translates to:
  /// **'İzinden düşmesin'**
  String get settingsHalfDayZero;

  /// No description provided for @settingsHalfDayHalf.
  ///
  /// In tr, this message translates to:
  /// **'Yarım gün düşsün'**
  String get settingsHalfDayHalf;

  /// No description provided for @settingsHalfDayFull.
  ///
  /// In tr, this message translates to:
  /// **'Tam gün düşsün'**
  String get settingsHalfDayFull;

  /// No description provided for @settingsHoursTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günlük çalışma saatin'**
  String get settingsHoursTitle;

  /// No description provided for @settingsHoursValue.
  ///
  /// In tr, this message translates to:
  /// **'{hours} saat'**
  String settingsHoursValue(double hours);

  /// No description provided for @settingsHoursHelp.
  ///
  /// In tr, this message translates to:
  /// **'Saatlik izni güne çevirmek için kullanılır.'**
  String get settingsHoursHelp;

  /// No description provided for @settingsHoursDecrease.
  ///
  /// In tr, this message translates to:
  /// **'Yarım saat azalt'**
  String get settingsHoursDecrease;

  /// No description provided for @settingsHoursIncrease.
  ///
  /// In tr, this message translates to:
  /// **'Yarım saat artır'**
  String get settingsHoursIncrease;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Telefonun ayarı'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get settingsThemeDark;

  /// No description provided for @settingsRemindersTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar'**
  String get settingsRemindersTitle;

  /// No description provided for @settingsRemindersHelp.
  ///
  /// In tr, this message translates to:
  /// **'Bir hatırlatmayı açınca bildirim izni istenir.'**
  String get settingsRemindersHelp;

  /// No description provided for @settingsReminderHoliday.
  ///
  /// In tr, this message translates to:
  /// **'Resmî tatil ve köprü'**
  String get settingsReminderHoliday;

  /// No description provided for @settingsReminderAccrual.
  ///
  /// In tr, this message translates to:
  /// **'Yeni izin hakkın doğunca'**
  String get settingsReminderAccrual;

  /// No description provided for @settingsReminderPlanned.
  ///
  /// In tr, this message translates to:
  /// **'Planladığın izinden önce'**
  String get settingsReminderPlanned;

  /// No description provided for @settingsReminderYearEnd.
  ///
  /// In tr, this message translates to:
  /// **'Yıl sonunda kullanmadığın izin'**
  String get settingsReminderYearEnd;

  /// No description provided for @settingsDaysBefore.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün önce'**
  String settingsDaysBefore(int days);

  /// No description provided for @settingsDaysBeforeDecrease.
  ///
  /// In tr, this message translates to:
  /// **'Gün sayısını azalt'**
  String get settingsDaysBeforeDecrease;

  /// No description provided for @settingsDaysBeforeIncrease.
  ///
  /// In tr, this message translates to:
  /// **'Gün sayısını artır'**
  String get settingsDaysBeforeIncrease;

  /// No description provided for @settingsPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim izni verilmedi. Telefonun ayarlarından açabilirsin.'**
  String get settingsPermissionDenied;

  /// No description provided for @settingsDataTitle.
  ///
  /// In tr, this message translates to:
  /// **'Verilerin'**
  String get settingsDataTitle;

  /// No description provided for @settingsBackup.
  ///
  /// In tr, this message translates to:
  /// **'Yedekle'**
  String get settingsBackup;

  /// No description provided for @settingsBackupHelp.
  ///
  /// In tr, this message translates to:
  /// **'Bütün verilerini tek dosya olarak paylaş.'**
  String get settingsBackupHelp;

  /// No description provided for @settingsRestore.
  ///
  /// In tr, this message translates to:
  /// **'Yedekten geri yükle'**
  String get settingsRestore;

  /// No description provided for @settingsRestoreHelp.
  ///
  /// In tr, this message translates to:
  /// **'Daha önce aldığın yedeği aç.'**
  String get settingsRestoreHelp;

  /// No description provided for @settingsRestoreConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yedek geri yüklensin mi?'**
  String get settingsRestoreConfirmTitle;

  /// No description provided for @settingsRestoreConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Şu anki bütün verilerin yedekteki verilerle değişir.'**
  String get settingsRestoreConfirmBody;

  /// No description provided for @settingsRestoreConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Geri yükle'**
  String get settingsRestoreConfirm;

  /// No description provided for @settingsRestoreDone.
  ///
  /// In tr, this message translates to:
  /// **'Yedek geri yüklendi.'**
  String get settingsRestoreDone;

  /// No description provided for @settingsExport.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktar'**
  String get settingsExport;

  /// No description provided for @settingsExportHelp.
  ///
  /// In tr, this message translates to:
  /// **'İzin geçmişini PDF, Excel veya CSV dosyası olarak al.'**
  String get settingsExportHelp;

  /// No description provided for @settingsExportPdf.
  ///
  /// In tr, this message translates to:
  /// **'PDF'**
  String get settingsExportPdf;

  /// No description provided for @settingsExportExcel.
  ///
  /// In tr, this message translates to:
  /// **'Excel'**
  String get settingsExportExcel;

  /// No description provided for @settingsExportCsv.
  ///
  /// In tr, this message translates to:
  /// **'CSV'**
  String get settingsExportCsv;

  /// No description provided for @settingsExportShare.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get settingsExportShare;

  /// No description provided for @settingsExportSave.
  ///
  /// In tr, this message translates to:
  /// **'Cihaza kaydet'**
  String get settingsExportSave;

  /// No description provided for @settingsExportSaved.
  ///
  /// In tr, this message translates to:
  /// **'Dosya kaydedildi.'**
  String get settingsExportSaved;

  /// No description provided for @settingsReset.
  ///
  /// In tr, this message translates to:
  /// **'Bütün verileri sil'**
  String get settingsReset;

  /// No description provided for @settingsResetHelp.
  ///
  /// In tr, this message translates to:
  /// **'Kişiler, izinler ve ayarlar silinir.'**
  String get settingsResetHelp;

  /// No description provided for @settingsResetConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bütün veriler silinsin mi?'**
  String get settingsResetConfirmTitle;

  /// No description provided for @settingsResetConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Kişiler, izinler ve ayarlar silinir. Hemen sonra geri alabilirsin.'**
  String get settingsResetConfirmBody;

  /// No description provided for @settingsResetConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get settingsResetConfirm;

  /// Label of the field where the user types the confirm word before all data is deleted.
  ///
  /// In tr, this message translates to:
  /// **'Onaylamak için \"sil\" yaz'**
  String get settingsResetTypeLabel;

  /// The word the user types to confirm deleting all data. Must match the word inside settingsResetTypeLabel.
  ///
  /// In tr, this message translates to:
  /// **'sil'**
  String get settingsResetWord;

  /// No description provided for @settingsResetDone.
  ///
  /// In tr, this message translates to:
  /// **'Bütün veriler silindi.'**
  String get settingsResetDone;

  /// No description provided for @settingsCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get settingsCancel;

  /// No description provided for @settingsFailed.
  ///
  /// In tr, this message translates to:
  /// **'İşlem tamamlanamadı. Tekrar dene.'**
  String get settingsFailed;

  /// No description provided for @settingsInfoTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bilgi'**
  String get settingsInfoTitle;

  /// No description provided for @settingsStats.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik'**
  String get settingsStats;

  /// No description provided for @settingsGuide.
  ///
  /// In tr, this message translates to:
  /// **'Mevzuat rehberi'**
  String get settingsGuide;

  /// No description provided for @settingsAbout.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get settingsAbout;

  /// No description provided for @settingsLoading.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar yükleniyor'**
  String get settingsLoading;

  /// No description provided for @settingsError.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar açılamadı. Biraz sonra tekrar dene.'**
  String get settingsError;

  /// No description provided for @settingsRestoreNewer.
  ///
  /// In tr, this message translates to:
  /// **'Bu yedek, uygulamanın daha yeni bir sürümüyle alınmış. Geri yüklemek için önce uygulamayı güncelle. Verilerin değişmedi.'**
  String get settingsRestoreNewer;

  /// No description provided for @settingsRestoreInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Bu dosya geçerli bir İzin Planla yedeği değil. Verilerin değişmedi.'**
  String get settingsRestoreInvalid;

  /// No description provided for @settingsWorkDaysHelp.
  ///
  /// In tr, this message translates to:
  /// **'En az bir gün seçili kalır.'**
  String get settingsWorkDaysHelp;

  /// App bar title of the stats screen.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik'**
  String get statsTitle;

  /// Person filter chip that sums every person.
  ///
  /// In tr, this message translates to:
  /// **'Herkes'**
  String get statsEveryone;

  /// No description provided for @statsDaysOffTitle.
  ///
  /// In tr, this message translates to:
  /// **'{year} yılında tatil'**
  String statsDaysOffTitle(int year);

  /// No description provided for @statsDaysOffCaption.
  ///
  /// In tr, this message translates to:
  /// **'İzin, resmî tatil ve hafta sonu birlikte.'**
  String get statsDaysOffCaption;

  /// No description provided for @statsDaysOffCaptionEveryone.
  ///
  /// In tr, this message translates to:
  /// **'Herkesin izin, resmî tatil ve hafta sonu günleri birlikte.'**
  String get statsDaysOffCaptionEveryone;

  /// No description provided for @statsDaysUnit.
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get statsDaysUnit;

  /// No description provided for @statsEarned.
  ///
  /// In tr, this message translates to:
  /// **'Hak edilen'**
  String get statsEarned;

  /// No description provided for @statsUsed.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılan'**
  String get statsUsed;

  /// No description provided for @statsByYearTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yıllara göre'**
  String get statsByYearTitle;

  /// No description provided for @statsByYearRow.
  ///
  /// In tr, this message translates to:
  /// **'{year}: hak edilen {earned} gün, kullanılan {used} gün'**
  String statsByYearRow(int year, double earned, double used);

  /// No description provided for @statsByYearChart.
  ///
  /// In tr, this message translates to:
  /// **'Yıllara göre hak edilen ve kullanılan izin grafiği. Değerler grafiğin altında yazıyor.'**
  String get statsByYearChart;

  /// No description provided for @statsByMonthTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aylara göre'**
  String get statsByMonthTitle;

  /// No description provided for @statsByMonthRow.
  ///
  /// In tr, this message translates to:
  /// **'{month}: {days} gün'**
  String statsByMonthRow(String month, double days);

  /// No description provided for @statsByMonthEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğin {year} yılında yıllık izin kullanılmadı.'**
  String statsByMonthEmpty(int year);

  /// No description provided for @statsByMonthChart.
  ///
  /// In tr, this message translates to:
  /// **'Aylara göre kullanılan yıllık izin grafiği, {year}. Değerler grafiğin altında yazıyor.'**
  String statsByMonthChart(int year);

  /// No description provided for @statsByTypeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Türlere göre'**
  String get statsByTypeTitle;

  /// No description provided for @statsByTypeRow.
  ///
  /// In tr, this message translates to:
  /// **'{type}: {days} gün'**
  String statsByTypeRow(String type, double days);

  /// No description provided for @statsByTypeEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğin {year} yılında kayıtlı izin yok.'**
  String statsByTypeEmpty(int year);

  /// No description provided for @statsEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Henüz izin eklemedin. İzin ekleyince özetini burada görürsün.'**
  String get statsEmptyMessage;

  /// No description provided for @statsEmptyAction.
  ///
  /// In tr, this message translates to:
  /// **'İzin ekle'**
  String get statsEmptyAction;

  /// No description provided for @statsNoProfileMessage.
  ///
  /// In tr, this message translates to:
  /// **'İstatistiği görmek için önce kurulumu tamamla.'**
  String get statsNoProfileMessage;

  /// No description provided for @statsNoProfileAction.
  ///
  /// In tr, this message translates to:
  /// **'Kuruluma başla'**
  String get statsNoProfileAction;

  /// No description provided for @statsLoading.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik yükleniyor'**
  String get statsLoading;

  /// No description provided for @statsError.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik açılamadı. Biraz sonra tekrar dene.'**
  String get statsError;
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
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
