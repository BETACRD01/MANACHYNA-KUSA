import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';
import '../models/user_model.dart';

class NotificationProvider extends ChangeNotifier {
  static const String _prefsKey = 'app_notifications';

  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  List<NotificationModel> get unread =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unread.length;

  // ─── Load & Persist ───────────────────────────────────────────────────────

  Future<void> loadNotifications(UserModel? user) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);

    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      _notifications =
          decoded.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (user != null) {
      _notifications = _generateInitialNotifications(user);
      await _persist();
    }

    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(_notifications.map((n) => n.toJson()).toList()),
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1 || _notifications[index].isRead) return;
    _notifications[index] = _notifications[index].copyWith(isRead: true);
    notifyListeners();
    await _persist();
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
    await _persist();
  }

  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? relatedId,
  }) async {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      isRead: false,
      type: type,
      relatedId: relatedId,
    );
    _notifications.insert(0, notification);
    notifyListeners();
    await _persist();
  }

  // ─── Mock Initial Data ────────────────────────────────────────────────────

  List<NotificationModel> _generateInitialNotifications(UserModel user) {
    final now = DateTime.now();
    final isProvider = user.userType == UserType.provider;
    final name = user.name.split(' ').first;

    if (isProvider) {
      return [
        NotificationModel(
          id: '1',
          title: '¡Nueva reserva recibida!',
          body: 'Un cliente solicitó tus servicios para el ${_formatDate(now.add(const Duration(days: 2)))}.',
          createdAt: now.subtract(const Duration(minutes: 5)),
          isRead: false,
          type: NotificationType.booking,
          relatedId: null,
        ),
        NotificationModel(
          id: '2',
          title: 'Reserva confirmada',
          body: 'Tu servicio del ${_formatDate(now.subtract(const Duration(days: 1)))} fue confirmado por el cliente.',
          createdAt: now.subtract(const Duration(hours: 2)),
          isRead: false,
          type: NotificationType.booking,
          relatedId: null,
        ),
        NotificationModel(
          id: '3',
          title: 'Nueva calificación',
          body: 'Un cliente dejó una reseña de ⭐⭐⭐⭐⭐ en tu perfil. ¡Sigue así, $name!',
          createdAt: now.subtract(const Duration(hours: 6)),
          isRead: false,
          type: NotificationType.system,
          relatedId: null,
        ),
        NotificationModel(
          id: '4',
          title: 'Mensaje de un cliente',
          body: 'Un cliente te ha enviado un mensaje sobre su próxima reserva.',
          createdAt: now.subtract(const Duration(days: 1)),
          isRead: true,
          type: NotificationType.chat,
          relatedId: null,
        ),
        NotificationModel(
          id: '5',
          title: 'Reserva cancelada',
          body: 'Un cliente canceló la reserva programada para el ${_formatDate(now.add(const Duration(days: 3)))}.',
          createdAt: now.subtract(const Duration(days: 1, hours: 4)),
          isRead: true,
          type: NotificationType.booking,
          relatedId: null,
        ),
        NotificationModel(
          id: '6',
          title: '¡Bienvenido a MANACHYNA KUSA!',
          body: 'Tu cuenta de proveedor ha sido verificada. Ahora puedes recibir reservas de clientes en tu área.',
          createdAt: now.subtract(const Duration(days: 7)),
          isRead: true,
          type: NotificationType.system,
          relatedId: null,
        ),
      ];
    } else {
      return [
        NotificationModel(
          id: '1',
          title: 'Reserva confirmada ✓',
          body: 'Tu servicio de limpieza ha sido confirmado para el ${_formatDate(now.add(const Duration(days: 1)))}.',
          createdAt: now.subtract(const Duration(minutes: 10)),
          isRead: false,
          type: NotificationType.booking,
          relatedId: null,
        ),
        NotificationModel(
          id: '2',
          title: 'Tu proveedor está en camino',
          body: 'El proveedor confirmó que llegará pronto. ¡Prepárate para recibirlo!',
          createdAt: now.subtract(const Duration(hours: 1)),
          isRead: false,
          type: NotificationType.booking,
          relatedId: null,
        ),
        NotificationModel(
          id: '3',
          title: 'Mensaje del proveedor',
          body: 'Tu proveedor te envió un mensaje sobre los detalles del servicio.',
          createdAt: now.subtract(const Duration(hours: 3)),
          isRead: false,
          type: NotificationType.chat,
          relatedId: null,
        ),
        NotificationModel(
          id: '4',
          title: 'Califica tu servicio',
          body: '¿Cómo estuvo tu experiencia? Deja tu reseña y ayuda a otros usuarios.',
          createdAt: now.subtract(const Duration(days: 1)),
          isRead: true,
          type: NotificationType.system,
          relatedId: null,
        ),
        NotificationModel(
          id: '5',
          title: 'Servicio completado',
          body: 'Tu servicio del ${_formatDate(now.subtract(const Duration(days: 2)))} fue marcado como completado.',
          createdAt: now.subtract(const Duration(days: 2)),
          isRead: true,
          type: NotificationType.booking,
          relatedId: null,
        ),
        NotificationModel(
          id: '6',
          title: '¡Bienvenido/a, $name!',
          body: 'Gracias por unirte a MANACHYNA KUSA. Explora los servicios disponibles en tu zona.',
          createdAt: now.subtract(const Duration(days: 7)),
          isRead: true,
          type: NotificationType.system,
          relatedId: null,
        ),
      ];
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]}';
  }
}
