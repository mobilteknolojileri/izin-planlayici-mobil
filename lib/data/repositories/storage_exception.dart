import 'package:drift/isolate.dart';
import 'package:drift/native.dart';

/// A database read or write failed.
///
/// Every write runs in one transaction, so a failed write changed nothing.
final class StorageException implements Exception {
  /// Creates an exception caused by [cause].
  const new(this.cause, {this.isConstraintViolation = false, this.stackTrace});

  /// Wraps a database [error] and recognizes broken schema rules.
  factory fromDatabase(Exception error, [StackTrace? stackTrace]) =>
      StorageException(
        error,
        isConstraintViolation: _isConstraintViolation(error),
        stackTrace: stackTrace,
      );

  /// SQLite's primary result code for `SQLITE_CONSTRAINT`.
  static const _sqliteConstraint = 19;

  /// The original database error, kept for logs.
  final Exception cause;

  /// Whether the database rejected the data because it broke a schema rule:
  /// a CHECK, a missing referenced profile or a duplicate id.
  final bool isConstraintViolation;

  /// Where [cause] was thrown, kept for logs.
  final StackTrace? stackTrace;

  static bool _isConstraintViolation(Object error) => switch (error) {
    SqliteException(:final resultCode) => resultCode == _sqliteConstraint,
    DriftRemoteException(:final remoteCause) => _isConstraintViolation(
      remoteCause,
    ),
    _ => false,
  };

  @override
  String toString() => 'StorageException: $cause';
}
