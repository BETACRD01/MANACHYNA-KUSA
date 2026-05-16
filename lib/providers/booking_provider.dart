import 'package:flutter/material.dart';

import '../features/bookings/data/booking_repository.dart';
import '../models/booking_model.dart';

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

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadUserBookings(String userId, {bool isProvider = false}) async {
    _setLoading(true);
    _setError(null);

    try {
      _bookings = await _repository.loadUserBookings(
        userId,
        isProvider: isProvider,
      );
    } catch (e) {
      _setError('Error al cargar reservas');
    } finally {
      _setLoading(false);
    }
  }

  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      return await _repository.getBookingById(bookingId);
    } catch (e) {
      _setError('Error al obtener reserva');
      return null;
    }
  }

  Future<bool> createBooking(BookingModel booking) async {
    _setLoading(true);
    _setError(null);

    try {
      final created = await _repository.createBooking(booking);
      if (created != null) {
        _bookings.insert(0, created);
      }

      return true;
    } catch (e) {
      _setError('Error al crear reserva');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateBookingStatus(String bookingId, BookingStatus status) async {
    _setLoading(true);
    _setError(null);

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
      _setError('Error al actualizar estado de reserva');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelBooking(String bookingId, String reason) async {
    _setLoading(true);
    _setError(null);

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
      _setError('Error al cancelar reserva');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> rateBooking(String bookingId, double rating, String? review) async {
    _setLoading(true);
    _setError(null);

    try {
      final booking = _bookings.firstWhere((item) => item.id == bookingId);

      await _repository.rateBooking(booking, rating, review);

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
      _setError('Error al calificar servicio');
      return false;
    } finally {
      _setLoading(false);
    }
  }

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
