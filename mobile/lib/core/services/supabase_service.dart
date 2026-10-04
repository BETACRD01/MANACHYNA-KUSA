import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      if (kDebugMode) debugPrint('SupabaseService: cliente no disponible: $e');
      rethrow;
    }
  }

  static User? get currentUser {
    try {
      return client.auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  // Expone la sesión actual para verificar expiración desde otros servicios
  static Session? get currentSession {
    try {
      return client.auth.currentSession;
    } catch (_) {
      return null;
    }
  }

  // Verifica si hay sesión activa y no expirada
  static Future<bool> ensureAuthenticated() async {
    try {
      final session = client.auth.currentSession;
      if (session == null) return false;
      return !session.isExpired;
    } catch (_) {
      return false;
    }
  }
}
