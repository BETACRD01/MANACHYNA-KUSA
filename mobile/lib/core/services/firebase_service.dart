import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static StreamSubscription<RemoteMessage>? _onMessageSubscription;

  static FirebaseMessaging get messaging => FirebaseMessaging.instance;
  static bool get isInitialized => _isInitialized;

  static Future<bool> initialize() async {
    try {
      if (_isInitialized) return true;

      if (Firebase.apps.isEmpty) {
        if (kDebugMode) {
          debugPrint('Firebase.initializeApp() no se ha ejecutado');
        }
        return false;
      }

      await _initializeMessaging();
      _isInitialized = true;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al inicializar FirebaseService: $e');
      }
      _isInitialized = false;
      return false;
    }
  }

  static Future<void> _initializeMessaging() async {
    try {
      // Solicitar permisos
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        debugPrint(
          'Estado permisos notificaciones: ${settings.authorizationStatus}',
        );
      }

      // Obtener y persistir el FCM token
      final token = await messaging.getToken();
      if (token != null) {
        if (kDebugMode) {
          debugPrint('FCM Token: $token');
        }
        await _saveTokenToDatabase(token);
      }

      // Escuchar actualizaciones del token (se renueva automáticamente)
      messaging.onTokenRefresh.listen((newToken) async {
        if (kDebugMode) {
          debugPrint('FCM Token renovado: $newToken');
        }
        await _saveTokenToDatabase(newToken);
      });

      // App en primer plano
      _onMessageSubscription?.cancel();
      _onMessageSubscription = FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          if (kDebugMode) {
            debugPrint(
                'Mensaje en primer plano: ${message.notification?.title}');
          }
          _handleMessage(message);
        },
      );

      // App en background (usuario toca la notificación)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          debugPrint(
              'App abierta desde notificación: ${message.notification?.title}');
        }
        _handleMessage(message);
      });

      // App cerrada (usuario toca la notificación que abrió la app)
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        if (kDebugMode) {
          debugPrint(
              'App iniciada desde notificación: ${initialMessage.notification?.title}');
        }
        _handleMessage(initialMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al inicializar messaging: $e');
      }
    }
  }

  // Guarda el FCM token en Supabase asociado al usuario actual
  static Future<void> _saveTokenToDatabase(String token) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase.from('users').update({
        'fcm_token': token,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('uid', userId);

      if (kDebugMode) debugPrint('FCM Token guardado en base de datos');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al guardar FCM token: $e');
      }
    }
  }

  // Maneja el contenido del mensaje recibido
  static void _handleMessage(RemoteMessage message) {
    // Aquí puedes navegar a una pantalla específica según message.data
    // Ejemplo: if (message.data['type'] == 'booking') { ... }
    if (kDebugMode) {
      debugPrint('Datos del mensaje: ${message.data}');
    }
  }

  static Future<bool> ensureInitialized() async {
    if (!_isInitialized) return initialize();
    return true;
  }

  // Cancela suscripciones activas (útil al cerrar sesión)
  static void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageSubscription = null;
    _isInitialized = false;
  }
}
