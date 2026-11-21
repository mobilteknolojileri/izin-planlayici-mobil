import 'package:flutter/foundation.dart';
import 'package:izin_planla/domain/models/models.dart';

/// One leave in the list with the days it costs.
@immutable
class LeaveListItem {
  /// Creates the item.
  const new({required this.record, required this.planned, this.deducted});

  /// The leave.
  final LeaveRecord record;

  /// Whether the leave starts after today.
  final bool planned;

  /// Annual leave days deducted for a whole day leave, from the day
  /// counter. Null for leave that does not reduce the balance and for half
  /// day or hourly leave.
  final double? deducted;
}
