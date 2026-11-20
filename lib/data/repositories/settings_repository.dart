import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// Stores app settings. Implemented with drift by task 10.
abstract interface class SettingsRepository {
  /// Emits the settings now and after every change.
  Stream<AppSettings> watch();

  /// Replaces the settings.
  Future<Result<void>> save(AppSettings settings);
}
