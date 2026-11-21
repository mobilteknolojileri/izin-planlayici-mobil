/// Official sources the guide cites, with their links from
/// `docs/mevzuat.md`.
enum GuideSource {
  /// Labour Law 4857.
  labor(
    'https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=4857&MevzuatTur=1&MevzuatTertip=5',
  ),

  /// Annual Paid Leave Regulation.
  regulation(
    'https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=5451&MevzuatTur=7&MevzuatTertip=5',
  ),

  /// Civil Servants Law 657.
  civil(
    'https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=657&MevzuatTur=1&MevzuatTertip=5',
  ),

  /// Law 2429 on national and public holidays.
  holidays(
    'https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=2429&MevzuatTur=1&MevzuatTertip=5',
  ),

  /// Law 7578, the longer paternity leave.
  paternity('https://www.resmigazete.gov.tr/eskiler/2026/05/20260501-1.htm'),

  /// Diyanet religious days of 2026, the source of the religious holiday
  /// dates.
  diyanet('https://vakithesaplama.diyanet.gov.tr/dinigunler.php?yil=2026'),

  /// The State Personnel Directorate opinion of 29 April 2016 on counting
  /// civil servants' leave days.
  personnel(
    'https://www.gtu.edu.tr/Files/UserFiles/133/DPB/Bayram_zinlerinin_yllk_izine_zarar_olmayacana_ilikin_DPB_Goruu_2016.pdf',
  );

  new(this.url);

  /// Web address of the source text.
  final String url;
}
