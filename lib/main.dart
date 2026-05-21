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

  final bool firebaseOk = await _initFirebaseCore();
  final bool supabaseOk = await _initSupabase();

  if (firebaseOk) await _initFirebaseMessaging();

  if (!supabaseOk) {
    runApp(const _InitErrorApp());
    return;
  }

  runApp(const ManachynaKusaApp());
}

// ---------------------------------------------------------------------------
// Inicialización helpers
// ---------------------------------------------------------------------------

Future<bool> _initFirebaseCore() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _log('Firebase Core initialized');
    return true;
  } catch (e) {
    _log('Firebase Core error (non-fatal): $e');
    return false;
  }
}

Future<bool> _initSupabase() async {
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    _log('Supabase initialized');
    return true;
  } catch (e) {
    _log('Supabase error (fatal): $e');
    return false;
  }
}

Future<void> _initFirebaseMessaging() async {
  // Firebase Messaging no está soportado en web ni en macOS desktop.
  final bool supported =
      !kIsWeb && defaultTargetPlatform != TargetPlatform.macOS;

  if (!supported) {
    _log(
      'Firebase Messaging skipped '
      '(kIsWeb=$kIsWeb, platform=$defaultTargetPlatform)',
    );
    return;
  }

  try {
    await FirebaseService.initialize();
    _log('Firebase Messaging initialized');
  } catch (e) {
    _log('Firebase Messaging error (non-fatal): $e');
  }
}

void _log(String message) {
  if (kDebugMode) debugPrint('[main] $message');
}

// ---------------------------------------------------------------------------
// Pantalla de error de inicialización
// Se muestra solo si Supabase no pudo inicializarse.
// ---------------------------------------------------------------------------

class _InitErrorApp extends StatelessWidget {
  const _InitErrorApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _InitErrorScreen(),
    );
  }
}

class _InitErrorScreen extends StatelessWidget {
  const _InitErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: Color(0xFF146A21),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sin conexión al servidor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2E1E),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'No fue posible conectar con el servidor.\n'
                'Verifica tu conexión a internet y vuelve a intentarlo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              _RetryButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        // Para reinicio en caliente usar el paquete `restart_app`.
        // En debug se puede usar SystemNavigator.pop().
        onPressed: () {},
        icon: const Icon(Icons.refresh_rounded),
        label: const Text(
          'Reintentar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF146A21),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
