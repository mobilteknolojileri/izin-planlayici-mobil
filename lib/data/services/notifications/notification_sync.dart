import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/data/services/notifications/notification_service.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Keeps the scheduled reminders in step with the data.
///
/// Every change to the settings, the profiles or any profile's leaves
/// calls [NotificationService.reschedule], which merges overlapping calls.
/// The first values of the streams schedule once at start, so a restore or
/// an app update is covered without extra calls.
class NotificationSync {
  /// Creates the sync. Call [start] once and [dispose] when done.
  new({
    required this._service,
    required this._settings,
    required this._profiles,
    required this._leaves,
  });

  final NotificationService _service;
  final SettingsRepository _settings;
  final ProfileRepository _profiles;
  final LeaveRepository _leaves;

  final List<StreamSubscription<Object?>> _subscriptions = [];
  final Map<String, StreamSubscription<List<LeaveRecord>>> _leaveSubscriptions =
      {};

  /// Starts listening.
  void start() {
    _subscriptions
      ..add(_settings.watch().listen((_) => _reschedule(), onError: _log))
      ..add(_profiles.watchAll().listen(_watchLeaves, onError: _log));
  }

  /// Recomputes the reminders now, for example when the app is resumed and
  /// a day may have passed.
  void refresh() => _reschedule();

  /// Stops listening.
  Future<void> dispose() async {
    final all = [..._subscriptions, ..._leaveSubscriptions.values];
    _subscriptions.clear();
    _leaveSubscriptions.clear();
    await Future.wait(all.map((s) => s.cancel()));
  }

  void _watchLeaves(List<Profile> profiles) {
    final ids = {for (final p in profiles) p.id};
    for (final id in _leaveSubscriptions.keys.toList()) {
      if (!ids.contains(id)) {
        unawaited(_leaveSubscriptions.remove(id)?.cancel());
      }
    }
    for (final id in ids) {
      _leaveSubscriptions[id] ??= _leaves
          .watchForProfile(id)
          .listen((_) => _reschedule(), onError: _log);
    }
    _reschedule();
  }

  void _reschedule() => unawaited(_service.reschedule());

  // Reminders are best effort, a failing stream must not stop the others.
  void _log(Object error) => debugPrint('Reminder sync stream failed: $error');
}
