import 'package:izin_planla/data/services/export/export_failure_reason.dart';

/// Expected failure of the export service, returned inside a `Result`.
///
/// Carries a stable [reason] for the UI and the original [cause] for logs,
/// never a localized message.
final class ExportFailure implements Exception {
  /// Creates a failure with [reason] and an optional [cause].
  const new(this.reason, {this.cause});

  /// What went wrong.
  final ExportFailureReason reason;

  /// The error that led to this failure, if any.
  final Object? cause;

  @override
  String toString() => cause == null
      ? 'ExportFailure(${reason.name})'
      : 'ExportFailure(${reason.name}, $cause)';
}
