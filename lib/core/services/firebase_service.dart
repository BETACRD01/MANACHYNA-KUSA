import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static bool _isInitialized = false;

  static FirebaseMessaging get messaging => FirebaseMessaging.instance;

  static bool get isInitialized => _isInitialized;

  static Future<bool> initialize() async {
    try {
      if (_isInitialized) {
        return true;
      }

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

      final token = await messaging.getToken();
      if (kDebugMode) {
        debugPrint('FCM Token: $token');
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          debugPrint('Mensaje recibido: ${message.notification?.title}');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al inicializar messaging: $e');
      }
    }
  }

  static Future<bool> ensureInitialized() async {
    if (!_isInitialized) {
      return initialize();
    }
    return true;
  }
}
