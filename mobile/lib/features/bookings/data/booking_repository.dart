import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../../models/booking/booking_model.dart';

class BookingRepository {
  BookingRepository({SupabaseClient? client})
    : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  static const String _bookingQuery = '*, reviews(rating, comment)';

  Future<List<BookingModel>> loadUserBookings(
    String userId, {
    required bool isProvider,
  }) async {
    final field = isProvider ? 'provider_uid' : 'client_uid';
    final rows = await _client
        .from('bookings')
        .select(_bookingQuery)
        .eq(field, userId)
        .order('created_at', ascending: false);

    return rows.map((row) => BookingModel.fromSupabase(row)).toList();
  }

  Future<BookingModel?> getBookingById(String bookingId) async {
    final row = await _client
        .from('bookings')
        .select(_bookingQuery)
        .eq('id', bookingId)
        .maybeSingle();

    if (row == null) return null;
    return BookingModel.fromSupabase(row);
  }

  /// Crea una reserva y retorna la fila recién insertada.
  ///
  /// Usa `.single()` en lugar de `.limit(1)` + chequeo de lista vacía porque:
  ///   - La política RLS `bookings_select_participants_or_admin` garantiza que
  ///     el cliente puede leer sus propias reservas (client_uid = auth.uid()).
  ///   - La política `bookings_insert_client` solo permite insertar con ese
  ///     mismo uid, por lo que el SELECT post-insert siempre tendrá acceso.
  ///   - Si el insert falla por cualquier razón real, `.single()` lanza una
  ///     excepción en vez de devolver null silenciosamente.
  Future<BookingModel> createBooking(BookingModel booking) async {
    final row = await _client
        .from('bookings')
        .insert(booking.toInsertRow())
        .select()
        .single();

    return BookingModel.fromSupabase(row);
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) {
    final updateData = <String, dynamic>{
      'status': bookingStatusToSupabase(status),
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (status == BookingStatus.completed) {
      updateData['completed_at'] = DateTime.now().toIso8601String();
    }

    return _client.from('bookings').update(updateData).eq('id', bookingId);
  }

  Future<void> cancelBooking(String bookingId, String reason) {
    return _client
        .from('bookings')
        .update({
          'status': 'cancelled',
          'cancellation_reason': reason,
          'cancelled_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', bookingId);
  }

  /// Crea o actualiza la reseña de una reserva.
  ///
  /// [rating] debe estar entre 1 y 5 inclusive.
  /// Lanza [ArgumentError] si el valor está fuera de rango.
  Future<void> rateBooking(
    BookingModel booking,
    double rating,
    String? review,
  ) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError.value(
        rating,
        'rating',
        'El rating debe estar entre 1 y 5 inclusive.',
      );
    }

    return _client.from('reviews').upsert({
      'booking_id': booking.id,
      'client_uid': booking.clientId,
      'provider_uid': booking.providerId,
      'rating': rating.round(),
      'comment': review,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'booking_id');
  }
}
