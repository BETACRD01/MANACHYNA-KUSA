import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../firebase_options.dart';
import 'firebase_service.dart';
import '../config/supabase_config.dart';

Future<bool> initFirebaseCore() async {
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

Future<bool> initSupabase() async {
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.anonKey,
    );
    _log('Supabase initialized');
    return true;
  } catch (e) {
    _log('Supabase error (fatal): $e');
    return false;
  }
}

Future<void> initFirebaseMessaging() async {
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
