import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/services/app_initializer.dart';
import 'screens/common/init_error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES');

  final bool firebaseOk = await initFirebaseCore();
  final bool supabaseOk = await initSupabase();

  if (firebaseOk) await initFirebaseMessaging();
  if (!supabaseOk) {
    runApp(const InitErrorApp());
    return;
  }

  runApp(const ManachynaKusaApp());
}
