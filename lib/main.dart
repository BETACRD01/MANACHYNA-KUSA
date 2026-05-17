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

  try {
    // 1. Inicializar Firebase Core
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Inicializar Supabase para datos y storage
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.publishableKey,
    );

    // 3. Inicializar Firebase Messaging
    await FirebaseService.initialize();

    // Solo mostrar logs en modo debug
    if (kDebugMode) {
      debugPrint(
        "Firebase Messaging y Supabase inicializados correctamente",
      );
    }

    runApp(const ManachynaKusaApp());
  } catch (e) {
    if (kDebugMode) {
      debugPrint("Error al inicializar Firebase: $e");
    }
    // Mostrar una pantalla de error o app básica
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Error al inicializar la aplicación\n$e',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
