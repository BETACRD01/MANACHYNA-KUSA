import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_service.dart';

/// Complementa a FirebaseService con lógica específica de notificaciones.
/// FirebaseService maneja: permisos, token, listeners de mensajes.
/// NotificationService maneja: procesamiento de mensajes y envío via backend.
class NotificationService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Garantiza que FirebaseService esté activo antes de continuar
      final firebaseReady = await FirebaseService.ensureInitialized();
      if (!firebaseReady) {
        if (kDebugMode) {
          debugPrint('NotificationService: Firebase no disponible');
        }
        return;
      }

      _isInitialized = true;
      if (kDebugMode) {
        debugPrint('NotificationService inicializado');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al inicializar NotificationService: $e');
      }
    }
  }

  /// Procesa un mensaje recibido con la app en primer plano.
  /// Llamar desde FirebaseService._handleMessage() según el contexto.
  static void handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('Mensaje en primer plano: ${message.notification?.title}');
      debugPrint('Datos: ${message.data}');
    }

    // Aquí puedes mostrar un banner, snackbar o notificación local
    // según el tipo de mensaje recibido en message.data['type']
    _routeMessage(message);
  }

  /// Procesa un mensaje cuando el usuario toca la notificación
  /// con la app en background o cerrada.
  static void handleBackgroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint(
          'App abierta desde notificación: ${message.notification?.title}');
      debugPrint('Datos: ${message.data}');
    }

    _routeMessage(message);
  }

  /// Enruta el mensaje según su tipo para navegación o acciones específicas.
  static void _routeMessage(RemoteMessage message) {
    final type = message.data['type'] as String?;

    switch (type) {
      case 'booking':
        if (kDebugMode) {
          debugPrint(
              'Navegar a detalle de reserva: ${message.data['booking_id']}');
        }
        // NavigationService.navigateTo(AppRoutes.bookingDetail, arguments: ...);
        break;
      case 'chat':
        if (kDebugMode) {
          debugPrint('Navegar a chat: ${message.data['chat_id']}');
        }
        // NavigationService.navigateTo(AppRoutes.chat, arguments: ...);
        break;
      case 'task':
        if (kDebugMode) {
          debugPrint('Navegar a tarea: ${message.data['task_id']}');
        }
        // NavigationService.navigateTo(AppRoutes.providerTaskFeed);
        break;
      default:
        if (kDebugMode) {
          debugPrint('Tipo de notificación no reconocido: $type');
        }
    }
  }

  /// Envía una notificación push mediante tu backend o Firebase Cloud Functions.
  /// No es posible enviar notificaciones directamente desde el cliente Flutter
  /// sin un servidor intermedio.
  ///
  /// Ejemplo de implementación futura:
  /// POST https://tu-backend.com/api/notifications
  /// { "user_id": userId, "title": title, "body": body, "data": data }
  static Future<void> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    if (kDebugMode) {
      debugPrint('sendPushNotification → userId: $userId, title: $title');
      debugPrint('Implementar llamada al backend o Cloud Functions');
    }
  }
}
