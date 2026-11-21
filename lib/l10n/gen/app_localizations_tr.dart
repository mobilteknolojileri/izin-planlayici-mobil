// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String aboutVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get aboutDescription =>
      'Yıllık izin hakkını hesaplar, izinlerini takip eder ve köprü günlerini önerir.';

  @override
  String get aboutPrivacyTitle => 'Gizlilik';

  @override
  String get aboutPrivacyBody =>
      'Verilerin sadece bu telefonda saklanır, hiçbir sunucuya gönderilmez. Uygulama internete bağlanmaz. Hesap, reklam ve analitik yoktur. Uygulamanın istediği tek izin bildirim izni, o da bir hatırlatmayı açtığında sorulur.';

  @override
  String get aboutSourcesTitle => 'Mevzuat kaynakları';

  @override
  String get aboutSourcesBody =>
      'Hesaplar bu kaynaklara dayanır. Kaynaklar en son 20 Kasım 2026\'da kontrol edildi.';

  @override
  String get aboutSourceLabor => '4857 sayılı İş Kanunu';

  @override
  String get aboutSourceRegulation => 'Yıllık Ücretli İzin Yönetmeliği';

  @override
  String get aboutSourceCivil => '657 sayılı Devlet Memurları Kanunu';

  @override
  String get aboutSourceHolidays =>
      '2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun';

  @override
  String get aboutOpenGuide => 'Mevzuat rehberini aç';

  @override
  String get aboutLicenseTitle => 'Açık kaynak';

  @override
  String get aboutLicenseBody =>
      'İzin Planla açık kaynaklıdır ve GPL-3.0 lisansıyla dağıtılır. Kaynak kodu GitHub\'da herkese açıktır.';

  @override
  String get aboutSourceCode => 'Kaynak kodu (GitHub)';

  @override
  String get aboutLegalese => 'GPL-3.0 lisansıyla dağıtılır.';

  @override
  String get aboutPackages => 'Kullanılan paketlerin lisansları';

  @override
  String get aboutDisclaimerTitle => 'Yasal uyarı';

  @override
  String get aboutDisclaimer =>
      'İzin Planla bağımsız bir uygulamadır. Resmî bir uygulama değildir, hiçbir kamu kurumuyla bağlantısı yoktur. Bilgilendirme amaçlıdır, hukuki tavsiye değildir. Hesaplar mevzuat rehberindeki kaynaklara ve kaynakların son kontrol edildiği 20 Kasım 2026 tarihindeki mevzuata dayanır. Mevzuat ve yargı kararları değişebilir, uygulama hata içerebilir. Kesin bilgi için işverenine, insan kaynaklarına veya bir hukukçuya danış. Uygulama hiçbir garanti verilmeden sunulur. Kullanımından doğan sonuçlardan, yasaların izin verdiği ölçüde, geliştirici sorumlu tutulamaz (GPL-3.0 madde 15 ve 16).';

  @override
  String get aboutPrivacyPolicy => 'Gizlilik politikası';

  @override
  String get bridgeTitle => 'Köprü';

  @override
  String get bridgeBudgetTitle => 'İzin bütçen';

  @override
  String bridgeBudgetRemaining(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return 'Kalan iznin $daysString gün.';
  }

  @override
  String get bridgeBudgetHint => 'Öneriler bu bütçeye göre seçilir.';

  @override
  String get bridgeBudgetDecrease => 'Bütçeyi bir gün azalt';

  @override
  String get bridgeBudgetIncrease => 'Bütçeyi bir gün artır';

  @override
  String bridgePlanTitle(int year) {
    return '$year için en iyi plan';
  }

  @override
  String get bridgePlanUnit => 'gün tatil';

  @override
  String bridgePlanCaption(double leave, int count) {
    final intl.NumberFormat leaveNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String leaveString = leaveNumberFormat.format(leave);

    return 'Toplam $leaveString gün izinle $count ayrı tatil yaparsın.';
  }

  @override
  String get bridgePlanNone => 'Bu bütçeyle köprü yapılamıyor.';

  @override
  String get bridgeSortEfficiency => 'En verimli';

  @override
  String get bridgeSortLength => 'En uzun';

  @override
  String get bridgeSortDate => 'Tarihe göre';

  @override
  String bridgeSuggestionSentence(double leave, int total, String range) {
    final intl.NumberFormat leaveNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String leaveString = leaveNumberFormat.format(leave);

    return '$leaveString gün izinle $total gün tatil, $range';
  }

  @override
  String get bridgeSuggestionWeekend => 'Hafta sonu tatili';

  @override
  String get bridgeInPlan => 'En iyi planda';

  @override
  String get bridgePlanAction => 'Planla';

  @override
  String get bridgePlannedLabel => 'Planlandı';

  @override
  String get bridgePlannedMessage => 'İzin planına eklendi.';

  @override
  String get bridgeFailedMessage => 'İzin eklenemedi. Tekrar dene.';

  @override
  String get bridgeEmptyMessage => 'Bu yıl için köprü önerisi yok.';

  @override
  String get bridgeEmptyAction => 'Takvimi aç';

  @override
  String get bridgeNoProfileMessage =>
      'Köprü önerilerini görmek için önce kurulumu tamamla.';

  @override
  String get bridgeNoProfileAction => 'Kuruluma başla';

  @override
  String get bridgeLoading => 'Öneriler yükleniyor';

  @override
  String get bridgeError => 'Öneriler açılamadı. Biraz sonra tekrar dene.';

  @override
  String get calendarTitle => 'Takvim';

  @override
  String get calendarViewMonth => 'Aylık';

  @override
  String get calendarViewYear => 'Yıllık';

  @override
  String get calendarEveryone => 'Herkesi göster';

  @override
  String get calendarRangeMode => 'Aralık seç';

  @override
  String get calendarPreviousMonth => 'Önceki ay';

  @override
  String get calendarNextMonth => 'Sonraki ay';

  @override
  String get calendarPreviousYear => 'Önceki yıl';

  @override
  String get calendarNextYear => 'Sonraki yıl';

  @override
  String get calendarToday => 'Bugün';

  @override
  String calendarLeaveItem(String type, String range) {
    return '$type, $range';
  }

  @override
  String calendarPersonLeaveItem(String person, String type, String range) {
    return '$person: $type, $range';
  }

  @override
  String calendarBridgeItem(double leave, int total, String range) {
    final intl.NumberFormat leaveNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String leaveString = leaveNumberFormat.format(leave);

    return '$leaveString gün izinle $total gün tatil, $range';
  }

  @override
  String get calendarPickDay => 'Ayrıntıyı görmek için bir güne dokun.';

  @override
  String get calendarRangeHint => 'İznin ilk gününe, sonra son gününe dokun.';

  @override
  String get calendarRangePickEnd => 'Şimdi iznin son gününe dokun.';

  @override
  String calendarRangeSelected(int count, String range) {
    return 'Seçtiğin aralık $range, toplam $count gün.';
  }

  @override
  String get calendarAddLeaveDay => 'Bu güne izin ekle';

  @override
  String get calendarAddLeaveRange => 'Bu tarihlere izin ekle';

  @override
  String calendarMonthHolidays(int count) {
    return '$count gün resmî tatil';
  }

  @override
  String calendarMonthLeaves(int count) {
    return '$count gün izin';
  }

  @override
  String calendarMonthBridges(int count) {
    return '$count önerilen izin günü';
  }

  @override
  String get calendarMonthNothing => 'Tatil ve izin yok';

  @override
  String calendarMonthSemantics(String month, String summary) {
    return '$month, $summary';
  }

  @override
  String get calendarLoading => 'Takvim yükleniyor';

  @override
  String get calendarError => 'Takvim açılamadı. Biraz sonra tekrar dene.';

  @override
  String get appTitle => 'İzin Planla';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navLeaves => 'İzinlerim';

  @override
  String get navCalendar => 'Takvim';

  @override
  String get navBridge => 'Köprü';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get coreMeaningRemaining => 'Kalan';

  @override
  String get coreMeaningUsed => 'Kullanılan';

  @override
  String get coreMeaningPlanned => 'Planlanan';

  @override
  String get coreMeaningHoliday => 'Resmî tatil';

  @override
  String get coreMeaningEve => 'Arife (yarım gün)';

  @override
  String get coreMeaningWeekend => 'Hafta sonu';

  @override
  String get coreMeaningBridge => 'Önerilen izin';

  @override
  String get coreMeaningWorkday => 'Çalışma günü';

  @override
  String coreDays(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString gün';
  }

  @override
  String get coreBalanceRingCenter => 'gün kaldı';

  @override
  String coreBalanceRingSemantics(
    double remaining,
    double used,
    double planned,
  ) {
    final intl.NumberFormat remainingNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String remainingString = remainingNumberFormat.format(remaining);
    final intl.NumberFormat usedNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String usedString = usedNumberFormat.format(used);
    final intl.NumberFormat plannedNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String plannedString = plannedNumberFormat.format(planned);

    return 'Kalan $remainingString gün, kullanılan $usedString gün, planlanan $plannedString gün';
  }

  @override
  String get coreDayReasonWorkday => 'Çalışma günü';

  @override
  String get coreDayReasonWeeklyRest => 'Hafta tatili';

  @override
  String get coreDayReasonHoliday => 'Resmî tatil';

  @override
  String coreDayReasonHolidayNamed(String name) {
    return 'Resmî tatil: $name';
  }

  @override
  String get coreDayReasonContractualRest => 'Çalışmadığın gün';

  @override
  String get coreDayReasonHalfDay => 'Arife, öğleden sonra tatil';

  @override
  String coreDayReasonHalfDayNamed(String name) {
    return '$name, öğleden sonra tatil';
  }

  @override
  String get coreDayReasonAdministrativeLeave => 'İdari izin';

  @override
  String get coreDayReasonWeekendInsideLeave => 'İzin içinde kalan hafta sonu';

  @override
  String get coreDayReasonTrimmedEdge => 'İznin başındaki veya sonundaki tatil';

  @override
  String coreDayCounted(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString gün';
  }

  @override
  String get coreDayHalfCounted => 'Yarım gün';

  @override
  String get coreDayNotCounted => 'Sayılmaz';

  @override
  String coreDayBreakdownSemantics(String date, String reason, String value) {
    return '$date, $reason: $value';
  }

  @override
  String coreWeekStripDaySemantics(String date, String meaning) {
    return '$date, $meaning';
  }

  @override
  String get coreLegendSemantics => 'Renklerin anlamı';

  @override
  String coreInfoTipTooltip(String term) {
    return '$term nedir?';
  }

  @override
  String get coreOk => 'Tamam';

  @override
  String get coreUndo => 'Geri al';

  @override
  String coreStepProgress(int step, int total) {
    return 'Adım $step/$total';
  }

  @override
  String coreStepProgressSemantics(int step, int total) {
    return 'Adım $step, toplam $total adım';
  }

  @override
  String get coreGalleryBigNumberCaption =>
      '2026 için 14 gün kullandın, 4 gün planladın.';

  @override
  String get coreGalleryHowCalculated => 'Nasıl hesaplandı?';

  @override
  String get coreGalleryInfoTerm => 'Arife';

  @override
  String get coreGalleryInfoMessage =>
      'Bayramdan önceki gün, öğleden sonrası resmî tatildir.';

  @override
  String get coreGalleryEmptyMessage => 'Henüz izin eklemedin.';

  @override
  String get coreGalleryAddLeave => 'İzin ekle';

  @override
  String get coreGalleryCancel => 'Vazgeç';

  @override
  String get coreGalleryStepQuestion => 'İşe ne zaman başladın?';

  @override
  String get coreGalleryStepReason => 'İzin hakkın bu tarihe göre hesaplanır.';

  @override
  String get coreGalleryNext => 'Devam';

  @override
  String get coreGalleryUndoMessage => 'İzin silindi.';

  @override
  String get coreGalleryBridgeCaption =>
      '1 gün izinle 4 gün tatil, 23-26 Nisan';

  @override
  String get coreGalleryHomeTitle => 'İzin durumun';

  @override
  String get coreGalleryHomeRemaining => 'Kalan izin';

  @override
  String get coreGalleryHomeDaysUnit => 'gün';

  @override
  String get coreGalleryHomeNextAccrual => 'Yeni izin hakkı';

  @override
  String get coreGalleryHomeNextAccrualDetail =>
      '14 Nisan 2027\'de 14 gün eklenecek';

  @override
  String get coreGalleryHomeNextHoliday => 'Sıradaki tatil';

  @override
  String get coreGalleryHomeNextHolidayDetail => 'Yılbaşı, 1 Ocak';

  @override
  String get coreGalleryHomeBridgeTitle => 'Köprü önerisi';

  @override
  String get coreGalleryHomeBridgeCaption =>
      '1 gün izinle 6 gün tatil, 9-14 Mart';

  @override
  String coreOpenLink(String name) {
    return '$name bağlantısını aç';
  }

  @override
  String get coreLinkCopied => 'Tarayıcı açılamadı. Bağlantı kopyalandı.';

  @override
  String get explainTitle => 'Nasıl hesaplandı?';

  @override
  String get explainSummaryTitle => 'Hesabın özeti';

  @override
  String get explainEarned => 'Hak ettiğin';

  @override
  String get explainUsed => 'Kullandığın';

  @override
  String get explainPlanned => 'Planladığın';

  @override
  String get explainRemaining => 'Kalan';

  @override
  String explainUsedBeforeNote(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return 'Uygulamayı kullanmadan önce aldığın $daysString gün izin, kullandığın izne dâhil.';
  }

  @override
  String explainExpiringNote(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return 'Kullanmazsan $daysString gün yıl sonunda düşer.';
  }

  @override
  String get explainProfileHeader => 'Bilgilerin';

  @override
  String get explainEmploymentLabor => 'İşçi, İş Kanunu';

  @override
  String get explainEmploymentCivil => 'Memur, Devlet Memurları Kanunu';

  @override
  String explainStartDate(String date) {
    return 'İşe başlama: $date';
  }

  @override
  String explainPriorService(int years, int months, int days) {
    return 'Önceki çalışma: $years yıl $months ay $days gün';
  }

  @override
  String get explainPriorServiceTerm => 'Önceki çalışma';

  @override
  String get explainPriorServiceInfoLabor =>
      'Aynı işverende daha önce çalıştığın süre. İzin hakkın bu süre de eklenerek hesaplanır.';

  @override
  String get explainPriorServiceInfoCivil =>
      'Kamuda daha önce geçen hizmetin. İzin hakkın bu süre de eklenerek hesaplanır.';

  @override
  String get explainPeriodsHeader => 'Hak edişlerin';

  @override
  String explainPeriodDays(int days) {
    return '$days gün hak ettin';
  }

  @override
  String explainPeriodYear(int year) {
    return '$year yılı için';
  }

  @override
  String explainPeriodExpires(String date) {
    return 'Kullanmazsan $date günü düşer.';
  }

  @override
  String explainRuleApplied(String reference) {
    return '$reference uygulandı.';
  }

  @override
  String explainRuleLaborAnniversary(String serviceYears) {
    return 'İşe başladığın günün $serviceYears. yıl dönümünde bu hakkı kazandın.';
  }

  @override
  String explainRuleLaborPriorService(
    String years,
    String months,
    String days,
    String serviceStart,
  ) {
    return 'Aynı işverendeki önceki $years yıl $months ay $days gün çalışman eklendi. Bu yüzden $serviceStart günü başlamış sayılırsın.';
  }

  @override
  String explainRuleLaborAbsenceShift(String shiftDays) {
    return 'Girdiğin devamsızlık yüzünden hak ediş tarihin $shiftDays gün ileri kaydı.';
  }

  @override
  String get explainRuleLaborContinuousService =>
      'Devamsızlık girmediğin için ara vermeden çalıştığın varsayıldı.';

  @override
  String explainRuleLaborSeniorityUpToFive(String serviceYears, String days) {
    return 'Bu iş yerinde $serviceYears yılını doldurdun. Kıdemi 5 yıla kadar (5 dâhil) olanın izni $days gündür.';
  }

  @override
  String explainRuleLaborSeniorityFiveToFifteen(
    String serviceYears,
    String days,
  ) {
    return 'Bu iş yerinde $serviceYears yılını doldurdun. Kıdemi 5 yıldan fazla, 15 yıldan az olanın izni $days gündür.';
  }

  @override
  String explainRuleLaborSeniorityFifteenOrMore(
    String serviceYears,
    String days,
  ) {
    return 'Bu iş yerinde $serviceYears yılını doldurdun. Kıdemi 15 yıl ve daha fazla olanın izni $days gündür.';
  }

  @override
  String explainRuleLaborAgeEighteenOrYounger(String age, String days) {
    return 'Hak ediş gününde $age yaşındaydın. Yaşı 18 veya altında olanın izni en az $days gündür.';
  }

  @override
  String explainRuleLaborAgeFiftyOrOlder(String age, String days) {
    return 'Hak ediş gününde $age yaşındaydın. Yaşı 50 veya üstünde olanın izni en az $days gündür.';
  }

  @override
  String explainRuleLaborUnderground(String extraDays) {
    return 'Yer altı işinde çalıştığın için $extraDays gün eklendi.';
  }

  @override
  String explainRuleLaborContractExtra(String extraDays) {
    return 'Sözleşmen sana $extraDays gün ek izin veriyor.';
  }

  @override
  String get explainRuleLaborNoExpiry =>
      'Kullanmadığın izin yanmaz, sonraki yıllara geçer.';

  @override
  String explainRuleCivilFirstRight(
    String firstRightDate,
    String calendarYear,
  ) {
    return 'Kamudaki hizmetin $firstRightDate günü bir yılı doldurdu. İlk izin hakkın o gün, $calendarYear yılı için doğdu.';
  }

  @override
  String explainRuleCivilFirstRightOnDutyStart(
    String firstRightDate,
    String calendarYear,
  ) {
    return 'İlk izin hakkın göreve başladığın $firstRightDate günü doğdu, çünkü önceki hizmetin bir yılı geçiyordu. Bu hak $calendarYear yılı için.';
  }

  @override
  String explainRuleCivilCalendarYear(String calendarYear) {
    return 'Memurlarda izin hakkı her yıl 1 Ocak\'ta yenilenir. Bu yüzden $calendarYear yılının izni 1 Ocak\'ta doğdu.';
  }

  @override
  String explainRuleCivilPriorService(
    String years,
    String months,
    String days,
    String serviceStart,
  ) {
    return 'Kamudaki önceki $years yıl $months ay $days gün hizmetin eklendi. Bu yüzden $serviceStart günü başlamış sayılırsın.';
  }

  @override
  String explainRuleCivilUpToTenYears(String serviceYears, String days) {
    return 'Hizmetin $serviceYears yıl. Hizmeti 10 yıla kadar (10 dâhil) olanın izni $days gündür.';
  }

  @override
  String explainRuleCivilOverTenYears(String serviceYears, String days) {
    return 'Hizmetin $serviceYears yıl. Hizmeti 10 yıldan fazla olanın izni $days gündür.';
  }

  @override
  String explainRuleCivilTenYearTransition(
    String transitionDate,
    String calendarYear,
    String days,
  ) {
    return 'Hizmetin $transitionDate günü 10 yılı geçti. Bu yüzden $calendarYear yılı için aradaki $days gün eklendi.';
  }

  @override
  String explainRuleCivilCarryOver(String calendarYear, String expiresOn) {
    return 'Kullanmadığın $calendarYear izni bir yıl daha kullanılabilir. Bu izin $expiresOn günü düşer.';
  }

  @override
  String get explainNoPeriods => 'Henüz izin hakkın doğmadı.';

  @override
  String get explainNextHeader => 'Sıradaki hak ediş';

  @override
  String explainNextDetail(String date, int days) {
    return '$date günü $days gün eklenecek.';
  }

  @override
  String get explainNotesHeader => 'Bilmen gerekenler';

  @override
  String get explainNoAbsenceNote =>
      'Devamsızlık girmediğin için hesap, ara vermeden çalıştığın varsayımıyla yapıldı.';

  @override
  String get explainHalfDayHalf =>
      'Arife ve 28 Ekim sabahı izninden yarım gün düşer.';

  @override
  String get explainHalfDayZero => 'Arife ve 28 Ekim sabahı izninden düşmez.';

  @override
  String get explainHalfDayFull =>
      'Arife ve 28 Ekim sabahı izninden bir gün düşer.';

  @override
  String get explainHalfDayUnclear =>
      'Kanun bunu açıkça yazmıyor. Bu ayarı çalışma düzeninden değiştirebilirsin.';

  @override
  String get explainSaturdayCounts =>
      'Çalışmadığın cumartesiler izninden düşer. Yargıtayın güncel görüşü budur.';

  @override
  String get explainSaturdayNotCounted =>
      'Çalışmadığın cumartesiler izninden düşmez. Sözleşmende cumartesi hafta tatili olarak yazıyorsa bu doğrudur.';

  @override
  String get explainTeacherMessage =>
      'Öğretmenler yaz ve dinlenme tatillerinde izinli sayılır. Bu yüzden ayrıca yıllık izin verilmez.';

  @override
  String get explainNoProfileMessage =>
      'Hesabı görmek için önce kurulumu tamamla.';

  @override
  String get explainNoProfileAction => 'Kuruluma başla';

  @override
  String get explainErrorMessage => 'Bilgiler yüklenemedi.';

  @override
  String get explainRetry => 'Tekrar dene';

  @override
  String get explainLoading => 'Yükleniyor';

  @override
  String get exportLeavesFileStem => 'İzin geçmişi';

  @override
  String get exportBackupFileStem => 'İzin Planla yedek';

  @override
  String get exportPdfTitle => 'İzin geçmişi';

  @override
  String exportGeneratedOn(String date) {
    return 'Oluşturulma tarihi: $date';
  }

  @override
  String exportPageNumber(int page, int total) {
    return 'Sayfa $page / $total';
  }

  @override
  String get exportSectionProfile => 'Kişi bilgileri';

  @override
  String get exportSectionBalance => 'Yıllık izin durumu';

  @override
  String get exportSectionEntitlements => 'Hak edişler';

  @override
  String get exportSectionLeaves => 'İzinler';

  @override
  String get exportSectionDisclaimer => 'Yasal uyarı';

  @override
  String get exportDisclaimer =>
      'İzin Planla bağımsız bir uygulamadır. Resmî bir uygulama değildir, hiçbir kamu kurumuyla bağlantısı yoktur. Bilgilendirme amaçlıdır, hukuki tavsiye değildir. Hesaplar, uygulamanın bu sürümü hazırlanırken yürürlükte olan 4857 sayılı İş Kanunu\'na, 657 sayılı Devlet Memurları Kanunu\'na ve bunlara bağlı yönetmeliklere dayanır. Mevzuat ve yargı kararları değişebilir, uygulama hata içerebilir. Kesin bilgi için işverenine, insan kaynaklarına veya bir hukukçuya danış. Uygulama hiçbir garanti verilmeden sunulur. Kullanımından doğan sonuçlardan, yasaların izin verdiği ölçüde, geliştirici sorumlu tutulamaz (GPL-3.0 madde 15 ve 16).';

  @override
  String get exportFieldName => 'Ad';

  @override
  String get exportFieldLaw => 'Tabi olduğu kanun';

  @override
  String get exportLawLabor => 'İş Kanunu (4857)';

  @override
  String get exportLawCivilServant => 'Devlet Memurları Kanunu (657)';

  @override
  String get exportFieldStartDateLabor => 'İşe giriş tarihi';

  @override
  String get exportFieldStartDateCivilServant => 'Göreve başlama tarihi';

  @override
  String get exportFieldPriorService => 'Önceki hizmet süresi';

  @override
  String get exportFieldTotalService => 'Toplam hizmet süresi';

  @override
  String exportServiceDuration(int years, int months, int days) {
    return '$years yıl $months ay $days gün';
  }

  @override
  String get exportFieldAbsence => 'Hak edişi kaydıran devamsızlık';

  @override
  String get exportFieldContractExtraDays => 'Sözleşmeyle gelen ek gün';

  @override
  String get exportFieldUnderground => 'Yer altı işi';

  @override
  String get exportFieldTeacher => 'Öğretmen';

  @override
  String get exportYes => 'Evet';

  @override
  String get exportFieldUsedBeforeTracking =>
      'Uygulamadan önce kullanılan izin';

  @override
  String get exportFieldEarned => 'Hak edilen';

  @override
  String get exportFieldUsed => 'Kullanılan';

  @override
  String get exportFieldPlanned => 'Planlanan';

  @override
  String get exportFieldRemaining => 'Kalan';

  @override
  String get exportFieldExpiring => 'Yıl sonunda düşecek';

  @override
  String get exportFieldNextAccrual => 'Sonraki hak ediş';

  @override
  String exportNextAccrual(String date, String days) {
    return '$date, $days gün';
  }

  @override
  String exportDays(String days) {
    return '$days gün';
  }

  @override
  String get exportColumnField => 'Bilgi';

  @override
  String get exportColumnValue => 'Değer';

  @override
  String get exportColumnAccrualDate => 'Hak ediş tarihi';

  @override
  String get exportColumnYear => 'Yıl';

  @override
  String get exportColumnDays => 'Gün';

  @override
  String get exportColumnExpiresOn => 'Kullanılmazsa düşeceği tarih';

  @override
  String get exportColumnLegalBasis => 'Dayanak';

  @override
  String get exportColumnType => 'Tür';

  @override
  String get exportColumnStart => 'Başlangıç';

  @override
  String get exportColumnEnd => 'Bitiş';

  @override
  String get exportColumnDuration => 'Süre';

  @override
  String get exportColumnAnnualDays => 'Yıllık izinden düşen gün';

  @override
  String get exportColumnStatus => 'Durum';

  @override
  String get exportColumnNote => 'Not';

  @override
  String exportDurationDays(int days) {
    return '$days takvim günü';
  }

  @override
  String get exportDurationHalfDay => 'Yarım gün';

  @override
  String exportDurationHours(String hours) {
    return '$hours saat';
  }

  @override
  String get exportStatusUsed => 'Kullanıldı';

  @override
  String get exportStatusPlanned => 'Planlandı';

  @override
  String get exportLeaveTypeAnnual => 'Yıllık izin';

  @override
  String get exportLeaveTypeSick => 'Hastalık ve rapor';

  @override
  String get exportLeaveTypeUnpaid => 'Ücretsiz izin';

  @override
  String get exportLeaveTypeMaternity => 'Doğum izni';

  @override
  String get exportLeaveTypePaternity => 'Babalık izni';

  @override
  String get exportLeaveTypeMarriage => 'Evlenme izni';

  @override
  String get exportLeaveTypeBereavement => 'Ölüm izni';

  @override
  String get exportLeaveTypeAdoption => 'Evlat edinme izni';

  @override
  String get exportLeaveTypeDisabledChildCare =>
      'Engelli veya kronik hasta çocuk izni';

  @override
  String get exportLeaveTypeUnion => 'Sendika izni';

  @override
  String get exportLeaveTypeExcuse => 'Mazeret izni';

  @override
  String get exportLeaveTypeTravel => 'Yol izni';

  @override
  String get exportLeaveTypeOther => 'Diğer';

  @override
  String get exportNoEntitlements => 'Henüz hak ediş yok.';

  @override
  String get exportNoLeaves => 'Kayıtlı izin yok.';

  @override
  String get exportSheetSummary => 'Özet';

  @override
  String get exportSheetEntitlements => 'Hak edişler';

  @override
  String get exportSheetLeaves => 'İzinler';

  @override
  String get guideTitle => 'Mevzuat rehberi';

  @override
  String get guideIntro =>
      'Yıllık izin kurallarını burada sade dille bulursun. Her bölümün altında dayandığı kaynak yazar.';

  @override
  String get guideLaborLaw => 'İşçi (4857)';

  @override
  String get guideCivilServant => 'Memur (657)';

  @override
  String guideSource(String source) {
    return 'Kaynak: $source';
  }

  @override
  String get guideRightTitle => 'İzin hakkın ne zaman başlar?';

  @override
  String get guideRightLabor =>
      'İşe başladığın günden bir yıl sonra yıllık izin hakkın doğar. Deneme süresi de bu bir yıla dâhildir. Sonraki her hak, bir önceki haktan bir yıl sonra doğar.';

  @override
  String get guideRightLaborMerge =>
      'Aynı işverenin farklı iş yerlerinde çalıştığın süreler birleştirilir. Başka işverenlerde geçen süre eklenmez.';

  @override
  String get guideRightLaborSource => '4857 sayılı İş Kanunu, madde 53 ve 54';

  @override
  String get guideRightCivil =>
      'İlk izin hakkın hizmetin bir yılı doldurduğu gün doğar ve o yıla aittir. Sonraki haklar her yıl 1 Ocak\'ta doğar. Hak tam süredir, yılın kalanına göre azaltılmaz.';

  @override
  String get guideRightCivilService =>
      'Hizmet süresine kamu kurumlarında hangi statüde olursa olsun geçen süreler, kazanılmış hak aylığında sayılan süreler ve askerlik dâhildir.';

  @override
  String get guideRightCivilSource =>
      '657 sayılı Devlet Memurları Kanunu, madde 102 ve 103';

  @override
  String get guideDurationTitle => 'Kaç gün izin hakkın var?';

  @override
  String get guideDurationLaborShort => '1 yıldan 5 yıla kadar (5. yıl dâhil)';

  @override
  String get guideDurationLaborMiddle => '5 yıldan fazla, 15 yıldan az';

  @override
  String get guideDurationLaborLong => '15 yıl ve fazlası';

  @override
  String get guideDurationLaborAge =>
      'Yaşın 18 veya altında ya da 50 veya üstündeyse iznin en az 20 gündür.';

  @override
  String get guideDurationLaborUnderground =>
      'Yer altında çalışıyorsan her süreye 4 gün eklenir.';

  @override
  String get guideDurationLaborContract =>
      'İş sözleşmen veya toplu iş sözleşmesi bu süreleri artırabilir.';

  @override
  String get guideDurationLaborSource => '4857 sayılı İş Kanunu, madde 53';

  @override
  String get guideDurationCivilShort =>
      '1 yıldan 10 yıla kadar (10. yıl dâhil)';

  @override
  String get guideDurationCivilLong => '10 yıldan fazla';

  @override
  String get guideDurationCivilTeacher =>
      'Öğretmenler yaz ve dinlenme tatillerinde izinli sayılır, ayrıca yıllık izin verilmez.';

  @override
  String get guideDurationCivilSource =>
      '657 sayılı Devlet Memurları Kanunu, madde 102 ve 103';

  @override
  String get guideCountTitle => 'Hangi günler izinden düşmez?';

  @override
  String get guideCountLabor =>
      'Hafta tatili ve resmî tatiller izninden düşmez.';

  @override
  String get guideCountLaborSaturday =>
      'Cumartesi çalışmıyorsan, Yargıtayın güncel görüşüne göre cumartesi yine izninden düşer. Sözleşmende cumartesi hafta tatili olarak yazıyorsa düşmez. Bunu ayarlardan değiştirebilirsin.';

  @override
  String get guideCountLaborSource =>
      '4857 sayılı İş Kanunu, madde 56. Yargıtay 9. Hukuk Dairesi, 2020';

  @override
  String get guideCountCivil =>
      'İznin içinde kalan cumartesi ve pazar izninden düşer. Hafta içine denk gelen resmî tatiller ve idari izin günleri düşmez. İznin başındaki ve sonundaki hafta sonu sayılmaz.';

  @override
  String get guideCountCivilSource =>
      'Devlet Personel Başkanlığı görüşü, 29 Nisan 2016';

  @override
  String get guideCountExample =>
      'Örnek: 26-30 Ekim 2026 arasındaki izninden 3,5 gün düşer, çünkü 28 Ekim yarım gün sayılır, 29 Ekim hiç sayılmaz.';

  @override
  String get guideHalfDayTitle => 'Arife ve 28 Ekim';

  @override
  String get guideHalfDay =>
      'Bayram arifelerinde ve 28 Ekim\'de saat 13.00\'ten sonrası resmî tatildir. Mevzuat bu günlerin izinden ne kadar düşeceğini açıkça yazmaz. Uygulama varsayılan olarak yarım gün düşer. İstersen ayarlardan değiştirebilirsin.';

  @override
  String get guideHalfDaySource =>
      '2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun';

  @override
  String get guideSplitTitle => 'İzni bölebilir misin?';

  @override
  String get guideSplitLabor =>
      'İşverenin iznini tek başına bölemez. İşverenle anlaşırsan izni parçalara bölebilirsin. Parçalardan biri en az 10 gün olmalı.';

  @override
  String get guideSplitLaborSource => '4857 sayılı İş Kanunu, madde 56';

  @override
  String get guideSplitCivil =>
      'İznini tek seferde veya parça parça kullanabilirsin. En kısa parça için bir sınır yok.';

  @override
  String get guideSplitCivilSource =>
      '657 sayılı Devlet Memurları Kanunu, madde 103';

  @override
  String get guideUnusedTitle => 'Kullanmadığın izin ne olur?';

  @override
  String get guideUnusedLabor =>
      'Kullanmadığın izin yanmaz, sonraki yıllara geçer. İşten ayrılınca kullanmadığın günlerin ücreti ödenir. İzin hakkından vazgeçemezsin.';

  @override
  String get guideUnusedLaborSource => '4857 sayılı İş Kanunu, madde 53 ve 59';

  @override
  String get guideUnusedCivil =>
      'Bu yılın ve geçen yılın iznini birlikte kullanabilirsin. Daha eski yıllardan kalan izin düşer. İzin kullandığında önce geçen yıldan kalan günler düşülür.';

  @override
  String get guideUnusedCivilSource =>
      '657 sayılı Devlet Memurları Kanunu, madde 103';

  @override
  String get guideTravelTitle => 'Yol izni';

  @override
  String get guideTravelLabor =>
      'İznini iş yerinin bulunduğu yerden başka bir yerde geçireceksen ve bunu belgelersen, gidiş ve dönüş için toplam 4 güne kadar ücretsiz yol izni alabilirsin.';

  @override
  String get guideTravelLaborSource => '4857 sayılı İş Kanunu, madde 56';

  @override
  String get guideTravelCivil =>
      'İznini belediye ve köy sınırları dışında geçireceksen ve amirin uygun görürse, iznine gidiş ve dönüş için en çok ikişer gün eklenebilir. Yol izni yılda toplam 4 günü geçemez ve ertesi yıla aktarılmaz.';

  @override
  String get guideTravelCivilSource =>
      '657 sayılı Devlet Memurları Kanunu, madde 102';

  @override
  String get guideExcuseTitle => 'Mazeret izinleri';

  @override
  String get guideExcuseLabor =>
      'Bu izinler ücretlidir ve yıllık izninden düşmez.';

  @override
  String get guideExcuseMarriage => 'Evlenme';

  @override
  String get guideExcuseAdoption => 'Evlat edinme';

  @override
  String get guideExcuseLaborBereavement =>
      'Anne, baba, eş, kardeş veya çocuğun ölümü';

  @override
  String get guideExcusePaternity => 'Eşinin doğum yapması';

  @override
  String get guideExcuseLaborChild =>
      'En az %70 engelli veya süreğen hastalığı olan çocuğunun tedavisi';

  @override
  String get guideExcuseYearly => 'Yılda 10 güne kadar';

  @override
  String get guideExcuseLaborPaternityNote =>
      'Babalık izni, 1 Mayıs 2026\'dan önceki doğumlarda 5 gündür.';

  @override
  String get guideExcuseLaborSource =>
      '4857 sayılı İş Kanunu ek madde 2 ve 7578 sayılı Kanun';

  @override
  String get guideExcuseCivilMarriage => 'Kendinin veya çocuğunun evlenmesi';

  @override
  String get guideExcuseCivilBereavement =>
      'Eşinin, çocuğunun, kendinin veya eşinin anne, baba ve kardeşinin ölümü';

  @override
  String get guideExcuseCivilOther => 'Diğer mazeretler, amirin uygun görürse';

  @override
  String get guideExcuseCivilOtherValue => 'Yılda 10 gün';

  @override
  String get guideExcuseCivilChild =>
      'En az %70 engelli veya süreğen hastalığı olan çocuğunun hastalanması';

  @override
  String get guideExcuseCivilMaternity => 'Doğum (analık)';

  @override
  String get guideExcuseCivilMaternityValue => '24 hafta';

  @override
  String get guideExcuseCivil =>
      'Diğer mazeretler için zorunlu hâlde 10 gün daha verilebilir. Bu ikinci 10 gün yıllık izninden düşer. Öteki mazeret izinleri yıllık izninden düşmez.';

  @override
  String get guideExcuseCivilSource =>
      '657 sayılı Devlet Memurları Kanunu, madde 104';

  @override
  String get guideHolidaysTitle => 'Resmî tatiller';

  @override
  String get guideHolidayNewYear => '1 Ocak, Yılbaşı';

  @override
  String get guideHolidayApril => '23 Nisan, Ulusal Egemenlik ve Çocuk Bayramı';

  @override
  String get guideHolidayLabour => '1 Mayıs, Emek ve Dayanışma Günü';

  @override
  String get guideHolidayYouth =>
      '19 Mayıs, Atatürk\'ü Anma, Gençlik ve Spor Bayramı';

  @override
  String get guideHolidayDemocracy =>
      '15 Temmuz, Demokrasi ve Millî Birlik Günü';

  @override
  String get guideHolidayVictory => '30 Ağustos, Zafer Bayramı';

  @override
  String get guideHolidayRepublicEve => '28 Ekim, saat 13.00\'ten sonra';

  @override
  String get guideHolidayRepublic => '29 Ekim, Cumhuriyet Bayramı';

  @override
  String get guideHolidayRamadan =>
      'Ramazan Bayramı, arifenin öğleden sonrası ve 3 gün';

  @override
  String get guideHolidaySacrifice =>
      'Kurban Bayramı, arifenin öğleden sonrası ve 4 gün';

  @override
  String get guideHolidaysNote =>
      'Hafta sonuna denk gelen tatil için yerine başka gün verilmez.';

  @override
  String get guideHolidaysSource =>
      '2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun';

  @override
  String get guideSourcesTitle => 'Kaynaklar';

  @override
  String get guideSourcesChecked =>
      'Kaynaklar en son 20 Kasım 2026\'da kontrol edildi.';

  @override
  String get guideSourceLabor => '4857 sayılı İş Kanunu';

  @override
  String get guideSourceRegulation => 'Yıllık Ücretli İzin Yönetmeliği';

  @override
  String get guideSourceCivil => '657 sayılı Devlet Memurları Kanunu';

  @override
  String get guideSourceHolidays =>
      '2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun';

  @override
  String get guideSourcePaternity => '7578 sayılı Kanun';

  @override
  String get guideSourceDiyanet => 'Diyanet İşleri Başkanlığı, dinî günler';

  @override
  String get guideDisclaimerTitle => 'Yasal uyarı';

  @override
  String get guideDisclaimer =>
      'İzin Planla bağımsız bir uygulamadır. Resmî bir uygulama değildir, hiçbir kamu kurumuyla bağlantısı yoktur. Bilgilendirme amaçlıdır, hukuki tavsiye değildir. Hesaplar bu rehberdeki kaynaklara ve kaynakların son kontrol edildiği 20 Kasım 2026 tarihindeki mevzuata dayanır. Mevzuat ve yargı kararları değişebilir, uygulama hata içerebilir. Kesin bilgi için işverenine, insan kaynaklarına veya bir hukukçuya danış. Uygulama hiçbir garanti verilmeden sunulur. Kullanımından doğan sonuçlardan, yasaların izin verdiği ölçüde, geliştirici sorumlu tutulamaz (GPL-3.0 madde 15 ve 16).';

  @override
  String get guideLoading => 'Rehber yükleniyor';

  @override
  String get homeTitle => 'İzin durumun';

  @override
  String get homeRemainingTitle => 'Kalan izin';

  @override
  String get homeDaysUnit => 'gün';

  @override
  String homeRemainingCaption(double earned, double used, double planned) {
    final intl.NumberFormat earnedNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String earnedString = earnedNumberFormat.format(earned);
    final intl.NumberFormat usedNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String usedString = usedNumberFormat.format(used);
    final intl.NumberFormat plannedNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String plannedString = plannedNumberFormat.format(planned);

    return 'Toplam $earnedString gün hak ettin, $usedString gün kullandın, $plannedString gün planladın.';
  }

  @override
  String homeOverdrawnCaption(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return 'Hakkından $daysString gün fazla izin kullandın veya planladın.';
  }

  @override
  String get homeHowCalculated => 'Nasıl hesaplandı?';

  @override
  String get homeAddLeave => 'İzin ekle';

  @override
  String get homeNextAccrualTitle => 'Yeni izin hakkı';

  @override
  String get homeDaysLeftUnit => 'gün kaldı';

  @override
  String homeNextAccrualDetail(String date, int days) {
    return '$date günü $days gün eklenecek.';
  }

  @override
  String get homeNextHolidayTitle => 'Sıradaki tatil';

  @override
  String homeNextHolidayDetail(String name, String date) {
    return '$name, $date';
  }

  @override
  String get homeBridgeTitle => 'Köprü önerisi';

  @override
  String homeBridgeCaption(double leaveDays, int totalDays, String dates) {
    final intl.NumberFormat leaveDaysNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String leaveDaysString = leaveDaysNumberFormat.format(leaveDays);

    return '$leaveDaysString gün izinle $totalDays gün tatil, $dates';
  }

  @override
  String get homeStatsLink => 'İstatistikler';

  @override
  String get homeGuideLink => 'İzin kuralları';

  @override
  String get homeNoProfileMessage =>
      'İzin hakkını görmek için birkaç soruyu cevapla.';

  @override
  String get homeNoProfileAction => 'Kuruluma başla';

  @override
  String get homeTeacherTitle => 'Yıllık izin hesabı yok';

  @override
  String get homeTeacherMessage =>
      'Öğretmenler yaz ve dinlenme tatillerinde izinli sayılır. Bu yüzden ayrıca yıllık izin verilmez.';

  @override
  String get homeErrorMessage => 'Bilgiler yüklenemedi.';

  @override
  String get homeRetry => 'Tekrar dene';

  @override
  String get homeLoading => 'Yükleniyor';

  @override
  String get homeWidgetRemainingCaption => 'gün izin hakkın kaldı';

  @override
  String get homeWidgetOverdrawnCaption => 'gün fazla izin aldın';

  @override
  String homeWidgetRemainingSentence(String days) {
    return '$days gün izin hakkın kaldı';
  }

  @override
  String homeWidgetOverdrawnSentence(String days) {
    return '$days gün fazla izin aldın';
  }

  @override
  String homeWidgetHolidayToday(String name) {
    return 'Bugün resmî tatil: $name';
  }

  @override
  String homeWidgetHolidayTomorrow(String name) {
    return 'Yarın resmî tatil: $name';
  }

  @override
  String homeWidgetHolidayInDays(String days, String name) {
    return '$days gün sonra resmî tatil: $name';
  }

  @override
  String get homeWidgetNoHoliday => 'Sıradaki resmî tatil bilgisi yok';

  @override
  String get homeWidgetSetup => 'İzin hakkını görmek için uygulamayı aç';

  @override
  String get homeWidgetTeacher => 'Öğretmenlere yıllık izin verilmez';

  @override
  String get homeWidgetStale => 'Güncel bilgi için uygulamayı aç';

  @override
  String homeWidgetDescription(String balance, String holiday) {
    return '$balance. $holiday';
  }

  @override
  String get leaveFormTitle => 'İzin ekle';

  @override
  String get leaveFormEditTitle => 'İzni düzenle';

  @override
  String get leaveFormTypeLabel => 'İzin türü';

  @override
  String get leaveFormTypeAnnual => 'Yıllık izin';

  @override
  String get leaveFormTypeSick => 'Hastalık ve rapor';

  @override
  String get leaveFormTypeUnpaid => 'Ücretsiz izin';

  @override
  String get leaveFormTypeMaternity => 'Doğum izni';

  @override
  String get leaveFormTypePaternity => 'Babalık izni';

  @override
  String get leaveFormTypeMarriage => 'Evlenme izni';

  @override
  String get leaveFormTypeBereavement => 'Ölüm izni';

  @override
  String get leaveFormTypeAdoption => 'Evlat edinme izni';

  @override
  String get leaveFormTypeDisabledChildCare =>
      'Engelli veya kronik hasta çocuk izni';

  @override
  String get leaveFormTypeUnion => 'Sendika izni';

  @override
  String get leaveFormTypeExcuse => 'Mazeret izni';

  @override
  String get leaveFormTypeTravel => 'Yol izni';

  @override
  String get leaveFormTypeOther => 'Diğer';

  @override
  String get leaveFormCustomNameLabel => 'İznin adı';

  @override
  String get leaveFormCustomNameError => 'İzne bir ad ver.';

  @override
  String get leaveFormUnitLabel => 'Süre';

  @override
  String get leaveFormUnitDays => 'Tam gün';

  @override
  String get leaveFormUnitHalfDay => 'Yarım gün';

  @override
  String get leaveFormUnitHours => 'Saatlik';

  @override
  String get leaveFormStartLabel => 'Başlangıç';

  @override
  String get leaveFormEndLabel => 'Bitiş';

  @override
  String get leaveFormDayLabel => 'Gün';

  @override
  String get leaveFormDateError => 'Tarihi seç.';

  @override
  String get leaveFormHoursLabel => 'Kaç saat?';

  @override
  String get leaveFormHoursError => 'Saati yaz, örneğin 2 veya 1,5.';

  @override
  String leaveFormHoursTooMany(double hours) {
    final intl.NumberFormat hoursNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);

    return 'Günlük çalışma saatin $hoursString. Daha uzun izin için tam gün seç.';
  }

  @override
  String get leaveFormWorkplaceNote =>
      'Kanunda yarım gün ve saatlik izin yok. Bu kayıt iş yerinin uygulamasına göre tutulur.';

  @override
  String get leaveFormEventDateLabel => 'Çocuğun doğum tarihi';

  @override
  String leaveFormSuggestion(int days) {
    return 'Kanuna göre bu izin $days gün.';
  }

  @override
  String get leaveFormSecondExcuseLabel =>
      'Yılın ikinci 10 günlük mazeret izni';

  @override
  String get leaveFormSecondExcuseTerm => 'İkinci mazeret izni';

  @override
  String get leaveFormSecondExcuseInfo =>
      'Memurlar yılda 10 gün mazeret izni alabilir. Zorunlu durumda verilen ikinci 10 gün yıllık izinden düşülür.';

  @override
  String get leaveFormNoteLabel => 'Not (isteğe bağlı)';

  @override
  String get leaveFormDeductTitle => 'İzninden düşülecek';

  @override
  String leaveFormDeductDays(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return 'Yıllık izninden $daysString gün düşülecek.';
  }

  @override
  String get leaveFormDeductHalfDay => 'Yıllık izninden yarım gün düşülecek.';

  @override
  String leaveFormDeductHours(double hours) {
    final intl.NumberFormat hoursNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);

    return 'Yıllık izninden $hoursString saat düşülecek.';
  }

  @override
  String leaveFormRemainingAfter(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return 'Bu izinden sonra $daysString gün iznin kalır.';
  }

  @override
  String get leaveFormNotDeducted => 'Bu izin yıllık izninden düşmez.';

  @override
  String get leaveFormPickDatesHint =>
      'Tarihi seçince kaç gün düşüleceğini burada görürsün.';

  @override
  String get leaveFormBreakdownTitle => 'Gün gün döküm';

  @override
  String get leaveFormWarningTitle => 'Dikkat';

  @override
  String leaveFormBalanceWarning(double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return 'Bu izinle iznin $daysString gün eksiye düşer. Yine de kaydedebilirsin.';
  }

  @override
  String get leaveFormSplitWarning =>
      'Yıllık izni bölerek kullanıyorsan parçalardan biri en az 10 gün olmalı.';

  @override
  String get leaveFormTravelWarning =>
      'Yol izni bu dönemde toplam 4 günü geçemez.';

  @override
  String get leaveFormSave => 'Kaydet';

  @override
  String get leaveFormDeleteTooltip => 'İzni sil';

  @override
  String get leaveFormDeleted => 'İzin silindi.';

  @override
  String get leaveFormUpdated => 'İzin güncellendi.';

  @override
  String get leaveFormSaveError => 'İzin kaydedilemedi. Tekrar dene.';

  @override
  String get leaveFormNoProfileMessage =>
      'İzin eklemek için önce kurulumu tamamla.';

  @override
  String get leaveFormNoProfileAction => 'Kuruluma başla';

  @override
  String get leaveFormErrorMessage => 'Bilgiler yüklenemedi.';

  @override
  String get leaveFormRetry => 'Tekrar dene';

  @override
  String get leaveFormLoading => 'Yükleniyor';

  @override
  String get leavesTitle => 'İzinlerim';

  @override
  String get leavesTabLeaves => 'İzinler';

  @override
  String get leavesTabHours => 'Saat ve mesai';

  @override
  String leavesYearFilter(int year) {
    return 'Yıl: $year';
  }

  @override
  String leavesTypeFilter(String type) {
    return 'Tür: $type';
  }

  @override
  String get leavesTypeAll => 'Tümü';

  @override
  String get leavesYearSheetTitle => 'Yıl seç';

  @override
  String get leavesTypeSheetTitle => 'İzin türü seç';

  @override
  String get leavesPlannedHeader => 'Planlanan';

  @override
  String get leavesUsedHeader => 'Kullanılan';

  @override
  String leavesCalendarDays(int days) {
    return '$days takvim günü';
  }

  @override
  String leavesHours(double hours) {
    final intl.NumberFormat hoursNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);

    return '$hoursString saat';
  }

  @override
  String get leavesEmptyMessage => 'Henüz izin eklemedin.';

  @override
  String get leavesAdd => 'İzin ekle';

  @override
  String get leavesNoMatch => 'Bu seçime uyan izin yok.';

  @override
  String get leavesOvertimeTitle => 'Fazla mesai';

  @override
  String get leavesHourlyTitle => 'Saatlik izin';

  @override
  String get leavesHourUnit => 'saat';

  @override
  String get leavesOvertimeHeader => 'Fazla mesai kayıtları';

  @override
  String get leavesHourlyHeader => 'Saatlik izinler';

  @override
  String get leavesHoursEmpty =>
      'Bu yıl için fazla mesai veya saatlik izin kaydın yok.';

  @override
  String get leavesAddOvertime => 'Fazla mesai ekle';

  @override
  String get leavesOvertimeSheetTitle => 'Fazla mesai';

  @override
  String get leavesOvertimeDate => 'Tarih';

  @override
  String get leavesOvertimeHoursLabel => 'Kaç saat?';

  @override
  String get leavesOvertimeHoursError => 'Saati yaz, örneğin 2 veya 1,5.';

  @override
  String get leavesOvertimeNote => 'Not (isteğe bağlı)';

  @override
  String get leavesSave => 'Kaydet';

  @override
  String get leavesDelete => 'Sil';

  @override
  String get leavesOvertimeDeleted => 'Fazla mesai kaydı silindi.';

  @override
  String get leavesNoProfileMessage =>
      'İzinlerini görmek için önce kurulumu tamamla.';

  @override
  String get leavesNoProfileAction => 'Kuruluma başla';

  @override
  String get leavesErrorMessage => 'Bilgiler yüklenemedi.';

  @override
  String get leavesRetry => 'Tekrar dene';

  @override
  String get leavesLoading => 'Yükleniyor';

  @override
  String get notificationsChannelName => 'Hatırlatmalar';

  @override
  String get notificationsChannelDescription =>
      'Resmî tatil, köprü, hak ediş ve izin hatırlatmaları';

  @override
  String get notificationsHolidayTitle => 'Resmî tatil yaklaşıyor';

  @override
  String notificationsHolidayBody(int days, String holiday) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$holiday için $days gün kaldı.',
      one: 'Yarın $holiday.',
      zero: 'Bugün $holiday.',
    );
    return '$_temp0';
  }

  @override
  String get notificationsBridgeTitle => 'Köprü fırsatı';

  @override
  String notificationsBridgeBody(
    int days,
    String holiday,
    double leaveDays,
    int totalDays,
  ) {
    final intl.NumberFormat leaveDaysNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String leaveDaysString = leaveDaysNumberFormat.format(leaveDays);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$holiday için $days gün kaldı.',
      one: 'Yarın $holiday.',
      zero: 'Bugün $holiday.',
    );
    return '$_temp0 Bu tatile $leaveDaysString gün izin eklersen toplam $totalDays gün tatil yaparsın.';
  }

  @override
  String get notificationsAccrualTitle => 'Yeni izin hakkı';

  @override
  String notificationsAccrualBody(String name, int days) {
    return '$name için bugün $days gün yıllık izin hakkı doğdu.';
  }

  @override
  String get notificationsLeaveStartTitle => 'İzin yaklaşıyor';

  @override
  String notificationsLeaveStartBody(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$name için planlanan izin $days gün sonra başlıyor.',
      one: '$name için planlanan izin yarın başlıyor.',
      zero: '$name için planlanan izin bugün başlıyor.',
    );
    return '$_temp0';
  }

  @override
  String get notificationsLeaveReturnTitle => 'İzin bitiyor';

  @override
  String notificationsLeaveReturnBody(String name) {
    return '$name için yarın işe dönüş günü.';
  }

  @override
  String get notificationsYearEndExpiringTitle => 'Kullanılmamış izin düşecek';

  @override
  String notificationsYearEndExpiringBody(String name, double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$name için $daysString gün izin yıl sonuna kadar kullanılmazsa 1 Ocak\'ta düşecek.';
  }

  @override
  String get notificationsYearEndUnusedTitle => 'Kullanılmamış izin var';

  @override
  String notificationsYearEndUnusedBody(String name, double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$name için $daysString gün kullanılmamış izin var. Bu izin yıl sonunda düşmez, sonraki yıla geçer.';
  }

  @override
  String get notificationsTestTitle => 'Bildirimler açık';

  @override
  String get notificationsTestBody => 'Hatırlatmalar böyle görünecek.';

  @override
  String get onboardingTitle => 'Kurulum';

  @override
  String get onboardingNext => 'Devam';

  @override
  String get onboardingFinish => 'Bitir';

  @override
  String get onboardingTypeQuestion => 'Nasıl çalışıyorsun?';

  @override
  String get onboardingTypeReason =>
      'İzin hakkı işçide ve memurda farklı hesaplanır.';

  @override
  String get onboardingTypeLabor => 'İşçiyim';

  @override
  String get onboardingTypeLaborDetail =>
      'Özel sektörde veya kamuda işçi, İş Kanunu';

  @override
  String get onboardingTypeCivil => 'Devlet memuruyum';

  @override
  String get onboardingTypeCivilDetail => 'Devlet Memurları Kanunu';

  @override
  String get onboardingStartQuestionLabor => 'Bu iş yerinde ne zaman başladın?';

  @override
  String get onboardingStartQuestionCivil => 'Memurluğa ne zaman başladın?';

  @override
  String get onboardingStartReasonLabor =>
      'İzin hakkın bu iş yerinde çalıştığın süreye göre artar.';

  @override
  String get onboardingStartReasonCivil =>
      'İzin hakkın kamuda çalıştığın süreye göre artar.';

  @override
  String get onboardingStartLabel => 'İşe başlama tarihi';

  @override
  String get onboardingBirthQuestion => 'Doğum tarihin ne?';

  @override
  String get onboardingBirthReasonLabor =>
      'Yaşın 18 veya altında ya da 50 veya üstündeyse izin hakkın en az 20 gün olur.';

  @override
  String get onboardingBirthLabel => 'Doğum tarihi';

  @override
  String get onboardingSaturdayQuestion => 'Cumartesi çalışıyor musun?';

  @override
  String get onboardingSaturdayReason =>
      'İzne denk gelen cumartesilerin nasıl sayılacağı buna bağlı.';

  @override
  String get onboardingSaturdayYes => 'Evet, çalışıyorum';

  @override
  String get onboardingSaturdayNo => 'Hayır, çalışmıyorum';

  @override
  String get onboardingDefaultName => 'Ben';

  @override
  String get onboardingSaveError => 'Bilgiler kaydedilemedi. Tekrar dene.';

  @override
  String get peopleTitle => 'Kişiler';

  @override
  String get peopleHint =>
      'Eşini veya çalışanını da ekleyip izinlerini ayrı takip edebilirsin.';

  @override
  String get peopleSelectHint => 'Dokunduğun kişi ana sayfada görünür.';

  @override
  String get peopleEmptyMessage => 'Henüz kimseyi eklemedin.';

  @override
  String get peopleAdd => 'Kişi ekle';

  @override
  String get peopleSelected => 'Seçili';

  @override
  String peopleEditTooltip(String name) {
    return '$name bilgilerini düzenle';
  }

  @override
  String get peopleLabor => 'İşçi, İş Kanunu';

  @override
  String get peopleCivil => 'Memur, Devlet Memurları Kanunu';

  @override
  String peopleDeleted(String name) {
    return '$name silindi.';
  }

  @override
  String get peopleSaveError => 'Bilgiler kaydedilemedi. Tekrar dene.';

  @override
  String get peopleFormNewTitle => 'Yeni kişi';

  @override
  String get peopleFormEditTitle => 'Kişiyi düzenle';

  @override
  String get peopleFormName => 'Ad';

  @override
  String get peopleFormNameError => 'Bir ad yaz.';

  @override
  String get peopleFormTypeLabel => 'Çalışma şekli';

  @override
  String get peopleTypeLaborTitle => 'İşçi';

  @override
  String get peopleTypeLaborDetail =>
      'Özel sektörde veya kamuda işçi, İş Kanunu';

  @override
  String get peopleTypeCivilTitle => 'Devlet memuru';

  @override
  String get peopleTypeCivilDetail => 'Devlet Memurları Kanunu';

  @override
  String get peopleFormStart => 'İşe başlama tarihi';

  @override
  String get peopleFormBirth => 'Doğum tarihi';

  @override
  String get peopleFormDateError => 'Tarihi seç.';

  @override
  String get peopleFormSaturday => 'Cumartesi iş günü';

  @override
  String get peopleFormSave => 'Kaydet';

  @override
  String get peopleFormDeleteTooltip => 'Kişiyi sil';

  @override
  String get peopleDatePlaceholder => 'Tarih seç';

  @override
  String get peopleAdvancedTitle => 'Gelişmiş (isteğe bağlı)';

  @override
  String get peoplePriorServiceLabel => 'Önceki çalışma süresi';

  @override
  String get peoplePriorServiceInfoLabor =>
      'Aynı işverenin başka iş yerlerinde çalıştığın süre de izin hakkına eklenir. Başka işverenlerdeki süre eklenmez.';

  @override
  String get peoplePriorServiceInfoCivil =>
      'Kamu kurumlarında geçen süreler ve askerlik hizmete sayılır.';

  @override
  String get peopleYears => 'Yıl';

  @override
  String get peopleMonths => 'Ay';

  @override
  String get peopleDays => 'Gün';

  @override
  String get peopleUsedBeforeLabel => 'Uygulamadan önce kullanılan izin (gün)';

  @override
  String get peopleUsedBeforeHelp =>
      'Hâlâ geçerli izin hakkından, uygulamayı kullanmaya başlamadan önce kullandığın günleri yaz. Süresi dolup düşen eski yılların iznini yazma.';

  @override
  String get peopleContractLabel => 'Sözleşmeyle gelen ek izin (gün)';

  @override
  String get peopleUndergroundLabel => 'Yer altı işi, örneğin maden';

  @override
  String get peopleTeacherLabel => 'Öğretmen';

  @override
  String get peopleDailyHoursLabel => 'Günlük çalışma saati';

  @override
  String get peopleNumberError => 'Sayı yaz, örneğin 4 veya 4,5.';

  @override
  String get peopleErrorMessage => 'Bilgiler yüklenemedi.';

  @override
  String get peopleRetry => 'Tekrar dene';

  @override
  String get peopleLoading => 'Yükleniyor';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsPeopleTitle => 'Kişiler';

  @override
  String settingsPeopleSummary(String name, int count) {
    return '$name seçili. Toplam $count kişi.';
  }

  @override
  String get settingsPeopleEmpty => 'Henüz kişi eklemedin.';

  @override
  String get settingsScheduleTitle => 'Çalışma düzeni';

  @override
  String settingsScheduleFor(String name) {
    return '$name için geçerli.';
  }

  @override
  String get settingsWorkDays => 'Çalıştığın günler';

  @override
  String get settingsSaturdayTitle => 'Çalışmadığın cumartesi izinden düşsün';

  @override
  String get settingsSaturdayHelp =>
      'Sözleşmende veya toplu iş sözleşmende cumartesi hafta tatili olarak yazıyorsa kapat.';

  @override
  String get settingsSaturdayInfoTerm => 'Cumartesi';

  @override
  String get settingsSaturdayInfo =>
      'Yargıtayın güncel görüşüne göre çalışmadığın cumartesi izninden düşer. Eski kararlarda ve bazı bölge mahkemelerinde düşmez.';

  @override
  String get settingsHalfDayTitle => 'Arife ve 28 Ekim sabahı';

  @override
  String get settingsHalfDayHelp =>
      'Mevzuat bunu açıkça yazmaz. Uygulama varsayılan olarak yarım gün düşer.';

  @override
  String get settingsHalfDayZero => 'İzinden düşmesin';

  @override
  String get settingsHalfDayHalf => 'Yarım gün düşsün';

  @override
  String get settingsHalfDayFull => 'Tam gün düşsün';

  @override
  String get settingsHoursTitle => 'Günlük çalışma saatin';

  @override
  String settingsHoursValue(double hours) {
    final intl.NumberFormat hoursNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);

    return '$hoursString saat';
  }

  @override
  String get settingsHoursHelp => 'Saatlik izni güne çevirmek için kullanılır.';

  @override
  String get settingsHoursDecrease => 'Yarım saat azalt';

  @override
  String get settingsHoursIncrease => 'Yarım saat artır';

  @override
  String get settingsThemeTitle => 'Görünüm';

  @override
  String get settingsThemeSystem => 'Telefonun ayarı';

  @override
  String get settingsThemeLight => 'Açık';

  @override
  String get settingsThemeDark => 'Koyu';

  @override
  String get settingsRemindersTitle => 'Hatırlatmalar';

  @override
  String get settingsRemindersHelp =>
      'Bir hatırlatmayı açınca bildirim izni istenir.';

  @override
  String get settingsReminderHoliday => 'Resmî tatil ve köprü';

  @override
  String get settingsReminderAccrual => 'Yeni izin hakkın doğunca';

  @override
  String get settingsReminderPlanned => 'Planladığın izinden önce';

  @override
  String get settingsReminderYearEnd => 'Yıl sonunda kullanmadığın izin';

  @override
  String settingsDaysBefore(int days) {
    return '$days gün önce';
  }

  @override
  String get settingsDaysBeforeDecrease => 'Gün sayısını azalt';

  @override
  String get settingsDaysBeforeIncrease => 'Gün sayısını artır';

  @override
  String get settingsPermissionDenied =>
      'Bildirim izni verilmedi. Telefonun ayarlarından açabilirsin.';

  @override
  String get settingsDataTitle => 'Verilerin';

  @override
  String get settingsBackup => 'Yedekle';

  @override
  String get settingsBackupHelp => 'Bütün verilerini tek dosya olarak paylaş.';

  @override
  String get settingsRestore => 'Yedekten geri yükle';

  @override
  String get settingsRestoreHelp => 'Daha önce aldığın yedeği aç.';

  @override
  String get settingsRestoreConfirmTitle => 'Yedek geri yüklensin mi?';

  @override
  String get settingsRestoreConfirmBody =>
      'Şu anki bütün verilerin yedekteki verilerle değişir.';

  @override
  String get settingsRestoreConfirm => 'Geri yükle';

  @override
  String get settingsRestoreDone => 'Yedek geri yüklendi.';

  @override
  String get settingsExport => 'Dışa aktar';

  @override
  String get settingsExportHelp =>
      'İzin geçmişini PDF, Excel veya CSV dosyası olarak al.';

  @override
  String get settingsExportPdf => 'PDF';

  @override
  String get settingsExportExcel => 'Excel';

  @override
  String get settingsExportCsv => 'CSV';

  @override
  String get settingsExportShare => 'Paylaş';

  @override
  String get settingsExportSave => 'Cihaza kaydet';

  @override
  String get settingsExportSaved => 'Dosya kaydedildi.';

  @override
  String get settingsReset => 'Bütün verileri sil';

  @override
  String get settingsResetHelp => 'Kişiler, izinler ve ayarlar silinir.';

  @override
  String get settingsResetConfirmTitle => 'Bütün veriler silinsin mi?';

  @override
  String get settingsResetConfirmBody =>
      'Kişiler, izinler ve ayarlar silinir. Hemen sonra geri alabilirsin.';

  @override
  String get settingsResetConfirm => 'Sil';

  @override
  String get settingsResetTypeLabel => 'Onaylamak için \"sil\" yaz';

  @override
  String get settingsResetWord => 'sil';

  @override
  String get settingsResetDone => 'Bütün veriler silindi.';

  @override
  String get settingsCancel => 'Vazgeç';

  @override
  String get settingsFailed => 'İşlem tamamlanamadı. Tekrar dene.';

  @override
  String get settingsInfoTitle => 'Bilgi';

  @override
  String get settingsStats => 'İstatistik';

  @override
  String get settingsGuide => 'Mevzuat rehberi';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsLoading => 'Ayarlar yükleniyor';

  @override
  String get settingsError => 'Ayarlar açılamadı. Biraz sonra tekrar dene.';

  @override
  String get settingsRestoreNewer =>
      'Bu yedek, uygulamanın daha yeni bir sürümüyle alınmış. Geri yüklemek için önce uygulamayı güncelle. Verilerin değişmedi.';

  @override
  String get settingsRestoreInvalid =>
      'Bu dosya geçerli bir İzin Planla yedeği değil. Verilerin değişmedi.';

  @override
  String get settingsWorkDaysHelp => 'En az bir gün seçili kalır.';

  @override
  String get statsTitle => 'İstatistik';

  @override
  String get statsEveryone => 'Herkes';

  @override
  String statsDaysOffTitle(int year) {
    return '$year yılında tatil';
  }

  @override
  String get statsDaysOffCaption => 'İzin, resmî tatil ve hafta sonu birlikte.';

  @override
  String get statsDaysOffCaptionEveryone =>
      'Herkesin izin, resmî tatil ve hafta sonu günleri birlikte.';

  @override
  String get statsDaysUnit => 'gün';

  @override
  String get statsEarned => 'Hak edilen';

  @override
  String get statsUsed => 'Kullanılan';

  @override
  String get statsByYearTitle => 'Yıllara göre';

  @override
  String statsByYearRow(int year, double earned, double used) {
    final intl.NumberFormat earnedNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String earnedString = earnedNumberFormat.format(earned);
    final intl.NumberFormat usedNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String usedString = usedNumberFormat.format(used);

    return '$year: hak edilen $earnedString gün, kullanılan $usedString gün';
  }

  @override
  String get statsByYearChart =>
      'Yıllara göre hak edilen ve kullanılan izin grafiği. Değerler grafiğin altında yazıyor.';

  @override
  String get statsByMonthTitle => 'Aylara göre';

  @override
  String statsByMonthRow(String month, double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$month: $daysString gün';
  }

  @override
  String statsByMonthEmpty(int year) {
    return 'Seçtiğin $year yılında yıllık izin kullanılmadı.';
  }

  @override
  String statsByMonthChart(int year) {
    return 'Aylara göre kullanılan yıllık izin grafiği, $year. Değerler grafiğin altında yazıyor.';
  }

  @override
  String get statsByTypeTitle => 'Türlere göre';

  @override
  String statsByTypeRow(String type, double days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$type: $daysString gün';
  }

  @override
  String statsByTypeEmpty(int year) {
    return 'Seçtiğin $year yılında kayıtlı izin yok.';
  }

  @override
  String get statsEmptyMessage =>
      'Henüz izin eklemedin. İzin ekleyince özetini burada görürsün.';

  @override
  String get statsEmptyAction => 'İzin ekle';

  @override
  String get statsNoProfileMessage =>
      'İstatistiği görmek için önce kurulumu tamamla.';

  @override
  String get statsNoProfileAction => 'Kuruluma başla';

  @override
  String get statsLoading => 'İstatistik yükleniyor';

  @override
  String get statsError => 'İstatistik açılamadı. Biraz sonra tekrar dene.';
}
