import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';

/// Names of leave types, shared by the home, leaves and leave form screens.
/// Date ranges use `AppFormat.dayRange`.
abstract final class LeaveTexts {
  /// Name of [type], such as "Yıllık izin".
  static String typeLabel(AppLocalizations l10n, LeaveType type) =>
      switch (type) {
        LeaveType.annual => l10n.leaveFormTypeAnnual,
        LeaveType.sick => l10n.leaveFormTypeSick,
        LeaveType.unpaid => l10n.leaveFormTypeUnpaid,
        LeaveType.maternity => l10n.leaveFormTypeMaternity,
        LeaveType.paternity => l10n.leaveFormTypePaternity,
        LeaveType.marriage => l10n.leaveFormTypeMarriage,
        LeaveType.bereavement => l10n.leaveFormTypeBereavement,
        LeaveType.adoption => l10n.leaveFormTypeAdoption,
        LeaveType.disabledChildCare => l10n.leaveFormTypeDisabledChildCare,
        LeaveType.union => l10n.leaveFormTypeUnion,
        LeaveType.excuse => l10n.leaveFormTypeExcuse,
        LeaveType.travel => l10n.leaveFormTypeTravel,
        LeaveType.other => l10n.leaveFormTypeOther,
      };

  /// Name of [record]: the user's own name for an "other" leave, else the
  /// type name.
  static String recordLabel(AppLocalizations l10n, LeaveRecord record) {
    final custom = record.customTypeName?.trim() ?? '';
    return record.type == LeaveType.other && custom.isNotEmpty
        ? custom
        : typeLabel(l10n, record.type);
  }
}
