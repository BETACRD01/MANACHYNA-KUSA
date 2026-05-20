import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'core/services/firebase_service.dart';
import 'core/config/supabase_config.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar Firebase Core
  bool firebaseOk = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseOk = true;
    if (kDebugMode) debugPrint('Firebase Core inicializado');
  } catch (e) {
    if (kDebugMode) debugPrint('Firebase Core error (no fatal): $e');
  }

  // 2. Inicializar Supabase (independiente de Firebase)
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    if (kDebugMode) debugPrint('Supabase inicializado');
  } catch (e) {
    if (kDebugMode) debugPrint('Supabase error (no fatal): $e');
  }

  // 3. Inicializar Firebase Messaging solo si:
  //    - Firebase Core se inicializó correctamente
  //    - No es entorno web (Messaging no soportado en web ni macOS)
  if (firebaseOk && !kIsWeb) {
    try {
      await FirebaseService.initialize();
      if (kDebugMode) debugPrint('Firebase Messaging inicializado');
    } catch (e) {
      if (kDebugMode) debugPrint('Firebase Messaging error (no fatal): $e');
    }
  } else {
    if (kDebugMode) {
      debugPrint(
        'Firebase Messaging omitido '
        '(firebaseOk=$firebaseOk, kIsWeb=$kIsWeb)',
      );
    }
  }

  runApp(const ManachynaKusaApp());
}
