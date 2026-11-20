import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/fakes/in_memory_collection.dart';

void main() {
  test('watch emits current items, then every change', () async {
    final collection = InMemoryCollection<String>((s) => s, ['a']);
    final emitted = expectLater(
      collection.watch(),
      emitsInOrder([
        ['a'],
        ['a', 'b'],
        ['b'],
      ]),
    );

    await Future<void>.delayed(Duration.zero);
    collection
      ..put('b')
      ..remove('a');
    await emitted;
  });
}
