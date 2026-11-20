import 'dart:async';

/// Keeps items in memory and emits the full list after every change.
///
/// Used by the fake repositories while the real ones are being built.
class InMemoryCollection<T> {
  /// Creates a collection seeded with [initial]. [idOf] returns an item's id.
  new(String Function(T item) idOf, [Iterable<T> initial = const []])
    : _idOf = idOf,
      _items = {for (final item in initial) idOf(item): item};

  final String Function(T item) _idOf;
  final Map<String, T> _items;
  final StreamController<List<T>> _changes =
      StreamController<List<T>>.broadcast();

  /// Current items in insertion order.
  List<T> get items => List.unmodifiable(_items.values);

  /// Emits the current items, then the items after every change.
  Stream<List<T>> watch() async* {
    yield items;
    yield* _changes.stream;
  }

  /// Adds or replaces [item].
  void put(T item) {
    _items[_idOf(item)] = item;
    _changes.add(items);
  }

  /// Removes the item with [id] if present.
  void remove(String id) {
    _items.remove(id);
    _changes.add(items);
  }

  /// Removes every item matching [test].
  void removeWhere(bool Function(T item) test) {
    _items.removeWhere((_, item) => test(item));
    _changes.add(items);
  }
}
