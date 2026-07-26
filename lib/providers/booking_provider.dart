import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../features/bookings/data/booking_repository.dart';
import '../models/booking/booking_model.dart';

class BookingProvider with ChangeNotifier {
  BookingProvider({
    required BookingRepository repository,
  }) : _repository = repository;

  final BookingRepository _repository;
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------------------------------------------------------------------------
  // HELPERS DE ESTADO INTERNOS
  // ---------------------------------------------------------------------------

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Inicia una operación: activa loading, limpia error, y notifica UNA sola vez.
  void _beginOperation() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // OPERACIONES
  // ---------------------------------------------------------------------------

  Future<void> loadUserBookings(String userId, {bool isProvider = false}) async {
    _beginOperation();

    try {
      _bookings = await _repository.loadUserBookings(
        userId,
        isProvider: isProvider,
      );
    } catch (e) {
      debugPrint('[BookingProvider.loadUserBookings] $e');
      _setError('Error al cargar reservas');
    } finally {
      _setLoading(false);
    }
  }

  /// Consulta puntual de detalle — NO activa _setLoading globalmente para no
  /// bloquear la UI completa. El widget llamante maneja su propio estado visual.
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      return await _repository.getBookingById(bookingId);
    } catch (e) {
      debugPrint('[BookingProvider.getBookingById] $e');
      _setError('Error al obtener reserva');
      return null;
    }
  }

  Future<bool> createBooking(BookingModel booking) async {
    _beginOperation();

    try {
      // BookingRepository.createBooking usa .single() y retorna BookingModel
      // no nulable. Si el insert falla, .single() lanza una excepción que
      // es capturada por el catch de abajo.
      final created = await _repository.createBooking(booking);
      _bookings.insert(0, created);
      return true;
    } catch (e) {
      debugPrint('[BookingProvider.createBooking] $e');
      _setError('Error al crear reserva');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateBookingStatus(String bookingId, BookingStatus status) async {
    _beginOperation();

    try {
      await _repository.updateBookingStatus(bookingId, status);

      final index = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
          completedAt: status == BookingStatus.completed ? DateTime.now() : null,
        );
      }

      return true;
    } catch (e) {
      debugPrint('[BookingProvider.updateBookingStatus] $e');
      _setError('Error al actualizar estado de reserva');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelBooking(String bookingId, String reason) async {
    _beginOperation();

    try {
      await _repository.cancelBooking(bookingId, reason);

      final index = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: BookingStatus.cancelled,
          cancellationReason: reason,
          updatedAt: DateTime.now(),
        );
      }

      return true;
    } catch (e) {
      debugPrint('[BookingProvider.cancelBooking] $e');
      _setError('Error al cancelar reserva');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Califica una reserva.
  ///
  /// Si la reserva no está en la lista local _bookings (puede pasar al llegar
  /// desde un deep link o notificación sin haber llamado a loadUserBookings),
  /// se trae del repositorio como fallback antes de calificar.
  Future<bool> rateBooking(String bookingId, double rating, String? review) async {
    _beginOperation();

    try {
      // Intentamos encontrar la reserva en la lista local primero (O(n)).
      // Si no está (deep link, notificación, etc.), la traemos del repositorio.
      BookingModel? booking = _bookings.cast<BookingModel?>().firstWhere(
        (item) => item?.id == bookingId,
        orElse: () => null,
      );

      if (booking == null) {
        debugPrint('[BookingProvider.rateBooking] bookingId=$bookingId no estaba '
            'en _bookings — cargando desde repositorio como fallback.');
        booking = await _repository.getBookingById(bookingId);
      }

      if (booking == null) {
        _setError('No se encontró la reserva. Recarga la lista e intenta de nuevo.');
        return false;
      }

      await _repository.rateBooking(booking, rating, review);

      // Actualiza la copia local si existe en la lista.
      final index = _bookings.indexWhere((item) => item.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          rating: rating,
          review: review,
          updatedAt: DateTime.now(),
        );
      }

      return true;
    } catch (e) {
      debugPrint('[BookingProvider.rateBooking] $e');
      _setError('Error al calificar servicio');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // GETTERS DE CONVENIENCIA (SÍNCRONOS)
  // ---------------------------------------------------------------------------

  List<BookingModel> getBookingsByStatus(BookingStatus status) {
    return _bookings.where((booking) => booking.status == status).toList();
  }

  List<BookingModel> getUpcomingBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      return booking.status == BookingStatus.confirmed &&
          booking.scheduledDate.isAfter(now);
    }).toList();
  }

  List<BookingModel> getCompletedBookings() {
    return _bookings
        .where((booking) => booking.status == BookingStatus.completed)
        .toList();
  }

  void clearError() {
    _setError(null);
  }
}
