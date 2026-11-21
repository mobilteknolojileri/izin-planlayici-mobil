import 'package:flutter/services.dart';
import 'package:izin_planla/data/repositories/backup_codec.dart';
import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/services/export/backup_envelope_codec.dart';
import 'package:izin_planla/data/services/export/export_failure.dart';
import 'package:izin_planla/data/services/export/export_failure_reason.dart';
import 'package:izin_planla/data/services/export/export_file.dart';
import 'package:izin_planla/data/services/export/export_format.dart';
import 'package:izin_planla/data/services/export/export_gateway.dart';
import 'package:izin_planla/data/services/export/export_service.dart';
import 'package:izin_planla/data/services/export/leave_csv_encoder.dart';
import 'package:izin_planla/data/services/export/leave_pdf_encoder.dart';
import 'package:izin_planla/data/services/export/leave_report_builder.dart';
import 'package:izin_planla/data/services/export/leave_xlsx_encoder.dart';
import 'package:izin_planla/data/services/export/plugin_export_gateway.dart';
import 'package:izin_planla/data/services/export/report_text.dart';
import 'package:izin_planla/data/services/export/xlsx_writer.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/utils/result.dart';
import 'package:pdf/widgets.dart' as pw;

/// [ExportService] that writes PDF, Excel and CSV reports and versioned
/// backups.
///
/// Every failure comes back as an [ExportFailure] inside the [Result].
/// [saveToDevice] fails with [ExportFailureReason.cancelled] when the user
/// closes the save dialog, so the UI can stay silent instead of showing
/// "saved". [pickBackupFile] returns the validated `BackupCodec` document
/// taken out of the envelope, ready for `BackupCodec.restoreJson`.
class DefaultExportService implements ExportService {
  /// Creates the service.
  ///
  /// [schemaVersion] is the database schema version, a backup with a higher
  /// one is refused. [appVersion] is the pubspec version, e.g. `1.0.0+1`,
  /// stored in every backup for support only. `gateway`, [assets] and `now`
  /// are replaced in tests.
  new({
    required ProfileRepository profiles,
    required LeaveRepository leaves,
    required HolidayRepository holidays,
    required EntitlementCalculator entitlementCalculator,
    required BalanceCalculator balanceCalculator,
    required this._backupCodec,
    required AppLocalizations l10n,
    required String appVersion,
    required int schemaVersion,
    this._gateway = const PluginExportGateway(),
    AssetBundle? assets,
    this._now = DateTime.now,
  }) : _reports = LeaveReportBuilder(
         profiles: profiles,
         leaves: leaves,
         holidays: holidays,
         entitlementCalculator: entitlementCalculator,
         balanceCalculator: balanceCalculator,
       ),
       _text = ReportText(l10n),
       _envelope = BackupEnvelopeCodec(
         appVersion: appVersion,
         schemaVersion: schemaVersion,
       ),
       _assets = assets ?? rootBundle;

  /// Bundled font with Turkish glyphs, embedded in every PDF.
  static const fontAsset = 'assets/fonts/Inter.ttf';

  final LeaveReportBuilder _reports;
  final BackupCodec _backupCodec;
  final ReportText _text;
  final BackupEnvelopeCodec _envelope;
  final ExportGateway _gateway;
  final AssetBundle _assets;
  final DateTime Function() _now;
  pw.Font? _font;

  @override
  Future<Result<ExportFile>> exportLeaves({
    required String profileId,
    required ExportFormat format,
  }) async {
    try {
      final now = _now();
      final report = await _reports.build(profileId, date: now);
      if (report == null) {
        return const Result.error(
          ExportFailure(ExportFailureReason.profileNotFound),
        );
      }
      final name = fileName([
        _text.l10n.exportLeavesFileStem,
        report.profile.name,
        _isoDate(report.date),
      ], format.name);
      return Result.ok(switch (format) {
        ExportFormat.csv => ExportFile(
          fileName: name,
          mimeType: LeaveCsvEncoder.mimeType,
          bytes: LeaveCsvEncoder(_text).encode(report),
        ),
        ExportFormat.xlsx => ExportFile(
          fileName: name,
          mimeType: XlsxWriter.mimeType,
          bytes: LeaveXlsxEncoder(_text).encode(report, modified: now),
        ),
        ExportFormat.pdf => ExportFile(
          fileName: name,
          mimeType: LeavePdfEncoder.mimeType,
          bytes: await LeavePdfEncoder(
            _text,
            font: await _loadFont(),
          ).encode(report),
        ),
      });
    } on Exception catch (error) {
      return Result.error(
        ExportFailure(ExportFailureReason.buildFailed, cause: error),
      );
    }
  }

