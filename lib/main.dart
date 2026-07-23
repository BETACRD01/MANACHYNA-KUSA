import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/app_initializer.dart';
import 'screens/common/init_error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool firebaseOk = await initFirebaseCore();
  final bool supabaseOk = await initSupabase();

  if (firebaseOk) await initFirebaseMessaging();

  if (!supabaseOk) {
    runApp(const InitErrorApp());
    return;
  }

  runApp(const ManachynaKusaApp());
}
