/// Links on the about screen, from `docs/mevzuat.md` and the repository.
enum AboutLink {
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

  /// The privacy policy, published with GitHub Pages.
  privacyPolicy(
    'https://mobilteknolojileri.github.io/izin-planlayici-mobil/store/privacy-policy.html',
  ),

  /// The public source code repository.
  sourceCode('https://github.com/mobilteknolojileri/izin-planlayici-mobil');

  new(this.url);

  /// Web address.
  final String url;
}