  @override
  Future<Result<void>> share(ExportFile file) async {
    try {
      await _gateway.share(file);
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(
        ExportFailure(ExportFailureReason.shareFailed, cause: error),
      );
    }
  }

  @override
  Future<Result<void>> saveToDevice(ExportFile file) async {
    try {
      final saved = await _gateway.save(file);
      return saved
          ? const Result.ok(null)
          : const Result.error(ExportFailure(ExportFailureReason.cancelled));
    } on Exception catch (error) {
      return Result.error(
        ExportFailure(ExportFailureReason.saveFailed, cause: error),
      );
    }
  }

  @override
  Future<Result<void>> shareBackup() async {
    final backup = await createBackup();
    return switch (backup) {
      Ok(:final value) => await share(value),
      Err(:final error) => Result.error(error),
    };
  }

  /// Builds the backup file without sharing it.
  ///
  /// Fails with [ExportFailureReason.backupFailed] when the codec fails or
  /// returns something that is not JSON.
  Future<Result<ExportFile>> createBackup() async {
    final Result<String> exported;
    try {
      exported = await _backupCodec.exportJson();
    } on Exception catch (error) {
      return Result.error(
        ExportFailure(ExportFailureReason.backupFailed, cause: error),
      );
    }
    switch (exported) {
      case Err(:final error):
        return Result.error(
          ExportFailure(ExportFailureReason.backupFailed, cause: error),
        );
      case Ok(:final value):
        final now = _now();
        final Uint8List bytes;
        try {
          bytes = _envelope.wrap(value, exportedAt: now);
        } on FormatException catch (error) {
          return Result.error(
            ExportFailure(ExportFailureReason.backupFailed, cause: error),
          );
        }
        final time =
            '${now.hour.toString().padLeft(2, '0')}'
            '${now.minute.toString().padLeft(2, '0')}';
        return Result.ok(
          ExportFile(
            fileName: fileName([
              _text.l10n.exportBackupFileStem,
              _isoDate(now),
              time,
            ], 'json'),
            mimeType: BackupEnvelopeCodec.mimeType,
            bytes: bytes,
          ),
        );
    }
  }

  @override
  Future<Result<String?>> pickBackupFile() async {
    final Uint8List? bytes;
    try {
      bytes = await _gateway.pick(maxBytes: BackupEnvelopeCodec.maxBytes);
    } on ExportFailure catch (failure) {
      return Result.error(failure);
    } on Exception catch (error) {
      return Result.error(
        ExportFailure(ExportFailureReason.pickFailed, cause: error),
      );
    }
    if (bytes == null) return const Result.ok(null);
    return switch (_envelope.read(bytes)) {
      Ok(:final value) => Result.ok(value.payloadJson),
      Err(:final error) => Result.error(error),
    };
  }

  /// Joins [parts] into a lowercase ASCII file name with dashes, e.g.
  /// `izin-gecmisi-ayse-yilmaz-2026-11-21.pdf`.
  ///
  /// Turkish letters lose their marks and anything else that is not a
  /// letter or digit becomes a dash, so every share target and file system
  /// accepts the name. Each part is cut to 40 characters.
  static String fileName(List<String> parts, String extension) {
    final slugs = [for (final part in parts) _slug(part)]
        .where((slug) => slug.isNotEmpty);
    final stem = slugs.isEmpty ? 'export' : slugs.join('-');
    return '$stem.$extension';
  }

  static const _ascii = {
    'ç': 'c',
    'Ç': 'c',
    'ğ': 'g',
    'Ğ': 'g',
    'ı': 'i',
    'I': 'i',
    'İ': 'i',
    'ö': 'o',
    'Ö': 'o',
    'ş': 's',
    'Ş': 's',
    'ü': 'u',
    'Ü': 'u',
    'â': 'a',
    'Â': 'a',
    'î': 'i',
    'Î': 'i',
    'û': 'u',
    'Û': 'u',
  };

  static String _slug(String text) {
    final buffer = StringBuffer();
    for (final char in text.split('')) {
      buffer.write(_ascii[char] ?? char.toLowerCase());
    }
    var slug = buffer
        .toString()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    if (slug.length > 40) {
      slug = slug.substring(0, 40).replaceAll(RegExp(r'-+$'), '');
    }
    return slug;
  }

  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<pw.Font> _loadFont() async =>
      _font ??= pw.Font.ttf(await _assets.load(fontAsset));
}
