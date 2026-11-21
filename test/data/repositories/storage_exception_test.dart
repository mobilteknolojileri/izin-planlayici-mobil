import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/repositories/storage_exception.dart';

void main() {
  test('a SQLite constraint error is a constraint violation', () {
    final exception = StorageException.fromDatabase(
      SqliteException(extendedResultCode: 275, message: 'CHECK failed'),
    );

    expect(exception.isConstraintViolation, isTrue);
  });

  test('other SQLite errors are not', () {
    final exception = StorageException.fromDatabase(
      SqliteException(extendedResultCode: 13, message: 'disk is full'),
    );

    expect(exception.isConstraintViolation, isFalse);
  });

  test('other exceptions are not', () {
    final exception = StorageException.fromDatabase(
      const FormatException('bad column'),
    );

    expect(exception.isConstraintViolation, isFalse);
    expect(exception.cause, isA<FormatException>());
  });
}
