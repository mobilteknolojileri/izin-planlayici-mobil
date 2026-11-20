/// Outcome of an operation that can fail in an expected way.
///
/// Repositories and services return [Result] instead of throwing, so callers
/// must handle both cases. Programming errors still throw.
sealed class Result<T> {
  const new();

  /// A successful result holding [value].
  const factory ok(T value) = Ok<T>;

  /// A failed result holding [error].
  const factory error(Exception error) = Err<T>;
}

/// Successful [Result].
final class Ok<T> extends Result<T> {
  /// Creates a successful result.
  const new(this.value);

  /// The produced value.
  final T value;
}

/// Failed [Result].
final class Err<T> extends Result<T> {
  /// Creates a failed result.
  const new(this.error);

  /// What went wrong.
  final Exception error;
}
