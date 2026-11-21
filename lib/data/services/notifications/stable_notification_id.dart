import 'dart:convert';

/// Notification id of the test notification. [stableNotificationId] never
/// returns it.
const testNotificationId = 0;

/// Largest notification id, Android ids are 32-bit signed integers.
const maxNotificationId = 0x7fffffff;

/// Turns a reminder key such as `leave-start:<recordId>` into a notification
/// id between 1 and [maxNotificationId].
///
/// Uses 32-bit FNV-1a over the UTF-8 bytes, because `String.hashCode` is not
/// guaranteed to stay the same between app versions and Android keeps
/// scheduled notifications across updates.
int stableNotificationId(String key) {
  var hash = 0x811c9dc5;
  for (final byte in utf8.encode(key)) {
    hash ^= byte;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  final id = hash & maxNotificationId;
  return id == testNotificationId ? 1 : id;
}
