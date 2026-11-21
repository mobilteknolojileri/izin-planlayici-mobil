/// Outcome of saving the leave form.
sealed class LeaveFormSaveResult {
  const new();
}

/// The form has errors, nothing was saved. The errors are now shown.
final class LeaveFormInvalid extends LeaveFormSaveResult {
  /// Creates the result.
  const new();
}

/// Saving failed in the storage.
final class LeaveFormFailed extends LeaveFormSaveResult {
  /// Creates the result.
  const new();
}

/// The leave was saved.
final class LeaveFormSaved extends LeaveFormSaveResult {
  /// Creates the result. [undo] restores the previous version of an
  /// edited leave and is null for a new one.
  const new({this.undo});

  /// Puts the edited leave back as it was, null for a new leave.
  final Future<void> Function()? undo;
}
