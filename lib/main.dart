import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:izin_planla/app.dart';
import 'package:material_ui/material_ui.dart';

/// Starts the app with Turkish date formatting loaded.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr');
  runApp(const ProviderScope(child: App()));
}
