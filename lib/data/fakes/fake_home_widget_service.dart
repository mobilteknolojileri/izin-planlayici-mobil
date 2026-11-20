import 'package:izin_planla/data/services/home_widget/home_widget_service.dart';

/// [HomeWidgetService] that does nothing.
class FakeHomeWidgetService implements HomeWidgetService {
  @override
  Future<void> refresh() async {}

  @override
  Future<void> requestPin() async {}
}
