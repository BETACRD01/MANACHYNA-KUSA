import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as dev;
// Comentado temporalmente flutter_local_notifications
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  // Comentado temporalmente
  // static final FlutterLocalNotificationsPlugin _localNotifications =
  //     FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Configurar notificaciones locales - comentado temporalmente
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');

    // const InitializationSettings initializationSettings =
    //     InitializationSettings(
    //   android: initializationSettingsAndroid,
    // );

    // await _localNotifications.initialize(initializationSettings);

    // Configurar Firebase Messaging
    await _messaging.requestPermission();

    // Manejar mensajes cuando la app está en primer plano
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Manejar mensajes cuando la app está en segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Temporalmente solo imprimir el mensaje
    dev.log('Mensaje en primer plano: ${message.notification?.title}');
    // _showLocalNotification(
    //   title: message.notification?.title ?? 'Nueva notificación',
    //   body: message.notification?.body ?? '',
    // );
  }

  static void _handleBackgroundMessage(RemoteMessage message) {
    dev.log('Mensaje en segundo plano: ${message.notification?.title}');
  }

  // Comentado temporalmente
  // static Future<void> _showLocalNotification({
  //   required String title,
  //   required String body,
  // }) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'manachiy_channel',
  //     'Manachyna Kusa Notifications',
  //     channelDescription:
  //         'Notificaciones de la aplicacion DESARROLLO DE APLICACION MOVIL MULTISERVICIO "MANACHYNA KUSA"',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await _localNotifications.show(
  //     0,
  //     title,
  //     body,
  //     platformChannelSpecifics,
  //   );
  // }

  static Future<void> sendBookingNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    // Aquí implementarías el envío de notificaciones push
    // usando Firebase Cloud Functions o tu backend
    dev.log('Enviando notificación a $userId: $title');
  }
}
